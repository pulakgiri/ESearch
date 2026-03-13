import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:esearch/core/constants/colors.dart';
import 'package:esearch/core/utils/loading.dart';
import 'package:esearch/core/constants/urls.dart';
import 'package:esearch/core/utils/global_user.dart' as globaluser;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostCorporateJob extends StatefulWidget {
  const PostCorporateJob({super.key});

  @override
  State<PostCorporateJob> createState() => _PostCorporateJobState();
}

class _PostCorporateJobState extends State<PostCorporateJob> {
  final TextEditingController companyNameCtrl = TextEditingController();
  final TextEditingController websiteCtrl = TextEditingController();
  final TextEditingController jobTitleCtrl = TextEditingController();
  final TextEditingController locationCtrl = TextEditingController();
  final TextEditingController salaryCtrl = TextEditingController();
  final TextEditingController vacanciesCtrl = TextEditingController();
  final TextEditingController experienceCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController skillsCtrl = TextEditingController();
  final List<String> skills = [];

  void _addSkill(String v) {
    final s = v.trim();
    if (s.isEmpty) return;
    if (!skills.contains(s)) {
      setState(() => skills.add(s));
    }
    skillsCtrl.clear();
  }

  void _removeSkill(String v) {
    setState(() => skills.remove(v));
  }

  final TextEditingController hrNameCtrl = TextEditingController();
  final TextEditingController hrPhoneCtrl = TextEditingController();
  final TextEditingController hrEmailCtrl = TextEditingController();
  String employmentType = 'Full-time';
  String workMode = 'On-site';

  @override
  void dispose() {
    companyNameCtrl.dispose();
    websiteCtrl.dispose();
    locationCtrl.dispose();
    salaryCtrl.dispose();
    jobTitleCtrl.dispose();
    vacanciesCtrl.dispose();
    experienceCtrl.dispose();
    descriptionCtrl.dispose();
    skillsCtrl.dispose();
    hrNameCtrl.dispose();
    hrPhoneCtrl.dispose();
    hrEmailCtrl.dispose();
    super.dispose();
  }

  Future<void> postCorporateJob() async {
    // client-side validation: require company, title and description
    final companyText = companyNameCtrl.text.trim();
    final titleText = jobTitleCtrl.text.trim();
    final descText = descriptionCtrl.text.trim();
    if (companyText.isEmpty || titleText.isEmpty || descText.isEmpty) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Missing Fields',
        desc: 'Please provide company, job title and job description.',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    // include pending skill typed but not yet added
    final List<String> finalSkills = List.from(skills);
    final pending = skillsCtrl.text.trim();
    if (pending.isNotEmpty && !finalSkills.contains(pending))
      finalSkills.add(pending);

    Map<String, String> data = {
      'userid': globaluser.user.userid.toString(),
      'company_name': companyText,
      'company': companyText,
      'website': websiteCtrl.text.trim(),
      'job_title': titleText,
      'employment_type': employmentType,
      'work_mode': workMode,
      'location': locationCtrl.text.trim(),
      'salary': salaryCtrl.text.trim(),
      'vacancies': vacanciesCtrl.text.trim(),
      'experience_needed': experienceCtrl.text.trim(),
      'description': descText,
      'job_description': descText,
      'skills': finalSkills.join(', '),
      'hr_name': hrNameCtrl.text.trim(),
      'hr_phone': hrPhoneCtrl.text.trim(),
      'hr_email': hrEmailCtrl.text.trim(),
    };

    showDialog(
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        child: const LoadingDialog(),
      ),
      barrierDismissible: false,
    );

