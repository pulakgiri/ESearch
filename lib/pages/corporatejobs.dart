import 'dart:convert';

import 'package:esearch/util/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/saved_job.dart';
import '../util/database_helper.dart';
import '../util/url.dart';
import '../widgets/job_card.dart';

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

  List<CorporateJob> _jobs = [];
  Set<String> _savedKeys = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    setState(() {
      _loading = true;
    });

    try {
      final uri = Uri.parse('${mainurl}get_jobs.php');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsondata = jsonDecode(response.body);
        if (jsondata['status'] == true) {
          final data = jsondata['data'];
          List<CorporateJob> jobs = [];
          if (data is List) {
            for (var item in data) {
              try {
                jobs.add(
                  CorporateJob.fromJson(Map<String, dynamic>.from(item)),
                );
              } catch (_) {}
            }
          } else if (data != null) {
            try {
              jobs.add(CorporateJob.fromJson(Map<String, dynamic>.from(data)));
            } catch (_) {}
          }
          _jobs = jobs;
          await _loadSavedStatus();
        } else {
          _jobs = [];
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsondata['msg'] ?? 'No jobs found')),
            );
          }
        }
      } else {
        _jobs = [];
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Server error: ${response.statusCode}'),
            ),
          );
        }
      }
    } catch (e) {
      _jobs = [];

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Network error: $e')),
        );
      }
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _loadSavedStatus() async {
    final Set<String> result = {};

    for (var job in _jobs) {
      final exists = await DatabaseHelper.instance.isJobSaved(
        job.title,
        job.company,
        category: job.category,
      );

      if (exists) {
        result.add('${job.title}|${job.company}');
      }
    }

    if (!mounted) return;

    setState(() {
      _savedKeys = result;
    });
  }

  void _saveJob(CorporateJob job) async {
    final saved = SavedJob(
      title: job.title,
      company: job.company,
      salary: job.salary,
      location: job.location,
      type: job.type,
      vacancy: job.vacancy,
      category: job.category,
    );

    await DatabaseHelper.instance.insertJob(saved);

    setState(() {
      _savedKeys.add('${job.title}|${job.company}');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job saved')),
    );
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

            Expanded(
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: maincolor,
                      ),
                    )
                  : filteredJobs.isEmpty
                  ? const Center(
                      child: Text(
                        'No corporate jobs found',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchJobs,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: filteredJobs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final job = filteredJobs[index];

                          final key = '${job.title}|${job.company}';
                          final saved = _savedKeys.contains(key);

                          return JobCard(
                            title: job.title,
                            company: job.company,
                            salary: job.salary,
                            location: job.location,
                            type: job.type,
                            vacancy: job.vacancy,
                            category: job.category,
                            isSaved: saved,
                            onSave: saved ? null : () => _saveJob(job),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
