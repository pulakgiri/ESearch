import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:esearch/core/theme/app_theme.dart';
import 'package:esearch/core/constants/colors.dart';
import 'package:esearch/core/utils/loading.dart';
import 'package:esearch/core/constants/urls.dart';
import 'package:esearch/core/utils/global_user.dart' as globaluser;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PostHomebasedJob extends StatefulWidget {
  final Map<String, dynamic>? job;
  const PostHomebasedJob({super.key, this.job});

  @override
  State<PostHomebasedJob> createState() => _PostHomebasedJobState();
}

class _PostHomebasedJobState extends State<PostHomebasedJob> {
  final roleCtrl = TextEditingController();
  final jobTitleCtrl = TextEditingController();
  final salaryCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final experienceCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final skillsCtrl = TextEditingController();

  final List<String> skills = [];

  bool isEditing = false;
  bool allowWhatsapp = false;
  bool isSubmitting = false;

  String? recordId;
  String startTime = '08:00 AM';
  String endTime = '05:00 PM';

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      final job = widget.job!;
      isEditing = true;
      recordId = job['id']?.toString();

      roleCtrl.text = job['role'] ?? '';
      jobTitleCtrl.text = job['job_title'] ?? '';
      salaryCtrl.text = job['salary'] ?? '';
      locationCtrl.text = job['location'] ?? '';
      phoneCtrl.text = job['phone'] ?? '';
      experienceCtrl.text = job['experience_needed'] ?? '';
      descriptionCtrl.text = job['description'] ?? '';

      startTime = job['start_time'] ?? startTime;
      endTime = job['end_time'] ?? endTime;

      allowWhatsapp = job['allow_whatsapp'] == '1';

