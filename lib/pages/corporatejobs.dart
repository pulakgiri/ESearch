import 'dart:convert';

import 'package:esearch/util/color.dart';
import 'package:flutter/material.dart';

class CorporateJobs extends StatefulWidget {
  const CorporateJobs({super.key});

  @override
  State<CorporateJobs> createState() => _CorporateJobsState();
}

class CorporateJob {
  final String title;
  final String company;
  final String salary;
  final String location;
  final String type;
  final String vacancy;
  final String category;

  CorporateJob({
    required this.title,
    required this.company,
    required this.salary,
    required this.location,
    required this.type,
    required this.vacancy,
    this.category = 'Corporate',
  });

  factory CorporateJob.fromJson(Map<String, dynamic> json) {
    return CorporateJob(
      title: json['job_title']?.toString() ?? json['title']?.toString() ?? '',
      company:
          json['company']?.toString() ?? json['company_name']?.toString() ?? '',
      salary: json['salary']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      type: json['employment_type']?.toString() ?? '',
      vacancy:
          json['vacancies']?.toString() ?? json['vacancy']?.toString() ?? '',
    );
  }
}

class _CorporateJobsState extends State<CorporateJobs> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();

    final filteredJobs = _jobs.where((job) {
      if (query.isEmpty) return true;

      return job.title.toLowerCase().contains(query) ||
          job.company.toLowerCase().contains(query) ||
          job.location.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF2F5FF),
      appBar: AppBar(
        backgroundColor: maincolor,
        foregroundColor: Colors.white,
        title: const Text("Corporate Jobs"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              cursorColor: maincolor,
              textInputAction: TextInputAction.search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Search jobs or location",
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),

                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,

                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: maincolor,
                    width: 1.5,
                  ),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
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
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "₹ 18,000 - ₹ 24,000 per month",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Jadavpur, Kolkata (>100 kms)",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
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
