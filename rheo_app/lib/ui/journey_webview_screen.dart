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
/// Asset discovery uses a triple-fallback strategy:
///   1. Flutter's official AssetManifest API (works with both .json and .bin)
///   2. Hardcoded file list (must match pubspec.yaml declarations)
///   3. Direct rootBundle.load probing for each known file
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

  /// The complete list of files that MUST be present in the bundle.
  /// This list must be kept in sync with pubspec.yaml asset declarations
  /// AND the Vite build output (file hashes change on each build).
  static const List<String> _knownFiles = [
    'assets/journey-web/index.html',
    'assets/journey-web/mascot_greeting.png',
    'assets/journey-web/mascot_happy.png',
    'assets/journey-web/assets/index-BCJCpQLs.js',
    'assets/journey-web/assets/index-BXRjnnp6.css',
    'assets/journey-web/assets/HologramCard-oFVIqWVa.js',
    'assets/journey-web/assets/LeagueView-B7MCfvh9.js',
    'assets/journey-web/assets/MoreView-NHsebTHe.js',
    'assets/journey-web/assets/ProfileView-C0Xa7vJC.js',
    'assets/journey-web/assets/QuestsView-Bqqyfc-M.js',
  ];

  @override
  void initState() {
    super.initState();
    // Wrap in its own zone so FFI-level errors (e.g. objective_c.dylib on
    // iOS 26 beta) don't escape to the root zone and crash the whole app.
    runZonedGuarded(
      () => _initWebView(),
      (error, stack) {
        debugPrint('⚠️ JourneyWebView zone error: $error');
        debugPrint('Stack: $stack');
        if (mounted) {
          setState(() {
            _error = 'Bağlantı hatası oluştu. Lütfen tekrar deneyin.';
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
      debugPrint('🌐 Local server started on port $port');

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
              debugPrint('🔴 WebView error: ${error.description} '
                  '(isMainFrame: ${error.isForMainFrame})');
              // Only set error for main frame failures, not sub-resource issues
              if (error.isForMainFrame ?? true) {
                if (mounted) {
                  setState(() {
                    _error =
                        'Sayfa yüklenemedi. Lütfen tekrar deneyin.';
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
    } catch (e, stack) {
      debugPrint('❌ _initWebView failed: $e');
      debugPrint('Stack: $stack');
      if (mounted) {
        setState(() {
          // Show user-friendly message, log the real error
          _error = 'İçerik yüklenemedi. Lütfen tekrar deneyin.';
          _loading = false;
        });
      }
    }
  }

  /// Copy all files under assets/journey-web/ to a temp directory.
  ///
  /// Uses a triple-fallback strategy for maximum reliability:
  ///   1. Flutter's official AssetManifest API
  ///   2. Hardcoded file list with verification
  ///   3. Direct rootBundle.load probing
  Future<Directory> _copyAssets() async {
    // Get a writable directory — multiple fallbacks for iOS compatibility
    final dir = await _getWritableDirectory();
    final webDir = Directory('${dir.path}/journey-web');
    if (await webDir.exists()) await webDir.delete(recursive: true);
    await webDir.create(recursive: true);

    const prefix = 'assets/journey-web/';

    // Discover all journey-web assets using triple-fallback
    List<String> journeyAssets = await _discoverAssets(prefix);

    debugPrint('📦 Journey assets to copy: ${journeyAssets.length}');
    for (final a in journeyAssets) {
      debugPrint('  → $a');
    }

    // Safety check: if discovery found too few assets, something is wrong
    if (journeyAssets.length < 3) {
      throw Exception(
        'Asset discovery found only ${journeyAssets.length} assets. '
        'Expected at least index.html + JS + CSS.',
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

      // Copy the file using binary load to avoid encoding issues
      try {
        final data = await rootBundle.load(assetKey);
        final bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(destPath).writeAsBytes(bytes);
        debugPrint('  ✅ $relativePath (${bytes.length} bytes)');
        copied++;
      } catch (e) {
        failed++;
        debugPrint('  ⚠️ FAILED to copy $assetKey: $e');
      }
    }

    debugPrint('📊 Copy result: $copied OK, $failed failed');

    // Verify critical files exist on disk
    final indexFile = File('${webDir.path}/index.html');
    if (!await indexFile.exists()) {
      throw Exception(
        'CRITICAL: index.html not found after copying $copied assets!',
      );
    }

    // Verify at least one JS file exists
    final assetsDir = Directory('${webDir.path}/assets');
    if (await assetsDir.exists()) {
      final jsFiles = await assetsDir
          .list()
          .where((e) => e is File && e.path.endsWith('.js'))
          .length;
      debugPrint('📄 JS files in output: $jsFiles');
      if (jsFiles == 0) {
        throw Exception(
          'CRITICAL: No JS files found in output assets/ directory!',
        );
      }
    } else {
      throw Exception(
        'CRITICAL: assets/ subdirectory not created!',
      );
    }

    // Debug: list all files in the output directory
    await _debugListDir(webDir, '');

    return webDir;
  }

  /// Get a writable directory with multiple fallbacks.
  Future<Directory> _getWritableDirectory() async {
    // Try getTemporaryDirectory first (fastest, auto-cleaned)
    try {
      final dir = await getTemporaryDirectory();
      debugPrint('📁 Using temp directory: ${dir.path}');
      return dir;
    } catch (e) {
      debugPrint('⚠️ getTemporaryDirectory failed: $e');
    }

    // Fallback to application support directory
    try {
      final dir = await getApplicationSupportDirectory();
      debugPrint('📁 Using app support directory: ${dir.path}');
      return dir;
    } catch (e) {
      debugPrint('⚠️ getApplicationSupportDirectory failed: $e');
    }

    // Fallback to application documents directory
    try {
      final dir = await getApplicationDocumentsDirectory();
      debugPrint('📁 Using documents directory: ${dir.path}');
      return dir;
    } catch (e) {
      debugPrint('⚠️ getApplicationDocumentsDirectory failed: $e');
    }

    // Last resort: /tmp (always available on iOS/macOS)
    debugPrint('📁 Using /tmp as last resort');
    return Directory('/tmp');
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

  /// Discover assets using triple-fallback strategy.
  ///
  /// Strategy 1: Flutter's official AssetManifest API
  ///   - Works with both AssetManifest.json (Flutter <3.7) and
  ///     AssetManifest.bin (Flutter ≥3.7)
  ///   - This is the recommended approach
  ///
  /// Strategy 2: Direct rootBundle.load probing
  ///   - If the AssetManifest API fails entirely, try to load
  ///     each known file directly from the bundle
  ///   - This bypasses the manifest entirely
  Future<List<String>> _discoverAssets(String prefix) async {
    // ── Strategy 1: Official Flutter AssetManifest API ──
    try {
      debugPrint('🔎 Strategy 1: AssetManifest API...');
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final allAssets = manifest.listAssets();
      final journeyAssets = allAssets
          .where((key) => key.startsWith(prefix))
          .toList();

      if (journeyAssets.isNotEmpty) {
        debugPrint(
            '✅ Strategy 1 SUCCESS: ${journeyAssets.length} journey assets');
        return journeyAssets;
      }
      debugPrint('⚠️ Strategy 1: API returned 0 journey assets');
    } catch (e) {
      debugPrint('⚠️ Strategy 1 FAILED: $e');
    }

    // ── Strategy 2: Direct rootBundle.load probing ──
    // Skip the manifest entirely and directly probe each known file.
    // This is the most resilient approach — it works even if the
    // manifest file is corrupt or unreadable.
    debugPrint('🔎 Strategy 2: Direct bundle probing...');

    final verified = <String>[];
    for (final assetKey in _knownFiles) {
      try {
        // Try to load the asset — if it exists, load() succeeds
        await rootBundle.load(assetKey);
        verified.add(assetKey);
        debugPrint('  ✅ Found: $assetKey');
      } catch (e) {
        debugPrint('  ❌ Missing: $assetKey ($e)');
      }
    }

    debugPrint(
        '📊 Strategy 2: ${verified.length}/${_knownFiles.length} files found');

    if (verified.isNotEmpty) {
      return verified;
    }

    // All strategies exhausted
    throw Exception(
      'FATAL: No journey-web assets found in app bundle. '
      'All ${_knownFiles.length} known files are missing. '
      'The app may need to be reinstalled.',
    );
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
                      Text(_error!,
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
