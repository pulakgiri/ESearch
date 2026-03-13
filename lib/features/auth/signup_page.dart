import 'dart:convert';

import 'package:async/async.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:esearch/models/user.dart';
import 'package:esearch/features/home/home_page.dart';
import 'package:esearch/features/auth/login_page.dart';
import 'package:esearch/core/constants/colors.dart';
import 'package:esearch/core/utils/loading.dart';
import 'package:esearch/core/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:esearch/core/utils/global_user.dart' as globaluser;
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool passvisibility = true;
  bool confirmpassvisibility = true;
  TextEditingController email = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController mono = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  // CancelableOperation? operation;

  GlobalKey<FormState> formkey = GlobalKey();
  // void startoperation(
  //   String email,
  //   String password,
  //   String fullname,
  //   String mobileno,
  // ) {
  //   operation = CancelableOperation.fromFuture(
  //     getSignupStatus(email, password, fullname, mobileno),
  //     onCancel: () {
  //       print("\nSign Canceled.\n");
  //     },
  //   );
  // }

  late SharedPreferences sp;

  Future getSignupStatus(
    String email,
    String password,
    String fullname,
    String mobileno,
    String dob,
  ) async {
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'mobile_no': mobileno,
      'fullname': fullname,
      'dob': dob,
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
        Uri.parse("${mainurl}user_signup.php"),
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
          title: "Signup Successfull",
          desc: "Welcome, ${fname.text}!\n your account has been Created.",
          dismissOnTouchOutside: false,
          btnOkOnPress: () {
            this.email.text = "";
            this.fname.text = "";
            this.mono.text = "";
            this.password.text = "";
            this.confirmpassword.text = "";
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (contex) => Login()),
            );
          },
        ).show();
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: "╰(*°▽°*)╯",
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Material(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/esearchlogo.png",
                      height: 100,
                      width: 100,
                    ),
                    Text(
                      "Create Account",
                      style: TextStyle(
                        color: maincolor,
                        fontWeight: FontWeight.w900,
                        fontSize: 30,
                      ),
                    ),
                    AutoSizeText(
                      "create an account so you can explore "
                      "all the existing jobs",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxFontSize: 25,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: TextFormField(
                        controller: email,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Enter Valid Email';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(256, 214, 236, 192),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: TextFormField(
                        controller: fname,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Full name",
                          prefixIcon: Icon(Icons.people),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(256, 214, 236, 192),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Date of Birth is required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Date of Birth",
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(256, 214, 236, 192),
                            ),
                          ),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2500),
                          );

                          if (pickedDate != null) {
                            DateTime today = DateTime.now();
                            DateTime selected = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                            );
                            DateTime current = DateTime(
                              today.year,
                              today.month,
                              today.day,
                            );

                            if (selected == current) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Date of Birth cannot be today's date.",
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              setState(() {
                                _dateController.text =
                                    "${pickedDate.day.toString().padLeft(2, '0')}-"
                                    "${pickedDate.month.toString().padLeft(2, '0')}-"
                                    "${pickedDate.year}";
                              });
                            }
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: mono,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          } else {
                            if (!RegExp(
                              r'^(?:[+0]91)?[0-9]{10}$',
                            ).hasMatch(value)) {
                              return 'Enter valid mobile number.';
                            } else {
                              return null;
                            }
                          }
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mobile_friendly),
                          hintText: "Mobile No",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(256, 214, 236, 192),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: password,
                        obscureText: passvisibility,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          } else if (value.toString() != confirmpassword.text) {
                            return "Don't matched.";
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.done,

                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key),
                          suffixIcon: IconButton(
                            icon: passvisibility
                                ? Icon(
                                    Icons.visibility_off,
                                  )
                                : Icon(
                                    Icons.visibility,
                                  ),
                            onPressed: () {
                              setState(() {
                                passvisibility = !passvisibility;
                              });
                            },
                          ),
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: confirmpassword,
                        obscureText: confirmpassvisibility,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is required';
                          } else if (value.toString() != password.text) {
                            return "Don't matched.";
                          } else {
                            return null;
                          }
                        },
                        textInputAction: TextInputAction.done,

                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key),
                          suffixIcon: IconButton(
                            icon: confirmpassvisibility
                                ? Icon(
                                    Icons.visibility_off,
                                  )
                                : Icon(
                                    Icons.visibility,
                                  ),
                            onPressed: () {
                              setState(() {
                                confirmpassvisibility = !confirmpassvisibility;
                              });
                            },
                          ),
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: maincolor,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            getSignupStatus(
                              email.text,
                              password.text,
                              fname.text,
                              mono.text,
                              _dateController.text,
                            );
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: Text(
                        "Already have an account.",
                        style: TextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 20, 0, 239),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
