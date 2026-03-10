import 'package:esearch/util/color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostSkillejob extends StatefulWidget {
  const PostSkillejob({super.key});

  @override
  State<PostSkillejob> createState() => _PostSkillejobState();
}

class _PostSkillejobState extends State<PostSkillejob> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController specificSkillController = TextEditingController();
  final TextEditingController tagController = TextEditingController();
  final Set<String> tags = {};

  final TextEditingController minExpController = TextEditingController();
  String? certification;
  final TextEditingController toolsController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String rateType = 'Hourly';

  final TextEditingController locationController = TextEditingController();

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  void dispose() {
    categoryController.dispose();
    specificSkillController.dispose();
    tagController.dispose();
    minExpController.dispose();
    toolsController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    locationController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Post Skilled Labour",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _resetForm,
            child: const Text("Reset"),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// JOB CATEGORY
            _sectionTitle("Job Category"),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Skill Category"),

                  _dropdown(
                    "Select Trade",
                    options: [
                      'Plumber',
                      'Mechanic',
                      'Car Washer',
                      'Electrician',
                    ],
                    value: categoryController.text.isNotEmpty
                        ? categoryController.text
                        : null,
                    onChanged: (v) {
                      setState(() {
                        categoryController.text = v ?? '';
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  _label("Specific Skill"),

                  _textField(
                    "e.g. Industrial Wiring",
                    controller: specificSkillController,
                    keyboardType: TextInputType.text,
                  ),

                  const SizedBox(height: 16),

                  /// TAG INPUT
                  Row(
                    children: [
                      Expanded(
                        child: _textField(
                          "Enter tag",
                          controller: tagController,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addTag,
                        child: const Text("Add"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: tags.map((t) => _chip(t)).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// EXPERIENCE
            _sectionTitle("Experience & Qualification"),
            _card(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _textField(
                          "Years",
                          label: "Min Experience",
                          controller: minExpController,
                          keyboardType: TextInputType.number,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _dropdown(
                          "Licensed",
                          label: "Certification",
                          options: ['Yes', 'No'],
                          value: certification,
                          onChanged: (v) {
                            setState(() {
                              certification = v;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _label("Tools Knowledge"),

                  _textField(
                    "e.g. Oscilloscope, Power Drills",
                    controller: toolsController,
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// WORK DETAILS
            _sectionTitle("Work Details & Pay"),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Work Description"),

                  _textArea(
                    "Explain the project scope",
                    controller: descriptionController,
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _dateField(
                          "Start date",
                          controller: startDateController,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _dateField(
                          "End date",
                          controller: endDateController,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _textField(
                          "Amount",
                          label: "Charges",
                          controller: amountController,
                          keyboardType: TextInputType.number,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _rateType(),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// LOCATION
            _sectionTitle("Location & Contact"),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Site Location"),

                  _textField(
                    "Street Address, City",
                    prefixIcon: Icons.location_on,
                    controller: locationController,
                    keyboardType: TextInputType.text,
                  ),

                  const SizedBox(height: 12),

                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.grey.shade300,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.map,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: maincolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: const Icon(Icons.send),
            label: const Text("Post Skilled Labour"),
            onPressed: _postJob,
          ),
        ),
      ),
    );
  }

  /// UI HELPERS

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
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
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: child,
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _textField(
    String hint, {
    String? label,
    IconData? prefixIcon,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) _label(label),

        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
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

  Widget _textArea(String hint, {TextEditingController? controller}) {
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
    String hint, {
    String? label,
    List<String>? options,
    String? value,
    ValueChanged<String?>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) _label(label),

        DropdownButtonFormField<String>(
          value: value,
          items: (options ?? [])
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
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

  Widget _chip(String text) {
    return Chip(
      label: Text(text),
      deleteIcon: const Icon(Icons.close),
      onDeleted: () {
        setState(() {
          tags.remove(text);
        });
      },
    );
  }

  Widget _rateType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Rate Type"),

        Row(
          children: [
            _rateChip("Hourly"),
            const SizedBox(width: 8),
            _rateChip("Daily"),
          ],
        ),
      ],
    );
  }

  Widget _rateChip(String text) {
    bool selected = rateType == text;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            rateType = text;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.blue.shade50 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? Colors.blue : Colors.transparent,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.blue : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateField(String hint, {TextEditingController? controller}) {
    return _textField(
      hint,
      controller: controller,
      keyboardType: TextInputType.datetime,
      readOnly: true,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );

        if (picked != null) {
          controller?.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      },
    );
  }

  void _addTag() {
    if (tagController.text.trim().isEmpty) return;

    setState(() {
      tags.add(tagController.text.trim());
      tagController.clear();
    });
  }

  void _resetForm() {
    setState(() {
      categoryController.clear();
      specificSkillController.clear();
      tagController.clear();
      tags.clear();
      minExpController.clear();
      certification = null;
      toolsController.clear();
      descriptionController.clear();
      amountController.clear();
      rateType = "Hourly";
      locationController.clear();
      startDateController.clear();
      endDateController.clear();
    });
  }

  void _postJob() {
    final data = {
      "category": categoryController.text,
      "specificSkill": specificSkillController.text,
      "tags": tags.toList(),
      "experience": minExpController.text,
      "certification": certification,
      "tools": toolsController.text,
      "description": descriptionController.text,
      "startDate": startDateController.text,
      "endDate": endDateController.text,
      "amount": amountController.text,
      "rateType": rateType,
      "location": locationController.text,
    };

    debugPrint(data.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Job Posted")),
    );
  }
}
