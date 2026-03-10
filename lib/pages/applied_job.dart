import 'package:esearch/util/color.dart';
import 'package:flutter/material.dart';

class AppliedJob extends StatefulWidget {
  const AppliedJob({super.key});

  @override
  State<AppliedJob> createState() => _AppliedJobState();
}

class _AppliedJobState extends State<AppliedJob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.maincolor,
        leading: Text("Applied Job"),
      ),
    );
  }
}
