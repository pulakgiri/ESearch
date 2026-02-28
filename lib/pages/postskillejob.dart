import 'package:esearch/util/color.dart';
import 'package:flutter/material.dart';

class PostSkillejob extends StatefulWidget {
  const PostSkillejob({super.key});

  @override
  State<PostSkillejob> createState() => _PostSkillejobState();
}

class _PostSkillejobState extends State<PostSkillejob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          "Post Skilled Job",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "Reset",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= JOB CATEGORY =================
            _sectionTitle("Job Category"),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Skill Category"),
                  _dropdown("Select Trade"),

                  const SizedBox(height: 16),

                  _label("Specific Skill"),
                  _textField("e.g. Industrial Wiring"),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    children: [
                      _chip("Residential"),
                      _chip("Phase 3"),
                      _addChip(),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ================= EXPERIENCE =================
            _sectionTitle("Experience & Qualification"),
            _card(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _textField("Years", label: "Min Experience"),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dropdown("Licensed", label: "Certification"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _label("Tools Knowledge"),
                  _textField(
                    "e.g. Oscilloscope, Power Drills, Multi-meter...",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ================= WORK DETAILS =================
            _sectionTitle("Work Details & Pay"),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Work Description"),
                  _textArea("Explain the project scope..."),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _textField("Amount", label: "Charges (\$)"),
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

            /// ================= LOCATION =================
            _sectionTitle("Location & Contact"),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Site Location"),
                  _textField(
                    "Street Address, City",
                    prefixIcon: Icons.location_on,
                  ),
                  const SizedBox(height: 12),

                  /// Map Placeholder
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: const DecorationImage(
                        image: AssetImage("assets/map_placeholder.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.location_on,
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

      /// ================= POST BUTTON =================
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: maincolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: const Icon(Icons.send),
            label: const Text(
              "Post Skilled Job",
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  /// ================= HELPERS =================

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
    String? label,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) _label(label),
        TextField(
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

  Widget _textArea(String hint) {
    return TextField(
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

  Widget _dropdown(String hint, {String? label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) _label(label),
        DropdownButtonFormField<String>(
          items: const [],
          onChanged: (_) {},
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
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: () {},
      backgroundColor: Colors.blue.shade50,
      labelStyle: const TextStyle(color: Colors.blue),
    );
  }

  Widget _addChip() {
    return ActionChip(
      label: const Text("+ Add Tag"),
      onPressed: () {},
    );
  }

  Widget _rateType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Rate Type"),
        Row(
          children: [
            _rateChip("Hourly", true),
            const SizedBox(width: 8),
            _rateChip("Daily", false),
          ],
        ),
      ],
    );
  }

  Widget _rateChip(String text, bool selected) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.grey.shade100,
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
    );
  }
}
