// import 'package:flutter/material.dart';

// // --- 🎨 CUSTOM THEME COLORS ---
// const Color maincolor = Color.fromARGB(255, 0, 118, 235); // Blue
// const Color subcolor = Color.fromARGB(255, 161, 232, 7); // Lime Green

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Edit Profile',
//       theme: ThemeData(
//         primaryColor: maincolor,
//         colorScheme: ColorScheme.fromSwatch(
//           primarySwatch: Colors.blue,
//         ).copyWith(primary: maincolor, secondary: subcolor),
//         inputDecorationTheme: InputDecorationTheme(
//           border: const UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.grey, width: 1.5),
//           ),
//           enabledBorder: const UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.grey, width: 1.5),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: maincolor, width: 2.0),
//           ),
//           labelStyle: const TextStyle(color: Colors.grey),
//           contentPadding: const EdgeInsets.symmetric(
//             vertical: 12.0,
//             horizontal: 0,
//           ),
//         ),
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         useMaterial3: true,
//       ),
//       home: const Editprofile(),
//     );
//   }
// }

// // --- 📝 CUSTOM TEXT FIELD WIDGET (Modular Component) ---
// class CustomUnderlineTextField extends StatelessWidget {
//   final String label;
//   final TextEditingController controller;
//   final bool isRequired;
//   final TextInputType keyboardType;
//   final int maxLines;
//   final String? hintText;
//   final Widget? suffixIcon;
//   final String? Function(String?)? validator;

//   const CustomUnderlineTextField({
//     super.key,
//     required this.label,
//     required this.controller,
//     this.isRequired = false,
//     this.keyboardType = TextInputType.text,
//     this.maxLines = 1,
//     this.hintText,
//     this.suffixIcon,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           labelText: label + (isRequired ? ' *' : ''),
//           hintText: hintText,
//           suffixIcon: suffixIcon,
//         ),
//         validator:
//             validator ??
//             (value) {
//               if (isRequired && (value == null || value.isEmpty)) {
//                 return 'This field is required.';
//               }
//               if (keyboardType == TextInputType.emailAddress &&
//                   value != null &&
//                   !value.contains('@')) {
//                 return 'Please enter a valid email.';
//               }
//               return null;
//             },
//       ),
//     );
//   }
// }

// // --- 🖼 EDIT PROFILE SCREEN ---

// class Editprofile extends StatefulWidget {
//   const Editprofile({super.key});

//   @override
//   State<Editprofile> createState() => _EditprofileState();
// }

// class _EditprofileState extends State<Editprofile> {
//   final _formKey = GlobalKey<FormState>();

//   // --- Controllers: ALL START BLANK ---
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _otherRoleController = TextEditingController();
//   final TextEditingController _fieldOfStudyController = TextEditingController();
//   final TextEditingController _universityController = TextEditingController();
//   final TextEditingController _graduationYearController =
//       TextEditingController();
//   final TextEditingController _additionalQualsController =
//       TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _localAreaController = TextEditingController();
//   final TextEditingController _zipCodeController = TextEditingController();
//   final TextEditingController _fullAddressController = TextEditingController();
//   final TextEditingController _skillTagController = TextEditingController();

//   // --- State Variables: Initialized to null or zero/empty sets ---
//   String? _selectedPositionLevel;
//   String? _selectedHighestDegree;
//   String? _selectedCountry;
//   int _experienceYears = 0;
//   bool _showOtherRole = false;

//   Set<String> selectedJobRoles = {};
//   Set<String> _skills = {};

//   // --- Data Lists ---
//   final List<String> jobRoles = [
//     'Software Engineer',
//     'Data Analyst',
//     'Project Manager',
//     'Marketing Specialist',
//     'HR Executive',
//     'Other',
//   ];
//   final List<String> positionLevels = [
//     'Entry Level / Junior',
//     'Mid Level',
//     'Senior Level',
//     'Executive / Director',
//   ];
//   final List<String> highestDegrees = [
//     'High School Diploma',
//     'Associate Degree',
//     "Bachelor's Degree",
//     "Master's Degree",
//     'PhD / Doctorate',
//   ];
//   final List<String> countries = ['USA', 'India', 'UK', 'Canada'];

