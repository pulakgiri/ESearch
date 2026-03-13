import 'package:auto_size_text/auto_size_text.dart';
import 'package:esearch/features/jobs/applied_jobs_page.dart';
import 'package:esearch/features/jobs/corporate/corporate_jobs_page.dart';
import 'package:esearch/features/jobs/domestic/domestic_services_page.dart';
import 'package:esearch/features/profile/edit_profile_page.dart';
import 'package:esearch/features/auth/login_page.dart';
import 'package:esearch/features/notifications/notifications_page.dart';
import 'package:esearch/features/jobs/post_job.dart';
import 'package:esearch/features/jobs/saved_jobs_page.dart';
import 'package:esearch/features/jobs/search_jobs_page.dart';
import 'package:esearch/core/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:esearch/core/utils/global_user.dart' as globaluser;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences sp;
  RxString user_image = "".obs;
  @override
  void initState() {
    user_image.value = globaluser.user.image.toString();
    super.initState();
  }

  void showJobTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Job Type",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 25),

                _jobTypeButton(context, "Corporate Job"),
                const SizedBox(height: 15),

                _jobTypeButton(context, "Domestic Services"),
                const SizedBox(height: 15),

                _jobTypeButton(context, "Skilled Labour"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _jobTypeButton(BuildContext context, String type) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 242, 240, 255),
          foregroundColor: Colors.deepPurple,
          padding: EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostJobPage(selectedType: type),
            ),
          );
        },
        child: Text(
          type,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user_image.value = globaluser.user.image.toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(213, 34, 87, 130),
        leading: Image.asset(
          "assets/images/esearchlogo.png",
          height: 60,
          width: 60,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyNotifications(),
                ),
              );
            },
            icon: Icon(
              Icons.notifications_outlined,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Are you sure you want to logout?",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 98, 244, 54),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                sp = await SharedPreferences.getInstance();
                                sp.clear();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Text(
                                "Logout",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.logout,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Obx(
                () => CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    profile_image_url + user_image.value,
                    scale: 0.5,
                  ),
                ),
              ),
              title: AutoSizeText(
                globaluser.user.fullname == null
                    ? "-"
                    : globaluser.user.fullname.toString(),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
              subtitle: AutoSizeText(
                "App Developer",
                style: TextStyle(
                  fontSize: 15,
                ),
                maxLines: 1,
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Editprofile(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 56, 129, 255),
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Edit Profile",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(3),
              child: AutoSizeText(
                "Job Categories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CorporateJobs(),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(90, 123, 188, 242),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.business,
                            color: Color.fromARGB(239, 44, 33, 243),
                            size: 50,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Corporate\nJobs",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 14, 13, 18),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DomesticServices(),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(150, 80, 182, 83),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.home,
                            color: Color.fromARGB(255, 7, 114, 10),
                            size: 50,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Domestic\nServices",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 48, 3),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(90, 123, 188, 242),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.handyman,
                          color: Color.fromARGB(239, 44, 33, 243),
                          size: 50,
                        ),
                        SizedBox(height: 8),

                        Text(
                          "Skilled\nLabour",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 30, 2, 61),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(6),
              child: AutoSizeText(
                "Quick Action",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3.2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(208, 176, 207, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    elevation: 3,
                  ),
                  onPressed: () => showJobTypeDialog(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 30,
                        color: const Color.fromARGB(255, 2, 116, 6),
                      ),
                      SizedBox(width: 8),
                      AutoSizeText(
                        "Post Job",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        maxFontSize: 18,
                        minFontSize: 15,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(208, 176, 207, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    elevation: 3,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchForJobs(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 30,
                        color: const Color.fromARGB(255, 8, 20, 194),
                      ),
                      SizedBox(width: 8),
                      AutoSizeText(
                        "Search Job",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        maxFontSize: 18,
                        minFontSize: 15,
                      ),
                    ],
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(208, 176, 207, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    elevation: 3,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppliedJob(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.business_center,
                        size: 30,
                        color: const Color.fromARGB(255, 8, 20, 194),
                      ),
                      SizedBox(width: 8),
                      AutoSizeText(
                        "Applied Job",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        maxFontSize: 18,
                        minFontSize: 12,
                      ),
                    ],
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(208, 176, 207, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    elevation: 3,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SavedJobs(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark,
                        size: 30,
                        color: const Color.fromARGB(255, 0, 255, 76),
                      ),
                      SizedBox(width: 8),
                      AutoSizeText(
                        "Saved Job",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        maxFontSize: 18,
                        minFontSize: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                "Quick Action",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: Icon(Icons.business_center),
                  title: Text('Software Engineer'),
                  subtitle: Text('ABC Inc.'),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    // style: ElevatedButton.styleFrom(
                    //   foregroundBuilder: Colors.cyanAccent,
                    // ),
                    child: Text('Apply Now'),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(6),
              child: Text(
                "Testimonials",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(
                  "assets/images/user2.jpg",
                ),
              ),
              title: Text(
                "Pulak Giri",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: AutoSizeText(
                "App Developer",
                style: TextStyle(
                  fontSize: 12,
                ),
                maxLines: 1,
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                child: Icon(
                  Icons.wechat_rounded,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: maincolor,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home, color: Color.fromARGB(255, 156, 205, 23)),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.done_all,
      //         color: Color.fromARGB(255, 154, 243, 21),
      //       ),
      //       label: 'Donations',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person, color: Color.fromARGB(255, 112, 191, 15)),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }
}
