import 'package:esearch/util/color.dart';
import 'package:flutter/material.dart';

class SavedJobs extends StatefulWidget {
  const SavedJobs({super.key});

  @override
  State<SavedJobs> createState() => _SavedJobsState();
}

class _SavedJobsState extends State<SavedJobs> {
  // Dummy saved jobs list
  final List<Map<String, String>> savedJobs = [
    {
      "title": "Electrician",
      "company": "HomeFix Services",
      "salary": "₹ 15,000 - ₹ 20,000 per month",
      "location": "Salt Lake, Kolkata",
      "type": "Full-Time",
      "vacancy": "10 Vacancies",
    },
    {
      "title": "Home Cook",
      "company": "Urban Helpers",
      "salary": "₹ 12,000 - ₹ 18,000 per month",
      "location": "Behala, Kolkata",
      "type": "Part-Time",
      "vacancy": "5 Vacancies",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FF),
      appBar: AppBar(
        backgroundColor: maincolor,
        foregroundColor: Colors.white,
        title: const Text("Saved Jobs"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: savedJobs.isEmpty
            ? _emptyState()
            : ListView.separated(
                itemCount: savedJobs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final job = savedJobs[index];
                  return _savedJobCard(job, index);
                },
              ),
      ),
    );
  }

  Widget _savedJobCard(Map<String, String> job, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  job["title"] ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.bookmark, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    savedJobs.removeAt(index);
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            job["company"] ?? "",
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 10),

          Text(
            job["salary"] ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            job["location"] ?? "",
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Chip(label: Text(job["type"] ?? "")),
              const SizedBox(width: 8),
              Chip(label: Text(job["vacancy"] ?? "")),
            ],
          ),
        ],
      ),
    );
  }

  /// ================= EMPTY STATE =================
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.bookmark_border,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            "No Saved Jobs",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Save jobs to view them later",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