      if (job['skills'] != null) {
        skills.addAll(
          job['skills']
              .toString()
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty),
        );
      }
    }
  }

  @override
  void dispose() {
    roleCtrl.dispose();
    jobTitleCtrl.dispose();
    salaryCtrl.dispose();
    locationCtrl.dispose();
    phoneCtrl.dispose();
    experienceCtrl.dispose();
    descriptionCtrl.dispose();
    skillsCtrl.dispose();
    super.dispose();
  }

  void _addSkill(String value) {
    final v = value.trim();
    if (v.isEmpty) return;
    if (!skills.contains(v)) setState(() => skills.add(v));
    skillsCtrl.clear();
  }

  void _removeSkill(String value) {
    setState(() => skills.remove(value));
  }

  Future<void> _pickTime(bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: isStart ? 8 : 17,
        minute: 0,
      ),
    );
    if (time == null) return;

    setState(() {
      if (isStart) {
        startTime = time.format(context);
      } else {
        endTime = time.format(context);
      }
    });
  }

  void _resetForm() {
    roleCtrl.clear();
    jobTitleCtrl.clear();
    salaryCtrl.clear();
    locationCtrl.clear();
    phoneCtrl.clear();
    experienceCtrl.clear();
    descriptionCtrl.clear();
    skillsCtrl.clear();
    skills.clear();
    allowWhatsapp = false;
    startTime = '08:00 AM';
    endTime = '05:00 PM';
  }

  Future<void> postHomebasedJob() async {
    FocusScope.of(context).unfocus();

    if (skillsCtrl.text.trim().isNotEmpty) {
      _addSkill(skillsCtrl.text);
    }

    if (jobTitleCtrl.text.trim().isEmpty ||
        descriptionCtrl.text.trim().isEmpty ||
        phoneCtrl.text.trim().length < 10) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Validation Error',
        desc: 'Please fill all required fields correctly.',
        btnOkOnPress: () {},
      ).show();
      return;
    }

    if (isSubmitting) return;
    setState(() => isSubmitting = true);

    final data = {
      'userid': globaluser.user.userid.toString(),
      'role': roleCtrl.text.trim(),
      'job_title': jobTitleCtrl.text.trim(),
      'start_time': startTime,
      'end_time': endTime,
      'salary': salaryCtrl.text.trim(),
      'location': locationCtrl.text.trim(),
      'phone': phoneCtrl.text.trim(),
      'experience_needed': experienceCtrl.text.trim(),
      'description': descriptionCtrl.text.trim(),
      'skills': skills.join(', '),
      'allow_whatsapp': allowWhatsapp ? '1' : '0',
    };

    if (isEditing) data['id'] = recordId ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingDialog(),
    );

    try {
      final url = isEditing
          ? '${mainurl}update_homebased_job.php'
          : '${mainurl}post_homebased_job.php';

      final res = await http.post(Uri.parse(url), body: data);
      final json = jsonDecode(res.body);

      if (!mounted) return;
      Navigator.pop(context);

      if (json['status'] == true) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: isEditing ? 'Job Updated' : 'Job Posted',
          desc: 'Your job has been saved successfully.',
          btnOkOnPress: () {
            if (!isEditing) _resetForm();
            Navigator.pop(context);
          },
        ).show();
      } else {
        throw json['msg'] ?? 'Server Error';
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        desc: e.toString(),
        btnOkOnPress: () {},
      ).show();
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth < 600
        ? double.infinity
        : (screenWidth < 1024 ? 600.0 : 520.0);
    final horizontalPadding = screenWidth < 600
        ? 20.0
        : (screenWidth < 1024 ? 40.0 : 60.0);
    final verticalPadding = screenWidth < 600
        ? 20.0
        : (screenWidth < 1024 ? 28.0 : 36.0);

    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 20,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          isEditing ? 'Edit Home Job' : 'Post Home Job',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppTheme.borderColor,
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeaderSection(),
                const SizedBox(height: 32),

                // Basic Information Card
                _buildCard(
                  title: 'Basic Information',
                  icon: Icons.info_outline,
                  children: [
                    _buildInputField(
                      label: "Role",
                      hint: "e.g., Housekeeper, Cook, Gardener",
                      controller: roleCtrl,
                      icon: Icons.work_outline_rounded,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: "Job Title",
                      hint: "Enter job title",
                      controller: jobTitleCtrl,
                      icon: Icons.badge_outlined,
                      isRequired: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Working Hours Card
                _buildCard(
                  title: 'Working Hours',
                  icon: Icons.schedule_outlined,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimeField(
                            label: "Start Time",
                            value: startTime,
                            onTap: () => _pickTime(true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTimeField(
                            label: "End Time",
                            value: endTime,
                            onTap: () => _pickTime(false),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Compensation & Location Card
                _buildCard(
                  title: 'Compensation & Location',
                  icon: Icons.payments_outlined,
                  children: [
                    _buildInputField(
                      label: "Salary",
                      hint: "Enter salary amount",
                      controller: salaryCtrl,
                      icon: Icons.attach_money_rounded,
                      isNumber: true,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: "Location",
                      hint: "Enter job location",
                      controller: locationCtrl,
                      icon: Icons.location_on_outlined,
                      suffixIcon: Icons.my_location_rounded,
                      onSuffixTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Contact Information Card
                _buildCard(
                  title: 'Contact Information',
                  icon: Icons.contact_phone_outlined,
                  children: [
                    _buildInputField(
                      label: "Phone Number",
                      hint: "Enter contact number",
                      controller: phoneCtrl,
                      icon: Icons.phone_outlined,
                      isNumber: true,
                      isRequired: true,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      label: "Experience Required",
                      hint: "e.g., 2 years, Fresher",
                      controller: experienceCtrl,
                      icon: Icons.timeline_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Job Description Card
                _buildCard(
                  title: 'Job Description',
                  icon: Icons.description_outlined,
                  children: [
                    _buildInputField(
                      label: "Description",
                      hint:
                          "Describe the job responsibilities and requirements in detail",
                      controller: descriptionCtrl,
                      icon: Icons.notes_rounded,
                      maxLines: 6,
                      isRequired: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Skills Card
                _buildCard(
                  title: 'Required Skills',
                  icon: Icons.stars_outlined,
                  children: [
                    if (skills.isNotEmpty) ...[
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: skills
                            .map((skill) => _buildSkillChip(skill))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildSkillInput(),
                  ],
                ),
                const SizedBox(height: 24),

                // WhatsApp Contact Card
                _buildWhatsAppCard(),
                const SizedBox(height: 36),

                // Submit Button
                _buildSubmitButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditing ? 'Update Job Details' : 'Create New Job Posting',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -0.8,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isEditing
              ? 'Make changes to your job posting'
              : 'Fill in the details to post a new home-based job',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
            letterSpacing: 0.2,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.borderColor, width: 1),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.ultraLightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? icon,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    bool isNumber = false,
    bool isRequired = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  color: AppTheme.error,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            boxShadow: AppTheme.inputShadow,
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            maxLines: maxLines,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16, right: 12),
                      child: Icon(icon, color: AppTheme.darkGray, size: 22),
                    )
                  : null,
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: Icon(
                        suffixIcon,
                        color: AppTheme.primaryBlue,
                        size: 22,
                      ),
                      onPressed: onSuffixTap,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.borderColor, width: 1.5),
              boxShadow: AppTheme.inputShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.ultraLightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.access_time_rounded,
                    color: AppTheme.primaryBlue,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.ultraLightBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryBlue.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            skill,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlue,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _removeSkill(skill),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillInput() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: AppTheme.inputShadow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: skillsCtrl,
        onSubmitted: _addSkill,
        style: const TextStyle(
          fontSize: 15,
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
        decoration: InputDecoration(
          hintText: 'Type a skill and press enter',
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16, right: 12),
            child: Icon(
              Icons.add_circle_outline_rounded,
              color: AppTheme.darkGray,
              size: 22,
            ),
          ),
          suffixIcon: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: AppTheme.white,
                size: 18,
              ),
            ),
            onPressed: () {
              if (skillsCtrl.text.trim().isNotEmpty) {
                _addSkill(skillsCtrl.text);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWhatsAppCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: allowWhatsapp
              ? AppTheme.success.withValues(alpha: 0.3)
              : AppTheme.borderColor,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => allowWhatsapp = !allowWhatsapp),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: allowWhatsapp
                        ? AppTheme.success
                        : AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    allowWhatsapp
                        ? Icons.check_circle_rounded
                        : Icons.chat_bubble_outline_rounded,
                    color: allowWhatsapp ? AppTheme.white : AppTheme.darkGray,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'WhatsApp Contact',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        allowWhatsapp
                            ? 'Candidates can contact via WhatsApp'
                            : 'Tap to allow WhatsApp contact',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  allowWhatsapp
                      ? Icons.toggle_on_rounded
                      : Icons.toggle_off_rounded,
                  color: allowWhatsapp ? AppTheme.success : AppTheme.mediumGray,
                  size: 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSubmitting ? [] : AppTheme.buttonShadow,
      ),
      child: ElevatedButton(
        onPressed: isSubmitting ? null : postHomebasedJob,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: AppTheme.white,
          disabledBackgroundColor: AppTheme.mediumGray,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isEditing ? 'UPDATE JOB' : 'POST JOB',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.arrow_forward_rounded, size: 20),
                  ),
                ],
              ),
      ),
    );
  }
}
