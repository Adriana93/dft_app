import 'package:flutter/material.dart';
import 'webview_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF006745),
        title: const Text(
          "DFT Hungaria",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(
              context,
              "Ajánlataink",
              "https://www.dft.hu/ajanlataink/",
              Icons.star,
            ),
            _buildCard(
              context,
              "Szolgáltatások",
              "https://www.dft.hu/szolgaltatasok/",
              Icons.business_center,
            ),
            _buildCard(
              context,
              "Operatív programok",
              "https://www.dft.hu/operativ-programok/",
              Icons.work,
            ),
            _buildCard(
              context,
              "Naptár",
              "https://www.dft.hu/naptar/",
              Icons.calendar_month,
            ),
            _buildCard(
              context,
              "Kapcsolat",
              "https://www.dft.hu/kapcsolat/",
              Icons.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context,
      String title,
      String url,
      IconData icon,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewPage(
              title: title,
              url: url,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF006745),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black12,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}