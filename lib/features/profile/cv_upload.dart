import 'dart:convert';
import 'package:esearch/widgets/cv_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import 'package:esearch/core/constants/urls.dart';
import 'package:esearch/core/utils/global_user.dart' as globaluser;

class CvUpload extends StatefulWidget {
  const CvUpload({super.key});

  @override
  State<CvUpload> createState() => _CvUploadState();
}

class _CvUploadState extends State<CvUpload> {
  String? fileName;
  String? filePath;

  // PICK CV
  Future<void> pickCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
        filePath = result.files.single.path;
      });
    }
  }

  Future<void> uploadCV() async {
    if (filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a CV first")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${mainurl}cv_upload.php"),
      );

      request.files.add(
        await http.MultipartFile.fromPath('cv', filePath!),
      );

      request.fields['userid'] = globaluser.user.userid.toString();

      var response = await request.send();
      var res = await http.Response.fromStream(response);

      Navigator.pop(context);

      var jsonData = jsonDecode(res.body);

      if (jsonData['status'] == true) {
        globaluser.user.cv = jsonData['cv_name'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonData['msg'])),
        );

        setState(() {
          fileName = null;
          filePath = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonData['msg'])),
        );
      }
    } catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasCV =
        globaluser.user.cv != null &&
        globaluser.user.cv != "" &&
        globaluser.user.cv != "null";
    final cvUrl = mainurl + "CV_uploads/" + globaluser.user.cv.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload CV"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            GestureDetector(
              onTap: () {
                if (hasCV) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CvViewerPage(url: cvUrl),
                    ),
                  );
                } else {
                  pickCV();
                }
              },
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: hasCV
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.picture_as_pdf,
                            size: 50,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            globaluser.user.cv.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Tap to view your CV",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file, size: 50, color: Colors.blue),
                          SizedBox(height: 10),
                          Text("Tap to upload your CV"),
                          SizedBox(height: 5),
                          Text(
                            "Only PDF allowed",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 25),

            if (fileName != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, color: Colors.red),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        fileName!,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          fileName = null;
                          filePath = null;
                        });
                      },
                    ),
                  ],
                ),
              ),

            const Spacer(),

            if (fileName != null)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: uploadCV,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text("Upload CV"),
                ),
              )
            else if (hasCV)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: pickCV,
                  icon: const Icon(Icons.edit),
                  label: const Text("Update CV"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
