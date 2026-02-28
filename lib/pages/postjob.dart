import 'package:auto_size_text/auto_size_text.dart';
import 'package:esearch/pages/postcorporatejob.dart';
import 'package:esearch/pages/posthomebasedjob.dart';
import 'package:esearch/pages/postskillejob.dart';
import 'package:esearch/util/color.dart';
import 'package:flutter/material.dart';

class PostJobPage extends StatefulWidget {
  final String selectedType;
  const PostJobPage({super.key, required this.selectedType});

  @override
  State<PostJobPage> createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: AutoSizeText(
          widget.selectedType,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _getFormUI(widget.selectedType),
      ),
    );
  }

  Widget _getFormUI(String type) {
    if (type == "Corporate Job") {
      return _navigateCard(
        title: "Post Corporate Job",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PostCorporateJob(),
            ),
          );
        },
      );
    } else if (type == "Home-Based Job") {
      return _navigateCard(
        title: "Post Home-Based Job",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostHomebasedJob(),
            ),
          );
        },
      );
    } else {
      return _navigateCard(
        title: "Post Skille job",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostSkillejob(),
            ),
          );
        },
      );
    }
  }

  Widget _navigateCard({
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: maincolor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: maincolor,
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget _simpleText(String text) {
    return Center(
      child: AutoSizeText(
        text,
        style: TextStyle(
          fontSize: 16,
          color: maincolor,
        ),
      ),
    );
  }
}
