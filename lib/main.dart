import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'contact_screen.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openWeb(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  void _openContact(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ContactScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DFT Hungaria"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Üdvözlünk a DFT alkalmazásban",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => _openWeb(context),
              child: const Text("Weboldal megnyitása"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => _openContact(context),
              child: const Text("Kapcsolat"),
            ),
          ],
        ),
      ),
    );
  }
}