//   // --- 💡 Mock API Data (To show data after user 'submits' once) ---
//   Map<String, dynamic> _profileData = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadProfileData();
//   }

//   void _loadProfileData() {
//     // This function remains for persistence after submit, but starts blank initially
//     if (_profileData.isNotEmpty) {
//       _nameController.text = _profileData['name'] ?? '';
//       _emailController.text = _profileData['email'] ?? '';
//       _phoneController.text = _profileData['phone'] ?? '';
//       _fieldOfStudyController.text = _profileData['fieldOfStudy'] ?? '';
//       _universityController.text = _profileData['university'] ?? '';
//       _graduationYearController.text = _profileData['graduationYear'] ?? '';
//       _additionalQualsController.text = _profileData['additionalQuals'] ?? '';
//       _stateController.text = _profileData['state'] ?? '';
//       _cityController.text = _profileData['city'] ?? '';
//       _localAreaController.text = _profileData['localArea'] ?? '';
//       _zipCodeController.text = _profileData['zipCode'] ?? '';
//       _fullAddressController.text = _profileData['fullAddress'] ?? '';
//       _otherRoleController.text = _profileData['otherRole'] ?? '';

//       setState(() {
//         _selectedPositionLevel = _profileData['positionLevel'];
//         _selectedHighestDegree = _profileData['highestDegree'];
//         _selectedCountry = _profileData['country'];
//         _experienceYears = _profileData['experienceYears'] ?? 0;
//         selectedJobRoles = Set<String>.from(_profileData['jobRoles'] ?? []);
//         _skills = Set<String>.from(_profileData['skills'] ?? []);
//         _showOtherRole = selectedJobRoles.contains('Other');
//       });
//     }
//   }

//   void _saveProfileData() {
//     // This simulates saving data to a backend or state
//     _profileData = {
//       'name': _nameController.text,
//       'email': _emailController.text,
//       'phone': _phoneController.text,
//       'fieldOfStudy': _fieldOfStudyController.text,
//       'university': _universityController.text,
//       'graduationYear': _graduationYearController.text,
//       'additionalQuals': _additionalQualsController.text,
//       'state': _stateController.text,
//       'city': _cityController.text,
//       'localArea': _localAreaController.text,
//       'zipCode': _zipCodeController.text,
//       'fullAddress': _fullAddressController.text,
//       'otherRole': _otherRoleController.text,
//       'positionLevel': _selectedPositionLevel,
//       'highestDegree': _selectedHighestDegree,
//       'country': _selectedCountry,
//       'experienceYears': _experienceYears,
//       'jobRoles': selectedJobRoles.toList(),
//       'skills': _skills.toList(),
//     };
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _otherRoleController.dispose();
//     _fieldOfStudyController.dispose();
//     _universityController.dispose();
//     _graduationYearController.dispose();
//     _additionalQualsController.dispose();
//     _stateController.dispose();
//     _cityController.dispose();
//     _localAreaController.dispose();
//     _zipCodeController.dispose();
//     _fullAddressController.dispose();
//     _skillTagController.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       if (selectedJobRoles.isEmpty) {
//         _showSnackBar('Please select at least one job role.', Colors.red);
//         return;
//       }

//       _saveProfileData();
//       _showSnackBar('Profile updated successfully!', subcolor);
//       _loadProfileData();
//     } else {
//       _showSnackBar('Please correct the errors in the form.', Colors.red);
//     }
//   }

//   void _showSnackBar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   // --- BUILDING BLOCKS ---

