import 'package:esearch/core/constants/colors.dart';
import 'package:flutter/material.dart';

import 'package:esearch/models/saved_job.dart';
import 'package:esearch/core/utils/database_helper.dart';
import 'package:esearch/widgets/job_card.dart';

class DomesticServices extends StatefulWidget {
  const DomesticServices({super.key});

  @override
  State<DomesticServices> createState() => _DomesticServicesState();
}

class _DomesticServicesState extends State<DomesticServices> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkSaved();
  }

  Future<void> _checkSaved() async {
    final exists = await DatabaseHelper.instance.isJobSaved(
      'Junior Software Engineer',
      'Jay Balaji Enterprise',
      category: 'Domestic',
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
      category: 'Domestic',
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
            JobCard(
              title: 'Junior Software Engineer',
              company: 'Jay Balaji Enterprise',
              salary: '₹ 18,000 - ₹ 24,000 per month',
              location: 'Jadavpur, Kolkata (>100 kms)',
              type: 'Full-Time',
              vacancy: '25 Vacancies',
              category: 'Domestic',
              isSaved: _isSaved,
              onSave: _saveJob,
            ),
          ],
        ),
      ),
    );
  }
}
