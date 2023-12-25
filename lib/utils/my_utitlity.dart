import 'package:aakriti_inteligence/screens/home_screen.dart';
import 'package:aakriti_inteligence/utils/colors.dart';
import 'package:aakriti_inteligence/utils/constant.dart';
import 'package:aakriti_inteligence/widgets/custom_btn.dart';
import 'package:aakriti_inteligence/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utility {
  static void showCustomSnackbar(
      BuildContext context, String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomTextWidget(
          text: message,
          color: AppColors.kwhiteColor,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  static void showCustomDialogBox({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomTextWidget(text: title),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Divider(),
                CustomTextWidget(
                  text: message,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.sp),
              ],
            ),
          ),
          actions: <Widget>[
            CustomElevatedButton(
              child: const CustomTextWidget(
                text: "Ok",
                color: AppColors.kwhiteColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  ///Show Error dialog box
  static void showErrorDialogBox({
    required BuildContext context,
    String? title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                text: title ?? "Error",
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.cancel_outlined,
                  color: AppColors.kblackColor,
                  size: iconSized,
                ),
              ),
            ],
          ),
          titlePadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 0,
          ),
          children: [
            const Divider(),
            Icon(
              Icons.error_outline,
              color: AppColors.kaccentColor,
              size: MediaQuery.of(context).size.height / 18,
            ),
            SizedBox(
              height: 10.h,
            ),
            Center(
              child: CustomTextWidget(
                text: message,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        );
      },
    );
  }

  ///Show success dialog box
  static showSucessDialogBox({
    required BuildContext context,
    String? title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                text: title ?? "Error",
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.cancel_outlined,
                  color: AppColors.kblackColor,
                  size: iconSized,
                ),
              ),
            ],
          ),
          titlePadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 0,
          ),
          children: [
            const Divider(),
            Icon(
              Icons.check_circle,
              color: AppColors.kbuttonColor,
              size: MediaQuery.of(context).size.height / 18,
            ),
            SizedBox(
              height: 10.h,
            ),
            Center(
              child: CustomTextWidget(
                text: message,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        );
      },
    );
  }

  static Future<bool> saveLogin(String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("login", data);
    return true;
  }

  static Future<String> getLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("login") ?? "";
    // debugPrint('getLoginData: $data');
    return data;
  }

  static Future<bool> saveAdminStatus(bool data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isAdmin", data);
    return true;
  }

  static Future<bool> getAdminStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getBool("isAdmin") ?? false;
    // debugPrint('getLoginData: $data');
    return data;
  }

  // static saveUserData(String userData) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("userData", userData);
  // }

  // static Future<String> getUserData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var userData = prefs.getString("userData") ?? "";
  //   debugPrint('GetUserData: $userData');
  //   return userData;
  // }

//--Get--User--Data-----
  static clearPreferenceData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

//--Get--User--Data-----
  // Future<LoginDataModel?> getUserProfileData() async {
  //   String? res = await getUserData();
  //   if (res != "null" && res != "") {
  //     var data = loginDataModelFromJson(res.toString());
  //     debugPrint("user email = ${data.user!.email}");
  //     debugPrint("user phone = ${data.user!.phone}");
  //     return data;
  //   } else {
  //     return null;
  //   }
  // }

//-----Logout---From--App-----
  static void logoutFromApp(BuildContext context) async {
    await clearPreferenceData();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false);
    }
  }
}
