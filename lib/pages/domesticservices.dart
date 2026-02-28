import 'package:esearch/util/color.dart';
import 'package:flutter/material.dart';

class DomesticServices extends StatefulWidget {
  const DomesticServices({super.key});

  @override
  State<DomesticServices> createState() => _DomesticServicesState();
}

class _DomesticServicesState extends State<DomesticServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FF),
      appBar: AppBar(
        backgroundColor: maincolor,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search jobs or location",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 💼 Job Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Junior Software Engineer",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Jay Balaji Enterprise",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "₹ 18,000 - ₹ 24,000 per month",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Jadavpur, Kolkata (>100 kms)",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Chip(label: Text("Full-Time")),
                      SizedBox(width: 8),
                      Chip(label: Text("25 Vacancies")),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
