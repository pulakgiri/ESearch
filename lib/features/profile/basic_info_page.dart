import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:esearch/core/constants/colors.dart';
import 'package:esearch/core/utils/loading.dart';
import 'package:esearch/core/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:esearch/core/utils/global_user.dart' as globaluser;
import 'package:http/http.dart' as http;

class BasicInfoPage extends StatefulWidget {
  const BasicInfoPage({super.key});

  @override
  State<BasicInfoPage> createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  bool isBasicEdit = true;

  final TextEditingController email = TextEditingController();
  final TextEditingController mobileno = TextEditingController();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController userid = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey();

  Future editBasicState(
    String userid,
    String email,
    String fullname,
    String dob,
    String mobileno,
  ) async {
    Map<String, dynamic> data = {
      'userid': userid,
      'email': email,
      'fullname': fullname,
      'dob': dob,
      'mobile_no': mobileno,
    };
    // log(data.toString());
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
        Uri.parse("${mainurl}user_basic.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata['status']) {
        if (!mounted) return;

        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: "Update Successfull",
          dismissOnTouchOutside: false,
          btnOkOnPress: () {},
        ).show();
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          // title: "╰(*°▽°*)╯",
          desc: jsondata['msg'],
          dismissOnTouchOutside: false,
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      if (!mounted) return;

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: "Network Error",
        desc: "Something went wrong.\nPlease try again later.",
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  void initState() {
    super.initState();
    userid.text = globaluser.user.userid.toString();
    email.text = globaluser.user.email.toString();
    mobileno.text = globaluser.user.mobileno.toString();
    fullname.text = globaluser.user.fullname.toString();
    dob.text = globaluser.user.dob.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: maincolor,
        foregroundColor: Colors.white,
        title: Text(
          "Basic Info",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: email,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                    labelText: "Email",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      // borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: mobileno,
                  readOnly: isBasicEdit,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.blue,
                    ),
                    labelText: "Mobile No",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      // borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: fullname,
                  readOnly: isBasicEdit,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    labelText: "Full Name",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      // borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: dob,
                  readOnly: isBasicEdit,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.blue,
                    ),
                    labelText: "Date of Birth",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      // borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  onTap: isBasicEdit
                      ? null
                      : () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2500),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              dob.text =
                                  "${pickedDate.day.toString().padLeft(2, '0')}-"
                                  "${pickedDate.month.toString().padLeft(2, '0')}-"
                                  "${pickedDate.year}";
                            });
                          }
                        },
                ),

                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBasicEdit ? maincolor : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      if (!isBasicEdit) {
                        if (formkey.currentState!.validate()) {
                          editBasicState(
                            userid.text,
                            email.text,
                            fullname.text,
                            dob.text,
                            mobileno.text,
                          );
                        }
                      }
                      FocusScope.of(context).unfocus();
                      setState(() => isBasicEdit = !isBasicEdit);
                    },
                    child: AutoSizeText(
                      isBasicEdit ? "Edit" : "Save",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
