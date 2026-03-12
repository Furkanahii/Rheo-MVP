import 'dart:convert';
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
/// Asset filenames are discovered dynamically from the AssetManifest,
/// so Vite hash changes between builds are handled automatically.
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
    _initWebView();
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
        ..loadRequest(Uri.parse('http://localhost:$port/index.html'));

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

  /// Discover and copy ALL files under assets/journey-web/ dynamically
  /// by reading the AssetManifest. This way Vite hash changes are handled
  /// automatically without needing to update filenames manually.
  Future<Directory> _copyAssets() async {
    final dir = await getTemporaryDirectory();
    final webDir = Directory('${dir.path}/journey-web');
    if (await webDir.exists()) await webDir.delete(recursive: true);
    await webDir.create(recursive: true);

    // Load the asset manifest to discover all bundled files
    final manifestJson = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifest = json.decode(manifestJson);

    // Find all keys that start with assets/journey-web/
    const prefix = 'assets/journey-web/';
    final journeyAssets = manifest.keys
        .where((key) => key.startsWith(prefix))
        .toList();

    for (final assetKey in journeyAssets) {
      // Derive the relative path within journey-web/
      final relativePath = assetKey.substring(prefix.length);
      final destPath = '${webDir.path}/$relativePath';

      // Ensure parent directory exists
      final parentDir = Directory(destPath.substring(0, destPath.lastIndexOf('/')));
      if (!await parentDir.exists()) {
        await parentDir.create(recursive: true);
      }

      // Copy the file
      try {
        final data = await rootBundle.load(assetKey);
        await File(destPath).writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
      } catch (e) {
        debugPrint('⚠️ Could not copy asset $assetKey: $e');
      }
    }

    return webDir;
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
        child: Column(
          children: [
            // Top bar with back button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white70, size: 22),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Öğrenme Yolculuğu',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            // WebView
            Expanded(
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
          ],
        ),
      ),
    );
  }
}
