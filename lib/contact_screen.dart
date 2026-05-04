import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  void _call() async {
    await launchUrl(Uri.parse("tel:+3612667601"));
  }

  void _email() async {
    await launchUrl(Uri.parse("mailto:kapcsolat@dft.hu"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kapcsolat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "DFT Hungaria",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Text(" Cím: Budapest"),
            const SizedBox(height: 10),

            const Text(" Telefon: +36 1 266 7601"),
            const SizedBox(height: 10),

            const Text(" Email: kapcsolat@dft.hu"),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _call,
              child: const Text("Hívás indítása"),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: _email,
              child: const Text("Email küldése"),
            ),
          ],
        ),
      ),
    );
  }
}