    try {
      var response = await http.post(
        Uri.parse("${mainurl}post_corporate_job.php"),
        body: data,
      );
      // debug: print status and body
      // ignore: avoid_print
      print('post_corporate_job status: ${response.statusCode}');
      // ignore: avoid_print
      print('post_corporate_job response: ${response.body}');

      Map<String, dynamic> jsondata;
      try {
        jsondata = jsonDecode(response.body);
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context);
        // show server/raw response for debugging
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'Server Error',
          desc: 'Invalid response from server:\n${response.body}',
          btnOkOnPress: () {},
        ).show();
        return;
      }

      if (jsondata['status']) {
        if (!mounted) return;
        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: "Post Success",
          dismissOnTouchOutside: false,
          btnOkOnPress: () {
            // clear form
            companyNameCtrl.clear();
            websiteCtrl.clear();
            locationCtrl.clear();
            salaryCtrl.clear();
            jobTitleCtrl.clear();
            vacanciesCtrl.clear();
            experienceCtrl.clear();
            descriptionCtrl.clear();
            skillsCtrl.clear();
            skills.clear();
            hrNameCtrl.clear();
            hrPhoneCtrl.clear();
            hrEmailCtrl.clear();
            setState(() {
              employmentType = 'Full-time';
              workMode = 'On-site';
            });
          },
        ).show();
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          desc: jsondata['msg'],
          dismissOnTouchOutside: false,
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      if (!mounted) return;
      // ensure loading dialog removed
      try {
        Navigator.pop(context);
      } catch (_) {}
      // debug print
      // ignore: avoid_print
      print('post_corporate_job exception: $e');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: "Network Error",
        desc: "Error: ${e.toString()}",
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FF),
      appBar: AppBar(
        backgroundColor: maincolor,
        foregroundColor: Colors.white,
        title: const Text("Corporate Job"),
        actions: const [
          Icon(Icons.more_vert),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(Icons.business, "Company Information"),
                  const SizedBox(height: 16),

                  _label("Company Name"),
                  _textField("e.g. Acme Corp", controller: companyNameCtrl),

                  const SizedBox(height: 12),

                  _label("Website (Optional)"),
                  _textField("https://acme.co", controller: websiteCtrl),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(Icons.work, "Job Details"),
                  const SizedBox(height: 16),

                  _label("Job Title"),
                  _textField(
                    "e.g. Senior Product Designer",
                    controller: jobTitleCtrl,
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 6),
                              child: Text(
                                'Location',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            TextField(
                              controller: locationCtrl,
                              decoration: InputDecoration(
                                hintText: 'City, State or Remote',
                                filled: true,
                                fillColor: const Color(0xFFF8F9FF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 6),
                              child: Text(
                                'Salary',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            TextField(
                              controller: salaryCtrl,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'e.g. 60000-80000',
                                filled: true,
                                fillColor: const Color(0xFFF8F9FF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _dropdown(
                          "Employment Type",
                          employmentType,
                          ['Full-time', 'Part-time', 'Contract', 'Internship'],
                          (v) => setState(
                            () => employmentType = v ?? employmentType,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dropdown(
                          "Work Mode",
                          workMode,
                          ['On-site', 'Remote', 'Hybrid'],
                          (v) => setState(() => workMode = v ?? workMode),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _label("Number of Vacancies"),
                  _textField(
                    "1",
                    keyboardType: TextInputType.number,
                    controller: vacanciesCtrl,
                  ),

                  const SizedBox(height: 12),

                  _label("Experience Needed"),
                  _textField(
                    "e.g. 2-3 years",
                    controller: experienceCtrl,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(Icons.description, "Description & Skills"),
                  const SizedBox(height: 16),

                  _label("Job Description"),
                  _textArea(
                    "Describe the role, responsibilities, etc.",
                    controller: descriptionCtrl,
                  ),

                  const SizedBox(height: 16),

                  _label("Key Skills"),
                  Wrap(
                    spacing: 8,
                    children: skills
                        .map(
                          (s) => InputChip(
                            label: Text(s),
                            onDeleted: () => _removeSkill(s),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: skillsCtrl,
                    decoration: InputDecoration(
                      hintText: 'Add a skill and press enter',
                      filled: true,
                      fillColor: const Color(0xFFF8F9FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _addSkill(skillsCtrl.text),
                      ),
                    ),
                    onSubmitted: _addSkill,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(Icons.person, "HR Contact Information"),
                  const SizedBox(height: 16),

                  _label("HR Representative Name"),
                  _textField("Full Name", controller: hrNameCtrl),

                  const SizedBox(height: 12),

                  _label("HR Phone"),
                  _textField(
                    "+1 (555) 000-0000",
                    keyboardType: TextInputType.phone,
                    controller: hrPhoneCtrl,
                  ),

                  const SizedBox(height: 12),

                  _label("HR Email"),
                  _textField(
                    "hr@company.com",
                    keyboardType: TextInputType.emailAddress,
                    controller: hrEmailCtrl,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: maincolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.send),
            label: const Text(
              "Post Job Opening",
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await Future.delayed(const Duration(milliseconds: 100));
              await postCorporateJob();
            },
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _title(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: maincolor),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _textField(
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8F9FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _textArea(
    String hint, {
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8F9FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        DropdownButtonFormField<String>(
          initialValue: options.contains(value) ? value : options.first,
          items: options
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8F9FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
