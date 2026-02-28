import 'package:esearch/util/color.dart';
import 'package:flutter/material.dart';

class SearchForJobs extends StatefulWidget {
  const SearchForJobs({super.key});

  @override
  State<SearchForJobs> createState() => _SearchForJobsState();
}

class _SearchForJobsState extends State<SearchForJobs> {
  final TextEditingController searchController = TextEditingController();
  final List<String> recentSearches = [];

  final List<String> popularSearches = [
    "Python Developer",
    "Back End Developer",
    "Backend Web Developer",
    "Front End Developer",
    "Angular Developer",
  ];

  void addRecentSearch(String value) {
    if (value.trim().isEmpty) return;

    setState(() {
      recentSearches.remove(value);
      recentSearches.insert(0, value);
    });
  }

  void performSearch(String value) {
    searchController.text = value;
    addRecentSearch(value);
  }

  Widget _chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: maincolor,
        title: Text(
          "Job Search",
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: searchController,
                onSubmitted: performSearch,
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: "Search for Job",
                ),
              ),
            ),

            SizedBox(height: 20),

            if (recentSearches.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "Recent Searches",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: recentSearches.map((item) {
                return GestureDetector(
                  onTap: () => performSearch(item),
                  onLongPress: () {
                    setState(() => recentSearches.remove(item));
                  },
                  child: _chip(item),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Icon(Icons.trending_up, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Popular Search",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: popularSearches.map((item) {
                return GestureDetector(
                  onTap: () => performSearch(item),
                  child: _chip(item),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
