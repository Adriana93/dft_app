import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import 'request_page.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => isLoading = true);
          },
          onPageFinished: (_) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.dft.hu'));
  }

  // 🔄 Refresh
  void _refresh() {
    _controller.reload();
  }

  // 📞 Hívás
  void _call() async {
    await launchUrl(
      Uri.parse("tel:+3612667601"),
    );
  }

  // 📧 Email
  void _email() async {
    await launchUrl(
      Uri.parse("mailto:kapcsolat@dft.hu"),
    );
  }

  // 📤 Megosztás
  void _share() {
    Share.share("Nézd meg: https://www.dft.hu");
  }

  // 🟢 Ajánlatkérés oldal
  void _openRequestPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RequestPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DFT Hungaria"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // ✅ ALSÓ MENÜ
          Positioned(
            left: 16,
            right: 16,
            bottom: 30,
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
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
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
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _openRequestPage,
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