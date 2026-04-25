import 'dart:convert';
import 'package:esearch/core/constants/colors.dart';
import 'package:esearch/core/constants/urls.dart';
import 'package:esearch/core/utils/global_user.dart' as globaluser;
import 'package:esearch/features/jobs/job_details_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CorporateJobs extends StatefulWidget {
  const CorporateJobs({super.key});

  @override
  State<CorporateJobs> createState() => _CorporateJobsState();
}

class CorporateJob {
  final int id;
  final String jobid;
  final String title;
  final String company;
  final String salary;
  final String location;
  final String type;
  final String vacancy;
  final String postedBy;
  final String jobDescription;
  final String createdAt;
  final String category;

  CorporateJob({
    required this.id,
    required this.jobid,
    required this.title,
    required this.company,
    required this.salary,
    required this.location,
    required this.type,
    required this.vacancy,
    required this.postedBy,
    required this.jobDescription,
    required this.createdAt,
    this.category = 'Corporate',
  });

  factory CorporateJob.fromJson(Map<String, dynamic> json) {
    return CorporateJob(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      jobid: json['jobid']?.toString() ?? '',
      title: json['job_title']?.toString() ?? json['title']?.toString() ?? '',
      company:
          json['company']?.toString() ?? json['company_name']?.toString() ?? '',
      salary: json['salary']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      type: json['employment_type']?.toString() ?? '',
      vacancy:
          json['vacancies']?.toString() ?? json['vacancy']?.toString() ?? '',
      postedBy: json['posted_by']?.toString() ?? '',
      jobDescription:
          json['job_description']?.toString() ??
          json['description']?.toString() ??
          '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

class _CorporateJobsState extends State<CorporateJobs> {
  final TextEditingController _searchController = TextEditingController();

  List<CorporateJob> _jobs = [];
  Set<int> bookmarkedJobs = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    try {
      final res = await http.get(Uri.parse("${mainurl}get_corporate_jobs.php"));
      if (res.statusCode != 200) {
        throw Exception('Network error: ${res.statusCode}');
      }
      final body = json.decode(res.body);
      if (body is Map && body['status'] == true) {
        final record = body['data'];
        if (record != null) {
          if (record is List) {
            setState(() {
              _jobs = record
                  .map(
                    (e) => CorporateJob.fromJson(
                      Map<String, dynamic>.from(e as Map),
                    ),
                  )
                  .toList();
            });
          } else if (record is Map) {
            final map = Map<String, dynamic>.from(record);
            setState(() {
              _jobs = [CorporateJob.fromJson(map)];
            });
          }
        }
      } else {
        setState(() {
          _jobs = [];
        });
      }
    } catch (e) {
      debugPrint('Failed to fetch corporate jobs: $e');
      setState(() {
        _jobs = [];
      });
    }
  }

  Future<void> _deleteJob(int index) async {
    setState(() => _jobs.removeAt(index));
  }

  Future<void> _applyCorporateJob(CorporateJob job) async {
    try {
      final response = await http.post(
        Uri.parse('${mainurl}apply_job.php'),
        body: {
          'userid': globaluser.user.userid ?? '',
          'job_id': job.id.toString(),
          'job_type': 'corporate',
        },
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200 && body['status'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['msg'] ?? 'Applied successfully')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['msg'] ?? 'Failed to apply')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error applying: $e')),
      );
    }
  }

  Future<void> _showManageOptions(CorporateJob job) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage ${job.title}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('View Applicants'),
              onTap: () => Navigator.pop(context, 'applicants'),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Job (local)'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );

    if (selected == 'delete') {
      setState(() {
        _jobs.removeWhere((element) => element.id == job.id);
      });
    }
    if (selected == 'applicants') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Applicants for ${job.title}'),
          content: const Text(
            'Applicants are available in Applied Jobs quick action.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _openJobDetails(CorporateJob job) {
    final isMine = job.postedBy == globaluser.user.userid;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailsPage(
          title: job.title,
          details: {
            'Company': job.company,
            'Location': job.location,
            'Salary': job.salary,
            'Type': job.type,
            'Vacancies': job.vacancy,
            'Description': job.jobDescription,
            'Posted By': job.postedBy,
          },
          canApply: !isMine,
          onApply: () => _applyCorporateJob(job),
          canDelete: isMine,
          onDelete: () {
            _showManageOptions(job);
            Navigator.pop(context);
          },
        ),
      ),
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
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: maincolor,
        foregroundColor: Colors.white,
        title: const Text(
          "Corporate Jobs",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
              child: filteredJobs.isEmpty
                  ? Center(
                      child: Text(
                        'No corporate jobs found',
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

  Widget _jobCard(CorporateJob job, int index) {
    final isMine = job.postedBy == globaluser.user.userid;

    return InkWell(
      onTap: () => _openJobDetails(job),
      child: Container(
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
                  icon: Icon(
                    bookmarkedJobs.contains(job.id)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: bookmarkedJobs.contains(job.id)
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (bookmarkedJobs.contains(job.id)) {
                        bookmarkedJobs.remove(job.id);
                      } else {
                        bookmarkedJobs.add(job.id);
                      }
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 4),
            Text(job.company, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 10),
            Text(
              job.salary,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),
            Text(job.location, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 12),
            Row(
              children: [
                Chip(label: Text(job.type)),
                const SizedBox(width: 8),
                Chip(label: Text(job.vacancy)),
              ],
            ),

            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (isMine) {
                    _showManageOptions(job);
                  } else {
                    _applyCorporateJob(job);
                  }
                },
                child: Text(isMine ? 'Manage' : 'Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
