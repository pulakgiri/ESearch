import 'dart:convert';

import 'package:esearch/models/user.dart';
import 'package:esearch/models/userskill.dart';
import 'package:esearch/pages/home.dart';
import 'package:esearch/pages/login.dart';
import 'package:esearch/util/color.dart';
import 'package:esearch/util/url.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esearch/util/globaluser.dart' as globaluser;
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SharedPreferences sp;

  Map<String, dynamic> error = {'error': 'No User'};
  Map<String, dynamic> user = {};

  // ---------------- SPLASH NAVIGATION ----------------
  Future<void> navigate() async {
    sp = await SharedPreferences.getInstance();

    String storedUser = sp.getString("user") ?? jsonEncode(error);
    user = jsonDecode(storedUser);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    if (user['email'] == null || user['email'] == '') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Login()),
      );
    } else {
      await getUserData(user['userid']);
      await getUserskillData(user['userid']);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Home()),
      );
    }
  }

  // ---------------- GET USER DATA ----------------
  Future<void> getUserData(String userid) async {
    try {
      var response = await http.post(
        Uri.parse("${mainurl}getdata.php"),
        body: {'userid': userid},
      );

      var jsondata = jsonDecode(response.body);

      if (jsondata['status'] == true) {
        sp.setString("user", jsonEncode(jsondata['data']));
        globaluser.user = User.fromJson(
          jsondata['data'] as Map<String, dynamic>,
        );
      }
    } catch (e) {
      if (!mounted) return;
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // ---------------- GET USER SKILL DATA ----------------
  Future<void> getUserskillData(String userid) async {
    try {
      var response = await http.post(
        Uri.parse("${mainurl}getuserskilldata.php"),
        body: {'userid': userid},
      );

      var jsondata = jsonDecode(response.body);

      if (jsondata['status'] == true) {
        sp.setString("userSkill", jsonEncode(jsondata['data']));
        globaluser.userSkill = UserSkill.fromJson(
          jsondata['data'] as Map<String, dynamic>,
        );
      }
    } catch (e) {
      if (!mounted) return;
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // ---------------- INIT ----------------
  @override
  void initState() {
    super.initState();
    navigate();
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/esearchlogo.png",
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 10),
                Text(
                  "Search your job instantly",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: maincolor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Developer: Pulak Giri',
                  style: TextStyle(fontSize: 10),
                ),
                Text(
                  'Version: 1.0.0',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
