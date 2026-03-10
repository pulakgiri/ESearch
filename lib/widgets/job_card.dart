import 'package:esearch/models/saved_job.dart';
import 'package:flutter/material.dart';

/// A reusable job card widget with optional save/bookmark icon.
///
/// The parent provides the job data and callbacks for saving/removing.
class JobCard extends StatelessWidget {
  final String title;
  final String company;
  final String salary;
  final String location;
  final String type;
  final String vacancy;
  final String? category;
  final bool isSaved;
  final VoidCallback? onSave;

  const JobCard({
    super.key,
    required this.title,
    required this.company,
    required this.salary,
    required this.location,
    required this.type,
    required this.vacancy,
    this.category,
    this.isSaved = false,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
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
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (onSave != null)
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.blue,
                  ),
                  onPressed: isSaved ? null : onSave,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            company,
            style: const TextStyle(color: Colors.grey),
          ),
          if (category != null) ...[
            const SizedBox(height: 4),
            Text(
              category!,
              style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            salary,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            location,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Chip(label: Text(type)),
              const SizedBox(width: 8),
              Chip(label: Text(vacancy)),
            ],
          ),
        ],
      ),
    );
  }
}
