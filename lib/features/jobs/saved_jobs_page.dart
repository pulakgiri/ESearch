import 'package:esearch/core/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../models/saved_job.dart';
import '../../core/utils/database_helper.dart';

class SavedJobs extends StatefulWidget {
  const SavedJobs({super.key});

  @override
  State<SavedJobs> createState() => _SavedJobsState();
}

class _SavedJobsState extends State<SavedJobs> {
  // list loaded from database
  List<SavedJob> savedJobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobsFromDb();
  }

  Future<void> _loadJobsFromDb() async {
    final jobs = await DatabaseHelper.instance.getSavedJobs();
    setState(() {
      savedJobs = jobs;
    });
  }

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

  Widget _savedJobCard(SavedJob job, int index) {
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
                  job.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.bookmark, color: Colors.blue),
                onPressed: () async {
                  // delete from database then remove from list
                  if (job.id != null) {
                    await DatabaseHelper.instance.deleteJob(job.id!);
                  }
                  setState(() {
                    savedJobs.removeAt(index);
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            job.company,
            style: const TextStyle(color: Colors.grey),
          ),

          if (job.category != null) ...[
            const SizedBox(height: 4),
            Text(
              job.category!,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
            ),
          ],

          const SizedBox(height: 10),

          Text(
            job.salary,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            job.location,
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Chip(label: Text(job.type)),
              const SizedBox(width: 8),
              Chip(label: Text(job.vacancy)),
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
