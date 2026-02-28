import 'dart:convert';
import 'dart:developer';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:esearch/models/userskill.dart';
import 'package:esearch/util/globaluser.dart' as globaluser;
import 'package:esearch/util/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SkillInfoPage extends StatefulWidget {
  const SkillInfoPage({super.key});

  @override
  State<SkillInfoPage> createState() => _SkillInfoPageState();
}

class _SkillInfoPageState extends State<SkillInfoPage> {
  // Controllers
  late SingleValueDropDownController qualificationController;
  final TextEditingController universityController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController skillTagController = TextEditingController();

  // User
  String userid = "";

  // State
  bool isLoading = false;
  UserSkill? userSkill;

  String qualification = "";
  String? selectedPosition;
  String? selectedExperience;

  final Set<String> selectedRoles = {};
  final List<String> skills = [];

  // Dropdown Data
  final List<DropDownValueModel> qualifications = [
    DropDownValueModel(name: "MP", value: 1),
    DropDownValueModel(name: "HS", value: 2),
    DropDownValueModel(name: "Diploma", value: 3),
    DropDownValueModel(name: "Graduation", value: 4),
    DropDownValueModel(name: "Post Graduation", value: 5),
    DropDownValueModel(name: "Masters", value: 6),
    DropDownValueModel(name: "PHD", value: 7),
  ];

  final List<String> jobRoles = [
    'Software Engineer',
    'Data Analyst',
    'Project Manager',
    'HR Executive',
    'Other',
  ];

  final List<String> experiences = [
    'None',
    '0 - 1 Year',
    '1 - 3 Years',
    '3 - 5 Years',
    '5+ Years',
  ];

  final List<String> positionLevels = [
    'Intern',
    'Junior',
    'Mid-Level',
    'Senior',
    'Lead',
    'Manager',
  ];

  @override
  void initState() {
    super.initState();
    userid = globaluser.user.userid.toString();
    qualificationController = SingleValueDropDownController();
    fetchSkillInfo();
  }

  @override
  void dispose() {
    qualificationController.dispose();
    universityController.dispose();
    yearController.dispose();
    skillTagController.dispose();
    super.dispose();
  }

  // ================= FETCH DATA =================
  Future<void> fetchSkillInfo() async {
    try {
      final response = await http.post(
        Uri.parse("${mainurl}get_skills.php"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"userid": userid},
      );

      final data = json.decode(response.body);

      if (data['status'] == true && data['data'] != null) {
        userSkill = UserSkill.fromJson(data['data']);

        qualification = userSkill!.highestQualifications ?? "";
        universityController.text = userSkill!.university ?? "";
        yearController.text = userSkill!.yearGraduation ?? "";
        selectedPosition = userSkill!.positionLevel;
        selectedExperience = userSkill!.workExperience;

        selectedRoles
          ..clear()
          ..addAll((userSkill!.jobRole ?? "").split(','));

        skills
          ..clear()
          ..addAll((userSkill!.skills ?? "").split(','));

        final match = qualifications.firstWhere(
          (e) => e.name == qualification,
          orElse: () => qualifications.first,
        );

        qualificationController.dropDownValue = match;

        setState(() {});
      }
    } catch (e) {
      log("Fetch Error: $e");
    }
  }

  // ================= SAVE DATA =================
  Future<void> saveSkillInfo() async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("${mainurl}skills.php"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "userid": userid,
          "highest_qualifications": qualification,
          "degree": qualification,
          "university": universityController.text,
          "year_graduation": yearController.text,
          "job_role": selectedRoles.join(','),
          "position_level": selectedPosition ?? "",
          "work_experience": selectedExperience ?? "",
          "skills": skills.join(','),
        },
      );

      final data = json.decode(response.body);

      _showMessage(data['msg'] ?? "Saved successfully");
    } catch (e) {
      _showMessage("Something went wrong");
    }

    setState(() => isLoading = false);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Skills & Experience")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _educationCard(),
            const SizedBox(height: 20),
            _jobCard(),
            const SizedBox(height: 20),
            _skillCard(),
            const SizedBox(height: 30),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  Widget _educationCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.school, "Education & Qualification"),
          const SizedBox(height: 12),
          DropDownTextField(
            controller: qualificationController,
            clearOption: false,
            dropDownList: qualifications,
            textFieldDecoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => qualification = val.name,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: universityController,
                  decoration: const InputDecoration(labelText: "University"),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Year"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _jobCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.work, "Job Role & Experience"),
          Wrap(
            spacing: 8,
            children: jobRoles.map((role) {
              final selected = selectedRoles.contains(role);
              return ChoiceChip(
                label: Text(role),
                selected: selected,
                onSelected: (_) {
                  setState(
                    () => selected
                        ? selectedRoles.remove(role)
                        : selectedRoles.add(role),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: experiences.map((exp) {
              return ChoiceChip(
                label: Text(exp),
                selected: selectedExperience == exp,
                onSelected: (_) => setState(() => selectedExperience = exp),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedPosition,
            items: positionLevels
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => selectedPosition = v),
            decoration: const InputDecoration(labelText: "Position Level"),
          ),
        ],
      ),
    );
  }

  Widget _skillCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.star, "Skills"),
          Wrap(
            spacing: 8,
            children: skills
                .map(
                  (s) => Chip(
                    label: Text(s),
                    onDeleted: () => setState(() => skills.remove(s)),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: skillTagController,
            decoration: InputDecoration(
              hintText: "Add Skill",
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (skillTagController.text.isNotEmpty) {
                    setState(() {
                      skills.add(skillTagController.text.trim());
                      skillTagController.clear();
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : saveSkillInfo,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Save Changes"),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
