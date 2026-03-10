import 'package:esearch/util/color.dart';
import 'package:flutter/material.dart';

import '../models/saved_job.dart';
import '../util/database_helper.dart';
import '../widgets/job_card.dart';

class CorporateJobs extends StatefulWidget {
  const CorporateJobs({super.key});

  @override
  State<CorporateJobs> createState() => _CorporateJobsState();
}

class _CorporateJobsState extends State<CorporateJobs> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkSavedStatus();
  }

  Future<void> _checkSavedStatus() async {
    // check uniqueness using the category too
    const title = 'Junior Software Engineer';
    const company = 'Jay Balaji Enterprise';
    final exists = await DatabaseHelper.instance.isJobSaved(
      title,
      company,
      category: 'Corporate',
    );
    setState(() {
      _isSaved = exists;
    });
  }

  Future<void> _saveJob() async {
    final job = SavedJob(
      title: 'Junior Software Engineer',
      company: 'Jay Balaji Enterprise',
      salary: '₹ 18,000 - ₹ 24,000 per month',
      location: 'Jadavpur, Kolkata (>100 kms)',
      type: 'Full-Time',
      vacancy: '25 Vacancies',
      category: 'Corporate',
    );
    await DatabaseHelper.instance.insertJob(job);
    setState(() {
      _isSaved = true;
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
            // 🔍 Search Bar with Shadow
            Container(
              child: TextField(
                cursorColor: maincolor,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Search jobs or location",
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
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
            ),

            const SizedBox(height: 20),

            JobCard(
              title: 'Junior Software Engineer',
              company: 'Jay Balaji Enterprise',
              salary: '₹ 18,000 - ₹ 24,000 per month',
              location: 'Jadavpur, Kolkata (>100 kms)',
              type: 'Full-Time',
              vacancy: '25 Vacancies',
              category: 'Corporate',
              isSaved: _isSaved,
              onSave: _saveJob,
            ),
          ],
        ),
      ),
    );
  }
}
