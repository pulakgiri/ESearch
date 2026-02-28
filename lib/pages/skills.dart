import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_textfield/dropdown_textfield.dart';
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
  final SingleValueDropDownController qualificationController =
      SingleValueDropDownController();
  final TextEditingController universityController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController skillTagController = TextEditingController();

  String userid = "";
  String qualification = "";
  String? selectedPosition;
  String? selectedExperience;

  final Set<String> selectedRoles = {};
  final List<String> skills = [];

  bool isLoading = false;

  List<DropDownValueModel> qualifications = [
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

  // ---------------- LOAD EXISTING DATA ----------------
  void loadExistingSkillData() {
    final skill = globaluser.userSkill;
    if (skill == null) return;

    log(skill.toString());

    setState(() {
      // Qualification
      qualification = skill.highestQualifications ?? "";
      final match = qualifications.firstWhere(
        (e) => e.name == qualification,
        orElse: () => qualifications.first,
      );
      qualificationController.setDropDown(match);

      // University & Year
      universityController.text = skill.university ?? "";
      yearController.text = skill.yearGraduation ?? "";

      // Job roles
      if (skill.jobRole != null && skill.jobRole!.isNotEmpty) {
        selectedRoles.addAll(skill.jobRole!.split(","));
      }

      // Experience & Position
      selectedExperience = skill.workExperience;
      selectedPosition = skill.positionLevel;

      // Skills
      if (skill.skills != null && skill.skills!.isNotEmpty) {
        skills.addAll(skill.skills!.split(","));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    userid = globaluser.user.userid.toString();
    loadExistingSkillData();
  }

  @override
  void dispose() {
    qualificationController.dispose();
    universityController.dispose();
    yearController.dispose();
    skillTagController.dispose();
    super.dispose();
  }

  // ---------------- SAVE DATA ----------------
  Future<void> saveSkillInfo() async {
    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("${mainurl}skills.php"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "userid": userid,
          "highest_qualifications": qualification,
          "degree": qualification,
          "university": universityController.text,
          "year_graduation": yearController.text,
          "job_role": selectedRoles.join(","),
          "position_level": selectedPosition ?? "",
          "work_experience": selectedExperience ?? "",
          "skills": skills.join(","),
        },
      );

      final data = json.decode(response.body);

      if (data['status'] == true) {
        _showMessage("Skills saved successfully");
      } else {
        _showMessage(data['msg']);
      }
    } catch (e) {
      _showMessage("Something went wrong");
    }

    setState(() => isLoading = false);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skills & Experience"),
      ),
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
          const SizedBox(height: 16),
          const Text("Highest Qualification"),
          const SizedBox(height: 6),
          DropDownTextField(
            controller: qualificationController,
            clearOption: false,
            dropDownList: qualifications,
            textFieldDecoration: const InputDecoration(
              hintText: "Select Qualification",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onChanged: (val) {
              if (val != null) qualification = val.name;
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: universityController,
                  decoration: const InputDecoration(
                    labelText: "University",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Year",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
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
          const SizedBox(height: 16),
          const Text("Target Job Roles"),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: jobRoles.map((role) {
              final selected = selectedRoles.contains(role);
              return ChoiceChip(
                label: Text(role),
                selected: selected,
                selectedColor: Colors.blue,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                ),
                onSelected: (_) {
                  setState(() {
                    selected
                        ? selectedRoles.remove(role)
                        : selectedRoles.add(role);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text("Work Experience"),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: experiences.map((exp) {
              final selected = selectedExperience == exp;
              return ChoiceChip(
                label: Text(exp),
                selected: selected,
                selectedColor: Colors.blue,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                ),
                onSelected: (_) {
                  setState(() => selectedExperience = exp);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "Position Level",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            value: selectedPosition,
            items: positionLevels
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (val) => setState(() => selectedPosition = val),
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
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: skills.map((skill) {
              return Chip(
                label: Text(skill),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () {
                  setState(() => skills.remove(skill));
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: skillTagController,
            decoration: InputDecoration(
              hintText: "Add skill",
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
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
