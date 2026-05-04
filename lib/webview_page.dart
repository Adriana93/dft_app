import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
        title: const Text("DFT Web"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
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
        ],
      ),

      //
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openRequestPage,
        icon: const Icon(Icons.send),
        label: const Text("Ajánlatkérés"),
      ),
    );
  }
}