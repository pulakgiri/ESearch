import 'dart:convert';
import 'package:async/async.dart';
import 'package:esearch/models/user.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:esearch/pages/forgotpassword.dart';
import 'package:esearch/pages/home.dart';
import 'package:esearch/pages/signup.dart';
import 'package:esearch/util/color.dart';
import 'package:esearch/util/loading.dart';
import 'package:esearch/util/url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:esearch/util/globaluser.dart' as globaluser;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passvisibility = true;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey();
  CancelableOperation? operation;
  late SharedPreferences sp;

  void startOperation(String email, String password) {
    operation = CancelableOperation.fromFuture(
      getLoginStatus(email, password),
      onCancel: () {
        print("Login Canceled.");
      },
    );
  }

  Future getLoginStatus(String email, String password) async {
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };
    showDialog(
      context: context,
      builder: (context) => LoadingDialog(),
      barrierDismissible: false,
    );
    try {
      var response = await http.post(
        Uri.parse("${mainurl}esearch_login.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata['status']) {
        sp = await SharedPreferences.getInstance();
        sp.setString("user", jsonEncode(jsondata['data']));
        globaluser.user = User.fromJson(
          jsondata['data'] as Map<String, dynamic>,
        );

        if (!mounted) return;
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (contex) => Home()),
        );
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        Fluttertoast.showToast(msg: jsondata['msg']);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Material(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/esearchlogo.png",
                        height: 100,
                        width: 100,
                      ),
                      Text(
                        "Login here",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          color: maincolor,
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      AutoSizeText(
                        "Welcome back you've\n been missed!",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        maxFontSize: 25,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: username,
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
                            prefixIcon: Icon(Icons.people),
                            hintText: "Username/Email",
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
                            } else {
                              return null;
                            }
                          },
                          textInputAction: TextInputAction.done,
                          obscuringCharacter: "*",
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
                        padding: EdgeInsetsGeometry.all(10),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Forgotpassword(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot your Password? ",
                              style: TextStyle(
                                fontSize: 15,
                                color: const Color.fromARGB(255, 20, 0, 239),
                              ),
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
                            FocusScope.of(context).unfocus();
                            if (formkey.currentState!.validate()) {
                              startOperation(username.text, password.text);
                            } else {
                              print("Failed");
                            }
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
                              builder: (context) => const Signup(),
                            ),
                          );
                        },
                        child: Text(
                          "Create new account?",
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
      ),
    );
  }
}