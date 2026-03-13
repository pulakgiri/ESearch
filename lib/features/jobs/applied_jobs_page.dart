import 'dart:io';
import 'package:esearch/core/constants/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AppliedJob extends StatefulWidget {
  const AppliedJob({super.key});

  @override
  State<AppliedJob> createState() => _AppliedJobState();
}

class _AppliedJobState extends State<AppliedJob> {
  File? pdfFile;

  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        pdfFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: const Text("Applied Job"),
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          Expanded(
            child: pdfFile == null
                ? const Center(
                    child: Text("No PDF Selected"),
                  )
                : SfPdfViewer.file(pdfFile!),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: pickPdf,
            child: const Text("Select Resume PDF"),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