//   Widget _buildSection(String title, List<Widget> children, {IconData? icon}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: Card(
//         elevation: 0,
//         color: Colors.grey.withOpacity(0.1),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//           side: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   if (icon != null)
//                     Padding(
//                       padding: const EdgeInsets.only(right: 8.0),
//                       child: Icon(icon, color: maincolor, size: 24),
//                     ),
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: maincolor,
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(
//                 height: 10,
//                 thickness: 1,
//                 color: Colors.grey.withOpacity(0.4),
//               ),
//               ...children,
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDropdown(
//     String label,
//     String? value,
//     List<String> items,
//     Function(String?) onChanged, [
//     bool required = false,
//   ]) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         decoration: InputDecoration(
//           labelText: label + (required ? ' *' : ''),
//           hintText: 'Select $label',
//         ),
//         items: items.map((String item) {
//           return DropdownMenuItem<String>(
//             value: item,
//             child: Text(item),
//           );
//         }).toList(),
//         onChanged: onChanged,
//         validator: required
//             ? (value) => value == null ? 'Selection required' : null
//             : null,
//       ),
//     );
//   }

//   Widget _buildJobRolesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 10),
//         const Text(
//           'Target Job Roles (Select one or more)*:',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
//         ),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 8.0,
//           runSpacing: 4.0,
//           children: jobRoles.map((role) {
//             final isSelected = selectedJobRoles.contains(role);
//             return FilterChip(
//               label: Text(role),
//               selected: isSelected,
//               onSelected: (bool selected) {
//                 setState(() {
//                   if (selected) {
//                     selectedJobRoles.add(role);
//                   } else {
//                     selectedJobRoles.remove(role);
//                   }
//                   if (role == 'Other') {
//                     _showOtherRole = selected;
//                     if (!selected) _otherRoleController.clear();
//                   }
//                 });
//               },
//               selectedColor: maincolor.withOpacity(0.15),
//               checkmarkColor: maincolor,
//               labelStyle: TextStyle(
//                 color: isSelected ? maincolor : Colors.black87,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//               ),
//             );
//           }).toList(),
//         ),
//         if (_showOtherRole)
//           Padding(
//             padding: const EdgeInsets.only(top: 10.0),
//             child: CustomUnderlineTextField(
//               label: 'Other Job Role (Specify)',
//               controller: _otherRoleController,
//               isRequired: true,
//               hintText: 'e.g., Blockchain Developer',
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildExperienceSlider() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Years of Total Experience: ${_experienceYears == 0
//                 ? 'Less than 1'
//                 : _experienceYears >= 20
//                 ? '20+'
//                 : _experienceYears} years',
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           Slider(
//             value: _experienceYears.toDouble(),
//             min: 0,
//             max: 20,
//             divisions: 20,
//             label: _experienceYears == 0
//                 ? '<1'
//                 : _experienceYears >= 20
//                 ? '20+'
//                 : _experienceYears.toString(),
//             onChanged: (double value) {
//               setState(() {
//                 _experienceYears = value.round();
//               });
//             },
//             activeColor: maincolor,
//             inactiveColor: maincolor.withOpacity(0.3),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSkillsTagInput() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 10),
//         const Text(
//           'Your Key Skills:',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
//         ),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 6.0,
//           runSpacing: 6.0,
//           children: _skills
//               .map(
//                 (skill) => Chip(
//                   label: Text(skill),
//                   onDeleted: () {
//                     setState(() {
//                       _skills.remove(skill);
//                     });
//                   },
//                   deleteIconColor: Colors.red,
//                   backgroundColor: Colors.grey.shade200,
//                   side: BorderSide(color: maincolor.withOpacity(0.5)),
//                 ),
//               )
//               .toList(),
//         ),
//         CustomUnderlineTextField(
//           label: 'Add New Skill',
//           controller: _skillTagController,
//           hintText: 'e.g., Python, SQL, Agile...',
//           isRequired: false,
//           suffixIcon: IconButton(
//             icon: Icon(Icons.add_circle, color: maincolor),
//             onPressed: () {
//               final skill = _skillTagController.text.trim();
//               if (skill.isNotEmpty) {
//                 setState(() {
//                   _skills.add(skill);
//                   _skillTagController.clear();
//                 });
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // --- NEW HELPER: For Text Fields with leading icons ---
//   Widget _buildIconTextField({
//     required String label,
//     required TextEditingController controller,
//     required IconData icon,
//     bool isRequired = false,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.baseline,
//       textBaseline: TextBaseline.alphabetic,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(right: 8.0),
//           child: Icon(icon, color: maincolor, size: 24),
//         ),
//         Expanded(
//           child: CustomUnderlineTextField(
//             label: label,
//             controller: controller,
//             isRequired: isRequired,
//             keyboardType: keyboardType,
//             suffixIcon: Icon(Icons.edit, color: Colors.grey.shade400, size: 20),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//       appBar: AppBar(
//         title: const Text(
//           "Edit Profile",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: subcolor,
//         foregroundColor: Colors.black,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.done_outlined, size: 28),
//             onPressed: _submitForm,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // --- Profile Picture Section ---
//               Center(
//                 child: Stack(
//                   children: [
//                     const CircleAvatar(
//                       radius: 70,
//                       backgroundImage: AssetImage("assets/images/user2.jpg"),
//                     ),
//                     Positioned(
//                       bottom: 20,
//                       right: 10,
//                       child: CircleAvatar(
//                         radius: 20,
//                         backgroundColor: const Color.fromARGB(184, 0, 0, 0),
//                         child: IconButton(
//                           padding: EdgeInsets.zero,
//                           icon: const Icon(
//                             Icons.camera_outlined,
//                             size: 40,
//                             color: Colors.white,
//                           ),
//                           onPressed: () {},
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // --- 1. Contact & Basic Information (WITH LEADING ICONS) ---
//               _buildSection('Contact & Basic Information', [
//                 // Icon on the left side of the input field
//                 _buildIconTextField(
//                   label: 'Full Name',
//                   controller: _nameController,
//                   isRequired: true,
//                   icon: Icons.person,
//                 ),

//                 _buildIconTextField(
//                   label: 'Email',
//                   controller: _emailController,
//                   isRequired: true,
//                   keyboardType: TextInputType.emailAddress,
//                   icon: Icons.email,
//                 ),

//                 _buildIconTextField(
//                   label: 'Mobile No*',
//                   controller: _phoneController,
//                   isRequired: true,
//                   keyboardType: TextInputType.phone,
//                   icon: Icons.phone,
//                 ),
//               ], icon: Icons.info_outline),
//               // ---

//               // --- 2. Job Role & Experience ---
//               _buildSection('Job Role & Experience', [
//                 _buildJobRolesSection(),
//                 _buildDropdown(
//                   'Position Level*',
//                   _selectedPositionLevel,
//                   positionLevels,
//                   (value) => setState(() => _selectedPositionLevel = value),
//                   true,
//                 ),
//                 _buildExperienceSlider(),
//               ], icon: Icons.work_outline),
//               // ---

//               // --- 3. Core Skills ---
//               _buildSection('Core Skills', [
//                 _buildSkillsTagInput(),
//               ], icon: Icons.star_border),
//               // ---

//               // --- 4. Education & Qualifications ---
//               _buildSection('Education & Qualifications', [
//                 _buildDropdown(
//                   'Highest Degree*',
//                   _selectedHighestDegree,
//                   highestDegrees,
//                   (value) => setState(() => _selectedHighestDegree = value),
//                   true,
//                 ),
//                 CustomUnderlineTextField(
//                   label: 'Field of Study / Major*',
//                   controller: _fieldOfStudyController,
//                   isRequired: true,
//                   suffixIcon: Icon(
//                     Icons.edit,
//                     color: Colors.grey.shade400,
//                     size: 20,
//                   ),
//                 ),
//                 CustomUnderlineTextField(
//                   label: 'University / Institution',
//                   controller: _universityController,
//                   suffixIcon: Icon(
//                     Icons.edit,
//                     color: Colors.grey.shade400,
//                     size: 20,
//                   ),
//                 ),
//                 CustomUnderlineTextField(
//                   label: 'Year of Graduation',
//                   controller: _graduationYearController,
//                   keyboardType: TextInputType.number,
//                   suffixIcon: Icon(
//                     Icons.edit,
//                     color: Colors.grey.shade400,
//                     size: 20,
//                   ),
//                 ),
//                 CustomUnderlineTextField(
//                   label: 'Additional Qualifications / Certifications',
//                   controller: _additionalQualsController,
//                   maxLines: 3,
//                   suffixIcon: Icon(
//                     Icons.edit,
//                     color: Colors.grey.shade400,
//                     size: 20,
//                   ),
//                 ),
//               ], icon: Icons.school_outlined),
//               // ---

//               // --- 5. Address & Location ---
//               _buildSection('Address & Location', [
//                 _buildDropdown(
//                   'Country*',
//                   _selectedCountry,
//                   countries,
//                   (value) => setState(() => _selectedCountry = value),
//                   true,
//                 ),
//                 CustomUnderlineTextField(
//                   label: 'State / Province',
//                   controller: _stateController,
//                   suffixIcon: Icon(
//                     Icons.edit,
//                     color: Colors.grey.shade400,
//                     size: 20,
//                   ),
//                 ),
//                 CustomUnderlineTextField(
//                   label: 'City (Primary urban area)*',
//                   controller: _cityController,
//                   isRequired: true,
//                   suffixIcon: Icon(
//                     Icons.edit,
//                     color: Colors.grey.shade400,
//                     size: 20,
//                   ),
//                 ),
//                 CustomUnderlineTextField(
//                   label: 'Local Area / Neighborhood',
//                   controller: _localAreaController,
//                   suffixIcon: Icon(
//                     Icons.edit,
//                     color: Colors.grey.shade400,
//                     size: 20,
//                   ),
//                 ),
//                 CustomUnderlineTextField(
//                   label: 'ZIP / Postal Code',
//                   controller: _zipCodeController,
//                   keyboardType: TextInputType.number,
//                   suffixIcon: Icon(
//                     Icons.edit,
//                     color: Colors.grey.shade400,
//                     size: 20,
//                   ),
//                 ),
//                 CustomUnderlineTextField(
//                   label: 'Full Address (Optional)',
//                   controller: _fullAddressController,
//                   maxLines: 2,
//                   suffixIcon: Icon(
//                     Icons.edit,
//                     color: Colors.grey.shade400,
//                     size: 20,
//                   ),
//                 ),
//               ], icon: Icons.location_on_outlined),

//               // ---
//               const SizedBox(height: 50),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// ////////////////////////////////////
// ///
// ///
// ///
// ///
// ///
// import 'package:flutter/material.dart';
// import 'package:esearch/util/globaluser.dart' as globaluser;
// import 'package:esearch/util/url.dart';
// import 'basic_info_page.dart';
// import 'skill_info_page.dart';

// class EditProfile extends StatelessWidget {
//   const EditProfile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Profile"),
//         backgroundColor: const Color.fromARGB(213, 34, 87, 130),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 20),

//           CircleAvatar(
//             radius: 70,
//             backgroundImage: NetworkImage(
//               profile_image_url + globaluser.user.image.toString(),
//             ),
//           ),

//           const SizedBox(height: 30),

          // Card(
          //   child: ListTile(
          //     leading: const Icon(Icons.info_outline),
          //     title: const Text("Edit Basic Information"),
          //     trailing: const Icon(Icons.arrow_forward_ios),
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (_) => const BasicInfoPage(),
          //         ),
          //       );
          //     },
          //   ),
          // ),

          // Card(
          //   child: ListTile(
          //     leading: const Icon(Icons.work_outline),
          //     title: const Text("Edit Skills & Qualification"),
          //     trailing: const Icon(Icons.arrow_forward_ios),
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (_) => const SkillInfoPage(),
          //         ),
          //       );
          //     },
          //   ),
          // ),
//         ],
//       ),
//     );
//   }
// }
