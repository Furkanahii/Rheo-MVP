import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Loads the React Journey web app from bundled assets inside a WebView.
///
/// Strategy: Copy assets to temp dir → start a local HTTP server → load via
/// http://localhost so that all relative resource references (JS, CSS, images)
/// work without file:// permissions issues.
///
/// Asset discovery uses Flutter's official AssetManifest API which supports
/// both legacy AssetManifest.json and modern AssetManifest.bin formats.
class JourneyWebViewScreen extends StatefulWidget {
  const JourneyWebViewScreen({super.key});
  @override
  State<JourneyWebViewScreen> createState() => _JourneyWebViewScreenState();
}

class _JourneyWebViewScreenState extends State<JourneyWebViewScreen> {
  WebViewController? _controller;
  HttpServer? _server;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Wrap in its own zone so FFI-level errors (e.g. objective_c.dylib on
    // iOS 26 beta) don't escape to the root zone and crash the whole app.
    runZonedGuarded(
      () => _initWebView(),
      (error, stack) {
        debugPrint('⚠️ JourneyWebView zone error: $error');
        if (mounted) {
          setState(() {
            _error = 'Yükleme başarısız. Lütfen tekrar deneyin.';
            _loading = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _server?.close(force: true);
    super.dispose();
  }

  Future<void> _initWebView() async {
    try {
      // 1) Copy all bundled assets to a temp directory
      final webDir = await _copyAssets();

      // 2) Start a local HTTP server serving from that directory
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      _server = server;
      final port = server.port;

      server.listen((HttpRequest request) async {
        try {
          String path = request.uri.path;
          if (path == '/' || path.isEmpty) path = '/index.html';

          final file = File('${webDir.path}$path');
          if (await file.exists()) {
            final ext = path.split('.').last.toLowerCase();
            request.response.headers.set('Content-Type', _mimeType(ext));
            request.response.headers.set('Access-Control-Allow-Origin', '*');
            await request.response.addStream(file.openRead());
          } else {
            debugPrint('🔍 404: $path');
            request.response.statusCode = HttpStatus.notFound;
            request.response.write('File not found: $path');
          }
        } catch (e) {
          request.response.statusCode = HttpStatus.internalServerError;
          request.response.write('Error: $e');
        }
        await request.response.close();
      });

      // 3) Load the page in WebView via localhost
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFF0F172A))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (_) {
              if (mounted) setState(() => _loading = false);
            },
            onWebResourceError: (error) {
              // Only set error for main frame failures, not sub-resource issues
              if (error.isForMainFrame ?? true) {
                if (mounted) {
                  setState(() {
                    _error = error.description;
                    _loading = false;
                  });
                }
              }
            },
          ),
        )
        ..loadRequest(Uri.parse('http://127.0.0.1:$port/index.html'));

      if (mounted) {
        setState(() => _controller = controller);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  /// Copy all files under assets/journey-web/ to a temp directory.
  ///
  /// Uses Flutter's official AssetManifest API (supports both .json and .bin)
  /// with a hardcoded fallback list for belt-and-suspenders reliability.
  Future<Directory> _copyAssets() async {
    // getTemporaryDirectory() can fail on iOS 26.x beta simulators due to
    // an objective_c FFI issue in path_provider_foundation. Fall back to
    // getApplicationSupportDirectory() which uses a different code path.
    Directory dir;
    try {
      dir = await getTemporaryDirectory();
    } catch (e) {
      debugPrint('⚠️ getTemporaryDirectory failed ($e), trying fallback...');
      try {
        dir = await getApplicationSupportDirectory();
      } catch (e2) {
        // Last resort: use a fixed path in the app's sandbox
        debugPrint('⚠️ getApplicationSupportDirectory also failed ($e2)');
        dir = Directory('/tmp');
      }
    }
    final webDir = Directory('${dir.path}/journey-web');
    if (await webDir.exists()) await webDir.delete(recursive: true);
    await webDir.create(recursive: true);

    const prefix = 'assets/journey-web/';

    // Discover all journey-web assets
    List<String> journeyAssets = await _discoverAssets(prefix);

    debugPrint('📦 Journey assets to copy: ${journeyAssets.length}');
    for (final a in journeyAssets) {
      debugPrint('  → $a');
    }

    // Safety check: if discovery found too few assets, something is wrong
    if (journeyAssets.length < 3) {
      throw Exception(
        'Asset discovery found only ${journeyAssets.length} assets. '
        'Expected at least index.html + JS + CSS. Bundle may be corrupt.',
      );
    }

    int copied = 0;
    int failed = 0;

    for (final assetKey in journeyAssets) {
      // Derive the relative path within journey-web/
      final relativePath = assetKey.substring(prefix.length);
      final destPath = '${webDir.path}/$relativePath';

      // Ensure parent directory exists
      final lastSlash = destPath.lastIndexOf('/');
      if (lastSlash > 0) {
        final parentDir = Directory(destPath.substring(0, lastSlash));
        if (!await parentDir.exists()) {
          await parentDir.create(recursive: true);
        }
      }

      // Copy the file using binary load (not loadString) to avoid encoding issues
      try {
        final data = await rootBundle.load(assetKey);
        await File(destPath).writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
        copied++;
      } catch (e) {
        failed++;
        debugPrint('⚠️ Could not copy asset $assetKey: $e');
      }
    }

    debugPrint('✅ Copied $copied assets, $failed failed');

    // Verify critical files exist
    final indexFile = File('${webDir.path}/index.html');
    if (!await indexFile.exists()) {
      throw Exception(
        'index.html not found after copying $copied assets. '
        'Discovery found: ${journeyAssets.join(", ")}',
      );
    }

    // List all files in the output directory for debugging
    await _debugListDir(webDir, '');

    return webDir;
  }

  /// Recursively list all files in a directory for debug logging.
  Future<void> _debugListDir(Directory dir, String indent) async {
    await for (final entity in dir.list()) {
      if (entity is File) {
        final size = await entity.length();
        debugPrint('$indent📄 ${entity.path.split('/').last} ($size bytes)');
      } else if (entity is Directory) {
        debugPrint('$indent📁 ${entity.path.split('/').last}/');
        await _debugListDir(entity, '$indent  ');
      }
    }
  }

  /// Discover assets using Flutter's official AssetManifest API.
  ///
  /// This works with ALL Flutter versions:
  /// - Flutter < 3.7: reads AssetManifest.json internally
  /// - Flutter >= 3.7: reads AssetManifest.bin internally
  ///
  /// Falls back to a hardcoded list if the API fails.
  Future<List<String>> _discoverAssets(String prefix) async {
    // ── Strategy 1: Official Flutter AssetManifest API ──
    // This is the ONLY reliable way in Flutter 3.7+ (which uses AssetManifest.bin)
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final allAssets = manifest.listAssets();
      final journeyAssets = allAssets
          .where((key) => key.startsWith(prefix))
          .toList();

      if (journeyAssets.isNotEmpty) {
        debugPrint('✅ AssetManifest API: ${journeyAssets.length} journey assets');
        return journeyAssets;
      }
      debugPrint('⚠️ AssetManifest API returned 0 journey assets');
    } catch (e) {
      debugPrint('⚠️ AssetManifest API failed: $e');
    }

    // ── Strategy 2: Hardcoded fallback list ──
    // If the official API fails for any reason, use a known-good file list.
    // This MUST be updated whenever the Vite build produces new hash filenames.
    debugPrint('🔄 Falling back to hardcoded asset list...');

    final hardcodedAssets = <String>[
      '${prefix}index.html',
      '${prefix}mascot_greeting.png',
      '${prefix}mascot_happy.png',
      '${prefix}assets/index-BCJCpQLs.js',
      '${prefix}assets/index-BXRjnnp6.css',
      '${prefix}assets/HologramCard-oFVIqWVa.js',
      '${prefix}assets/LeagueView-B7MCfvh9.js',
      '${prefix}assets/MoreView-NHsebTHe.js',
      '${prefix}assets/ProfileView-C0Xa7vJC.js',
      '${prefix}assets/QuestsView-Bqqyfc-M.js',
    ];

    // Verify each hardcoded asset exists in the bundle
    final verified = <String>[];
    for (final asset in hardcodedAssets) {
      try {
        await rootBundle.load(asset);
        verified.add(asset);
      } catch (e) {
        debugPrint('⚠️ Hardcoded asset not in bundle: $asset');
      }
    }

    debugPrint('✅ Hardcoded fallback: ${verified.length}/${hardcodedAssets.length} verified');

    if (verified.isEmpty) {
      throw Exception(
        'No journey-web assets found in bundle. '
        'Neither AssetManifest API nor hardcoded fallback found any files. '
        'Check pubspec.yaml asset declarations.',
      );
    }

    return verified;
  }

  /// Return MIME type for common web file extensions.
  String _mimeType(String ext) {
    switch (ext) {
      case 'html':
        return 'text/html; charset=utf-8';
      case 'js':
        return 'application/javascript; charset=utf-8';
      case 'css':
        return 'text/css; charset=utf-8';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'svg':
        return 'image/svg+xml';
      case 'json':
        return 'application/json';
      case 'woff':
      case 'woff2':
        return 'font/woff2';
      case 'ico':
        return 'image/x-icon';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'map':
        return 'application/json';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        // No top/bottom padding — React app handles its own layout
        top: false,
        bottom: false,
        child: _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text('Yükleme hatası: $_error',
                          style: const TextStyle(
                              color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _error = null;
                            _loading = true;
                          });
                          _server?.close(force: true);
                          _initWebView();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tekrar Dene'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF58CC02),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  if (_controller != null)
                    WebViewWidget(controller: _controller!),
                  if (_loading)
                    const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF58CC02)),
                    ),
                ],
              ),
      ),
    );
  }
}
