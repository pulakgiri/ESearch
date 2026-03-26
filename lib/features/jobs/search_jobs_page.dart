import 'dart:convert';
import 'package:esearch/core/constants/colors.dart';
import 'package:esearch/core/constants/urls.dart';
import 'package:esearch/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:esearch/features/jobs/job_details_page.dart';
import 'package:http/http.dart' as http;

class SearchForJobs extends StatefulWidget {
  const SearchForJobs({super.key});

  @override
  State<SearchForJobs> createState() => _SearchForJobsState();
}

class SearchJobItem {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String recruitment;
  final String role;
  final String source;

  SearchJobItem({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.recruitment,
    required this.role,
    required this.source,
  });
}

class _SearchForJobsState extends State<SearchForJobs> {
  final TextEditingController searchController = TextEditingController();
  final List<String> recentSearches = [];
  final List<String> popularSearches = [
    'Python Developer',
    'Back End Developer',
    'Frontend Developer',
    'Sales Executive',
  ];

  List<SearchJobItem> allJobs = [];
  List<SearchJobItem> filteredJobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllJobs();
    searchController.addListener(_applyFilter);
  }

  @override
  void dispose() {
    searchController.removeListener(_applyFilter);
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllJobs() async {
    setState(() => isLoading = true);
    final jobs = <SearchJobItem>[];

    Future<void> fetch(
      String url,
      String source,
      Function(Map<String, dynamic>) parser,
    ) async {
      try {
        final res = await http.get(Uri.parse(url));
        if (res.statusCode == 200) {
          final data = json.decode(res.body);
          if (data is Map && data['status'] == true && data['data'] is List) {
            for (final item in data['data']) {
              final map = Map<String, dynamic>.from(item);
              final parsed = parser(map);
              if (parsed != null) jobs.add(parsed);
            }
          }
        }
      } catch (_) {}
    }

    await fetch('${mainurl}get_corporate_jobs.php', 'Corporate', (map) {
      return SearchJobItem(
        id: map['id']?.toString() ?? '',
        title: map['job_title']?.toString() ?? '',
        company: map['company']?.toString() ?? '',
        location: map['location']?.toString() ?? '',
        salary: map['salary']?.toString() ?? '',
        recruitment: map['employment_type']?.toString() ?? '',
        role: map['job_title']?.toString() ?? '',
        source: 'Corporate',
      );
    });

    await fetch('${mainurl}get_domestic_services.php', 'Domestic', (map) {
      return SearchJobItem(
        id: map['id']?.toString() ?? '',
        title: map['job_title']?.toString() ?? '',
        company: map['company']?.toString() ?? '',
        location: map['location']?.toString() ?? '',
        salary: map['salary']?.toString() ?? '',
        recruitment: map['experience_needed']?.toString() ?? '',
        role: map['role']?.toString() ?? '',
        source: 'Domestic',
      );
    });

    await fetch('${mainurl}get_skilled_jobs.php', 'Skilled', (map) {
      return SearchJobItem(
        id: map['id']?.toString() ?? '',
        title: map['specific_skill']?.toString() ?? '',
        company: map['category']?.toString() ?? '',
        location: map['location']?.toString() ?? '',
        salary: map['amount']?.toString() ?? '',
        recruitment: map['rate_type']?.toString() ?? '',
        role: map['specific_skill']?.toString() ?? '',
        source: 'Skilled',
      );
    });

    setState(() {
      allJobs = jobs;
      _applyFilter();
      isLoading = false;
    });
  }

  void addRecentSearch(String value) {
    if (value.trim().isEmpty) return;
    setState(() {
      recentSearches.remove(value);
      recentSearches.insert(0, value);
      if (recentSearches.length > 8) recentSearches.removeLast();
    });
  }

  void performSearch(String value) {
    searchController.text = value;
    addRecentSearch(value);
    _applyFilter();
  }

  void _applyFilter() {
    final query = searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        filteredJobs = List.from(allJobs);
      });
      return;
    }

    final results = allJobs.where((job) {
      final text =
          '${job.title} ${job.company} ${job.location} ${job.recruitment} ${job.role} ${job.source}'
              .toLowerCase();
      return text.contains(query);
    }).toList();

    setState(() {
      filteredJobs = results;
    });
  }

  Widget _chip(String text) {
    return GestureDetector(
      onTap: () => performSearch(text),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingM,
          vertical: AppSpacing.paddingM,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(AppSpacing.radiusM),
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: maincolor,
        title: const Text('Job Search'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: searchController,
                    onSubmitted: performSearch,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search by job role, recruitment, company...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusM),
                      ),
                    ),
                  ),
                  AppSpacing.spaceM,
                  if (recentSearches.isNotEmpty) ...[
                    const Text(
                      'Recent searches',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    AppSpacing.spaceS,
                    Wrap(
                      spacing: AppSpacing.paddingS,
                      runSpacing: AppSpacing.paddingS,
                      children: recentSearches.map(_chip).toList(),
                    ),
                    AppSpacing.spaceL,
                  ],
                  const Text(
                    'Popular searches',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  AppSpacing.spaceS,
                  Wrap(
                    spacing: AppSpacing.paddingS,
                    runSpacing: AppSpacing.paddingS,
                    children: popularSearches.map(_chip).toList(),
                  ),
                  AppSpacing.spaceL,
                  Expanded(
                    child: filteredJobs.isEmpty
                        ? const Center(child: Text('No jobs found.'))
                        : ListView.separated(
                            itemCount: filteredJobs.length,
                            separatorBuilder: (_, __) => AppSpacing.spaceM,
                            itemBuilder: (context, index) {
                              final job = filteredJobs[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusM,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: AppSpacing.listItemPadding,
                                  title: Text(job.title),
                                  subtitle: Text(
                                    '${job.company} • ${job.location}',
                                  ),
                                  trailing: Text(job.source),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JobDetailsPage(
                                          title: job.title,
                                          details: {
                                            'Company': job.company,
                                            'Location': job.location,
                                            'Salary': job.salary,
                                            'Recruitment': job.recruitment,
                                            'Role': job.role,
                                            'Category': job.source,
                                          },
                                          canApply: true,
                                          onApply: () {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Apply feature coming soon',
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
                ],
              ),
            ),
    );
  }
}
