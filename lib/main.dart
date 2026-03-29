import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

// 🔥 Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("🔥 MAIN INDUL"); // <-- EZ KELL LÁTSZON

  await Firebase.initializeApp();

  print("🔥 FIREBASE INIT DONE");

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

  @override
  void initState() {
    super.initState();

    _initFirebase(); // 🔥 EZ FUT MOST MÁR

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

  // 🔥 FIREBASE INIT
  void _initFirebase() async {
    print("🔥 Firebase init indul");

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 🔐 engedélykérés
    NotificationSettings settings = await messaging.requestPermission();
    print('🔔 Permission: ${settings.authorizationStatus}');

    // 🎯 TOKEN lekérés
    String? token = await messaging.getToken();
    print("🔥 FCM TOKEN: $token");

    // 📩 Foreground push figyelés
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Push jött: ${message.notification?.title}");
    });
  }

  // 🔄 Refresh
  Future<void> _refresh() async {
    _controller.reload();
  }

  // 🔙 Vissza gomb kezelés
  Future<bool> _handleBack() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }

  // 📞 TELEFON
  void _call() async {
    await launchUrl(Uri.parse("tel:+3612667601"));
  }

  // 📧 EMAIL
  void _email() async {
    await launchUrl(Uri.parse("mailto:kapcsolat@dft.hu"));
  }

  // 📤 MEGOSZTÁS
  void _share() {
    Share.share("Nézd meg: https://dft.hu");
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
            RefreshIndicator(
              onRefresh: _refresh,
              child: WebViewWidget(controller: _controller),
            ),

            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),

            // ✅ ALSÓ NATÍV ACTION BAR
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
            ),
          ],
        ),
      ),
    );
  }
}