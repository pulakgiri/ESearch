import 'dart:convert';
import 'package:esearch/core/constants/colors.dart';
import 'package:esearch/core/constants/urls.dart';
import 'package:esearch/features/jobs/job_details_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SkilledLabourPage extends StatefulWidget {
  const SkilledLabourPage({super.key});

  @override
  State<SkilledLabourPage> createState() => _SkilledLabourPageState();
}

class SkilledJob {
  final int id;
  final String jobid;
  final String category;
  final String specificSkill;
  final String description;
  final String location;
  final String amount;
  final String rateType;
  final String postedBy;

  SkilledJob({
    required this.id,
    required this.jobid,
    required this.category,
    required this.specificSkill,
    required this.description,
    required this.location,
    required this.amount,
    required this.rateType,
    required this.postedBy,
  });

  factory SkilledJob.fromJson(Map<String, dynamic> json) {
    return SkilledJob(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      jobid: json['jobid']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      specificSkill: json['specific_skill']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      rateType: json['rate_type']?.toString() ?? '',
      postedBy: json['posted_by']?.toString() ?? '',
    );
  }
}

class _SkilledLabourPageState extends State<SkilledLabourPage> {
  bool isLoading = true;
  List<SkilledJob> jobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${mainurl}get_skilled_jobs.php'),
      );
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['status'] == true) {
          final data = jsonBody['data'];
          if (data is List) {
            jobs = data
                .map(
                  (e) =>
                      SkilledJob.fromJson(Map<String, dynamic>.from(e as Map)),
                )
                .toList();
          }
        }
      }
    } catch (_) {
      // ignore
    }
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FF),
      appBar: AppBar(
        backgroundColor: maincolor,
        foregroundColor: Colors.white,
        title: const Text('Skilled Labour Jobs'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadJobs,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : jobs.isEmpty
            ? const Center(child: Text('No skilled jobs found'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: jobs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      title: Text(job.specificSkill),
                      subtitle: Text('${job.category} • ${job.location}'),
                      trailing: Text(job.amount.isEmpty ? '-' : job.amount),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailsPage(
                              title: job.specificSkill,
                              details: {
                                'Category': job.category,
                                'Skill': job.specificSkill,
                                'Description': job.description,
                                'Location': job.location,
                                'Amount': job.amount,
                                'Rate Type': job.rateType,
                              },
                              canApply: true,
                              onApply: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Apply flow not yet implemented',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
