import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => _loading = true);
          },
          onPageFinished: (_) {
            setState(() => _loading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse('https://dft.hu'));
  }

  void _call() async {
    final uri = Uri.parse("tel:+36123456789");
    await launchUrl(uri);
  }

  void _email() async {
    final uri = Uri.parse("mailto:info@dft.hu");
    await launchUrl(uri);
  }

  void _share() {
    Share.share("Nézd meg: https://dft.hu");
  }

  Future<void> _refresh() async {
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          // 🔄 LOADING INDICATOR
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // 📱 NATÍV ALSÓ ACTION BAR
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black26,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _refresh,
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: _call,
                  ),
                  IconButton(
                    icon: const Icon(Icons.email),
                    onPressed: _email,
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: _share,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}