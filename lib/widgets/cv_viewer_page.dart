import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CvViewerPage extends StatelessWidget {
  final String url;

  const CvViewerPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    print("PDF URL: $url");

    return Scaffold(
      appBar: AppBar(
        title: const Text("View CV"),
      ),
      body: SfPdfViewer.network(
        url,
        onDocumentLoadFailed: (details) {
          print("ERROR: ${details.error}");
          print("DESCRIPTION: ${details.description}");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to load PDF"),
            ),
          );
        },
      ),
    );
  }
}
