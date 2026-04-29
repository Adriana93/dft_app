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

  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              isLoading = true;
              hasError = false;
            });
          },
          onPageFinished: (_) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (_) {
            setState(() {
              isLoading = false;
              hasError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.dft.hu'));
  }

  void _call() async {
    await launchUrl(Uri.parse("tel:+3612667601"));
  }

  void _email() async {
    await launchUrl(Uri.parse("mailto:kapcsolat@dft.hu"));
  }

  void _share() {
    Share.share("https://www.dft.hu");
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

          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          if (hasError)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Nem sikerült betölteni az oldalt."),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refresh,
                    child: const Text("Újrapróbálás"),
                  ),
                ],
              ),
            ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 40,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black26,
                    ),
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
          ),
        ],
      ),
    );
  }
}