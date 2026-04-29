import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

// Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase init hiba: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WebViewController _controller;

  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();

    _initFirebase();

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
          onWebResourceError: (error) {
            setState(() {
              isLoading = false;
              hasError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.dft.hu'));
  }

  // Firebase messaging
  void _initFirebase() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      await messaging.requestPermission();
      await messaging.getToken();

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint("Push jött: ${message.notification?.title}");
      });
    } catch (e) {
      debugPrint("Firebase messaging hiba: $e");
    }
  }

  // Refresh
  Future<void> _refresh() async {
    _controller.reload();
  }

  // Back gomb
  Future<bool> _handleBack() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }

  // Telefon
  void _call() async {
    await launchUrl(Uri.parse("tel:+3612667601"));
  }

  // Email
  void _email() async {
    await launchUrl(Uri.parse("mailto:kapcsolat@dft.hu"));
  }

  // Megosztás
  void _share() {
    Share.share("Nézd meg: https://www.dft.hu");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("DFT"),
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

            if (hasError)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Az oldal nem tölthető be."),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _refresh,
                      child: const Text("Újrapróbálás"),
                    ),
                  ],
                ),
              ),

            // Alsó natív action bar
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
      ),
    );
  }
}