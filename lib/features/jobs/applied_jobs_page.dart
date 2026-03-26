import 'dart:convert';
import 'dart:io';
import 'package:esearch/core/constants/colors.dart';
import 'package:esearch/core/constants/urls.dart';
import 'package:esearch/core/utils/global_user.dart' as globaluser;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AppliedJob extends StatefulWidget {
  const AppliedJob({super.key});

  @override
  State<AppliedJob> createState() => _AppliedJobState();
}

class AppliedJobItem {
  final String jobTitle;
  final String company;
  final String location;
  final String salary;
  final String jobType;
  final String appliedAt;

  AppliedJobItem({
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.salary,
    required this.jobType,
    required this.appliedAt,
  });

  factory AppliedJobItem.fromJson(Map<String, dynamic> json) {
    return AppliedJobItem(
      jobTitle:
          json['job_title']?.toString() ??
          json['title']?.toString() ??
          'Unknown',
      company: json['company']?.toString() ?? 'Unknown',
      location: json['location']?.toString() ?? 'Unknown',
      salary: json['salary']?.toString() ?? 'Unknown',
      jobType: json['job_type']?.toString() ?? 'Unknown',
      appliedAt: json['applied_at']?.toString() ?? '',
    );
  }
}

class JobApplicant {
  final String jobTitle;
  final String applicantName;
  final String applicantId;
  final String appliedAt;

  JobApplicant({
    required this.jobTitle,
    required this.applicantName,
    required this.applicantId,
    required this.appliedAt,
  });

  factory JobApplicant.fromJson(Map<String, dynamic> json) {
    return JobApplicant(
      jobTitle: json['job_title']?.toString() ?? 'Unknown',
      applicantName: json['applicant_name']?.toString() ?? 'Unknown',
      applicantId: json['applicant_userid']?.toString() ?? 'Unknown',
      appliedAt: json['applied_at']?.toString() ?? '',
    );
  }
}

class _AppliedJobState extends State<AppliedJob> {
  List<AppliedJobItem> appliedJobs = [];
  List<JobApplicant> applicants = [];
  bool isLoading = true;
  File? pdfFile;

  @override
  void initState() {
    super.initState();
    _loadAppliedJobs();
  }

  Future<void> _loadAppliedJobs() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${mainurl}get_applied_jobs.php'),
        body: {'userid': globaluser.user.userid ?? ''},
      );
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['status'] == true && jsonBody['data'] is List) {
          appliedJobs = (jsonBody['data'] as List)
              .map(
                (item) =>
                    AppliedJobItem.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        }
      }
    } catch (_) {
      // ignore
    }

    try {
      final response = await http.post(
        Uri.parse('${mainurl}get_job_applicants.php'),
        body: {'posted_by': globaluser.user.userid ?? ''},
      );
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        if (jsonBody['status'] == true && jsonBody['data'] is List) {
          applicants = (jsonBody['data'] as List)
              .map(
                (item) =>
                    JobApplicant.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        }
      }
    } catch (_) {
      // ignore
    }

    if (mounted) setState(() => isLoading = false);
  }

  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() => pdfFile = File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: const Text('Applied Jobs'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadAppliedJobs,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jobs You Applied To',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (appliedJobs.isEmpty)
                      const Text('You have not applied to any jobs yet.'),
                    ...appliedJobs.map(
                      (job) => Card(
                        child: ListTile(
                          title: Text(job.jobTitle),
                          subtitle: Text('${job.company} • ${job.location}'),
                          trailing: Text(job.jobType),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Applicants for Your Jobs',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (applicants.isEmpty)
                      const Text('No one has applied to your posted jobs yet.'),
                    ...applicants.map(
                      (applicant) => Card(
                        child: ListTile(
                          title: Text(applicant.applicantName),
                          subtitle: Text(
                            '${applicant.jobTitle} • ${applicant.appliedAt}',
                          ),
                          trailing: Text(applicant.applicantId),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),
                    const Text(
                      'Resume PDF (optional)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 300,
                      child: pdfFile == null
                          ? const Center(child: Text('No PDF Selected'))
                          : SfPdfViewer.file(pdfFile!),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: pickPdf,
                      child: const Text('Select Resume PDF'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
