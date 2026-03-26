import 'dart:convert';

import 'package:esearch/core/constants/colors.dart';
import 'package:esearch/core/constants/urls.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class DomesticServices extends StatefulWidget {
  const DomesticServices({super.key});

  @override
  State<DomesticServices> createState() => _DomesticServicesState();
}

class DomesticJob {
  final String title;
  final String company;
  final String salary;
  final String location;
  final String type;
  final String vacancy;
  final String? role;
  final String? phone;
  final String? experience;
  final String? description;
  final String? skills;
  final String? startTime;
  final String? endTime;
  final bool? allowWhatsapp;

  DomesticJob({
    required this.title,
    required this.company,
    required this.salary,
    required this.location,
    required this.type,
    required this.vacancy,
    this.role,
    this.phone,
    this.experience,
    this.description,
    this.skills,
    this.startTime,
    this.endTime,
    this.allowWhatsapp,
  });

  factory DomesticJob.fromJson(Map<String, dynamic> json) {
    return DomesticJob(
      title: json['job_title']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      salary: json['salary']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      type: json['employment_type']?.toString() ?? '',
      vacancy: json['vacancies']?.toString() ?? '',
      role: json['role']?.toString(),
      phone: json['phone']?.toString(),
      experience: json['experience_needed']?.toString(),
      description: json['description']?.toString(),
      skills: json['skills']?.toString(),
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
      allowWhatsapp: json['allow_whatsapp'] == '1',
    );
  }
}

class _DomesticServicesState extends State<DomesticServices> {
  final TextEditingController _searchController = TextEditingController();

  List<DomesticJob> _jobs = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    try {
      final res = await http.get(
        Uri.parse("${mainurl}get_domestic_services.php"),
      );

      if (res.statusCode != 200) {
        throw Exception('Network error: ${res.statusCode}');
      }

      final body = json.decode(res.body);

      if (body['status'] == true) {
        final record = body['data'];

        if (record is List) {
          setState(() {
            _jobs = record.map((e) => DomesticJob.fromJson(e)).toList();
          });
        } else if (record is Map) {
          final map = Map<String, dynamic>.from(record);
          setState(() {
            _jobs = [DomesticJob.fromJson(map)];
          });
        }
      } else {
        setState(() {
          _jobs = [];
        });
      }
    } catch (e) {
      debugPrint('Failed to fetch domestic jobs: $e');
      setState(() {
        _jobs = [];
      });
    }
  }

  Future<void> _deleteJob(int index) async {
    setState(() => _jobs.removeAt(index));
  }

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
      backgroundColor: const Color(0xFFF2F5FF),
      appBar: AppBar(
        backgroundColor: maincolor,
        foregroundColor: Colors.white,
        title: const Text("Domestic Services"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              cursorColor: maincolor,
              decoration: InputDecoration(
                hintText: "Search service or location",
                prefixIcon: const Icon(Icons.search),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: maincolor, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: filteredJobs.isEmpty
                  ? Center(
                      child: Text(
                        'No domestic services found',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredJobs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final job = filteredJobs[index];
                        return _jobCard(job, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobCard(DomesticJob job, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
                  job.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.bookmark, color: Colors.blue),
                onPressed: () => _deleteJob(index),
              ),
            ],
          ),

          Text(job.company, style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 10),

          Text(job.salary, style: const TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 6),

          Text(job.location, style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 12),

          // Row(
          //   children: [
          //     Chip(label: Text(job.type)),
          //     const SizedBox(width: 8),
          //     Chip(label: Text(job.vacancy)),
          //   ],
          // ),
          if (job.role != null) Text('Role: ${job.role}'),
          if (job.phone != null) Text('Phone: ${job.phone}'),
          if (job.experience != null) Text('Experience: ${job.experience}'),
          if (job.description != null) Text('Description: ${job.description}'),
          if (job.skills != null) Text('Skills: ${job.skills}'),
          if (job.startTime != null) Text('Start: ${job.startTime}'),
          if (job.endTime != null) Text('End: ${job.endTime}'),

          if (job.allowWhatsapp == true)
            const Text(
              'WhatsApp Allowed',
              style: TextStyle(color: Colors.green),
            ),
        ],
      ),
    );
  }
}
