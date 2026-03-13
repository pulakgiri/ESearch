import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:esearch/features/profile/basic_info_page.dart';
import 'package:esearch/features/profile/skills_page.dart';
import 'package:esearch/core/constants/colors.dart';
import 'package:esearch/core/utils/loading.dart';
import 'package:esearch/core/constants/urls.dart';
import 'package:http/http.dart' as http;
import 'package:esearch/core/utils/global_user.dart' as globaluser;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toastification/toastification.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class Editprofile extends StatefulWidget {
  Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile>
    with SingleTickerProviderStateMixin {
  File? imageFile;

  String user_image = "";
  TextEditingController email = TextEditingController();
  TextEditingController mobileno = TextEditingController();
  TextEditingController fullname = TextEditingController();

  @override
  void initState() {
    super.initState();
    email.text = globaluser.user.email.toString();
    fullname.text = globaluser.user.fullname.toString();
    mobileno.text = globaluser.user.mobileno.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> cropImage(String filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );

    if (croppedImage != null) {
      final bytes = await File(croppedImage.path).readAsBytes();
      setState(() {
        imageFile = File(croppedImage.path);
      });
      await saveImageToDatabase(imageFile);
    }
  }

  Future<void> saveImageToDatabase(File? imageFile) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LoadingDialog();
      },
    );
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${mainurl}image_upload.php"),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageFile!.readAsBytesSync(),
          filename: imageFile.path.split("/").last,
        ),
      );

      request.fields['userid'] = globaluser.user.userid!.toString();

      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);

      Navigator.pop(context);
      if (jsondata['status'] == true) {
        user_image = jsondata['imgtitle'].toString();
        globaluser.user.image = user_image;
      } else {
        toastification.show(
          context: context,
          title: Text('Picture Not Get'),
          autoCloseDuration: Duration(seconds: 2),
          style: ToastificationStyle.flatColored,
          applyBlurEffect: true,
          icon: Icon(
            Ionicons.close_circle,
            color: Colors.red,
          ),
          type: ToastificationType.error,
          pauseOnHover: true,
        );
      }
      setState(() {});
    } catch (e) {
      Navigator.pop(context);
      toastification.show(
        context: context,
        title: Text(e.toString()),
        autoCloseDuration: Duration(seconds: 3),
        style: ToastificationStyle.flatColored,
        applyBlurEffect: true,
        icon: Icon(
          Ionicons.close_circle,
          color: Colors.red,
        ),
        type: ToastificationType.error,
        pauseOnHover: true,
      );
    }
  }

  Future selectImage(ImageSource source) async {
    try {
      PermissionStatus status;
      if (Platform.isAndroid) {
        AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;
        if (source == ImageSource.camera) {
          status = await Permission.camera.request();
        } else {
          if (deviceInfo.version.sdkInt >= 30) {
            status = await Permission.accessMediaLocation.request();
          } else {
            status = await Permission.storage.request();
          }
        }

        if (status.isGranted) {
          final pickedFile = await ImagePicker().pickImage(source: source);

          if (pickedFile != null) {
            await cropImage(pickedFile.path);
          } else {
            if (!mounted) return;
            toastification.show(
              context: context,
              title: Text("No image selected."),
              autoCloseDuration: Duration(seconds: 2),
              style: ToastificationStyle.flatColored,
              applyBlurEffect: true,
              icon: Icon(
                Ionicons.close_circle,
                color: Colors.red,
              ),
              type: ToastificationType.error,
              pauseOnHover: true,
            );
          }
        } else if (status.isDenied) {
          if (!mounted) return;
          toastification.show(
            context: context,
            title: Text('Permission Denied'),
            autoCloseDuration: Duration(seconds: 2),
            style: ToastificationStyle.flatColored,
            icon: Icon(Ionicons.close_circle, color: Colors.red),
            type: ToastificationType.error,
            pauseOnHover: true,
          );
        } else if (status.isPermanentlyDenied) {
          if (!mounted) return;
          toastification.show(
            context: context,
            title: Text(
              'Permission Permanently Denied. Go to Settings to Enable.',
            ),
            autoCloseDuration: Duration(seconds: 3),
            style: ToastificationStyle.flatColored,
            icon: Icon(Ionicons.close_circle, color: Colors.red),
            type: ToastificationType.error,
            pauseOnHover: true,
          );
          await openAppSettings();
        }
      }
    } catch (e) {
      if (!mounted) return;
      toastification.show(
        context: context,
        title: Text('Error: $e'),
        autoCloseDuration: Duration(seconds: 3),
        style: ToastificationStyle.flatColored,
        icon: Icon(Ionicons.close_circle, color: Colors.red),
        type: ToastificationType.error,
        pauseOnHover: true,
      );
    }
  }

  void showImageDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        height: 250,
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.blue),
              title: Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                selectImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.image, color: Colors.greenAccent),
              title: Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                selectImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.redAccent),
              title: Text('Delete'),
              onTap: () {
                Navigator.of(context).pop();
                deleteImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteImage() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LoadingDialog();
      },
    );
    try {
      var response = await http.post(
        Uri.parse("${mainurl}delete_image.php"),
        body: {
          'user_id': globaluser.user.userid!.toString(),
        },
      );
      var jsondata = jsonDecode(response.body);
      Navigator.pop(context);
      if (jsondata['status'] == true) {
        globaluser.user.image = "no_image.png";
        setState(() {});
        toastification.show(
          title: Text('Image Deleted Successfully'),
          autoCloseDuration: Duration(seconds: 2),
          style: ToastificationStyle.flatColored,
          icon: Icon(
            Ionicons.checkmark_circle,
            color: Colors.green,
          ),
          type: ToastificationType.success,
        );
      } else {
        toastification.show(
          context: context,
          title: Text('Failed to Delete Image'),
          autoCloseDuration: Duration(seconds: 2),
          style: ToastificationStyle.flatColored,
          icon: Icon(
            Ionicons.close_circle,
            color: Colors.red,
          ),
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      Navigator.pop(context);
      toastification.show(
        context: context,
        title: Text(e.toString()),
        autoCloseDuration: Duration(seconds: 3),
        style: ToastificationStyle.flatColored,
        icon: Icon(
          Ionicons.close_circle,
          color: Colors.red,
        ),
        type: ToastificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: maincolor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                      profile_image_url + globaluser.user.image.toString(),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Color.fromARGB(184, 0, 0, 0),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.camera_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: showImageDialog,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.green.shade50, // Card background
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.green,
                ),
              ),
              title: const Text(
                "Edit Basic Information",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.green,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BasicInfoPage(),
                  ),
                );
              },
            ),
          ),

          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.blue.shade50,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: Colors.blue,
                ),
              ),
              title: const Text(
                "Edit Skills & Qualification",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.blueGrey,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SkillInfoPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
