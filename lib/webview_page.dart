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

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://dft.hu'));
  }

  void _call() async {
    await launchUrl(Uri.parse("tel:+36123456789"));
  }

  void _email() async {
    await launchUrl(Uri.parse("mailto:info@dft.hu"));
  }

  void _share() {
    Share.share("Nézd meg: https://dft.hu");
  }

  void _refresh() {
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          // 🔴 DEBUG BAR (ennek LÁTSZANIA kell)
          Positioned(
            left: 16,
            right: 16,
            bottom: 40,
            child: SafeArea(
              child: Container(
                color: Colors.red, // 👈 EZ A DEBUG!
                padding: const EdgeInsets.symmetric(vertical: 10),
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
          ),
        ],
      ),
    );
  }
}