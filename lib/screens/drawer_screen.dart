import 'package:aakriti_inteligence/screens/about_us.dart';
import 'package:aakriti_inteligence/screens/edit_profile.dart';
import 'package:aakriti_inteligence/screens/home_screen.dart';
import 'package:aakriti_inteligence/screens/login_screen.dart';
import 'package:aakriti_inteligence/screens/privacy_policy.dart';
import 'package:aakriti_inteligence/screens/term_condition.dart';
import 'package:aakriti_inteligence/utils/app_string.dart';
import 'package:aakriti_inteligence/utils/colors.dart';
import 'package:aakriti_inteligence/utils/my_utitlity.dart';
import 'package:aakriti_inteligence/widgets/custom_btn.dart';
import 'package:aakriti_inteligence/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomNavigationDrawer extends StatefulWidget {
  const CustomNavigationDrawer({
    super.key,
    required this.isLogin,
    required this.fullName,
    required this.userEmail,
  });
  final bool isLogin;
  final String fullName;
  final String userEmail;

  @override
  CustomNavigationDrawerState createState() => CustomNavigationDrawerState();
}

class CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  String userName = AppStrings.appName;
  String userEmail = "Welcom Back";

  getDefaultData() {
    if (widget.isLogin == true) {
      userName = widget.fullName;
      userEmail = widget.userEmail;
    } else {
      userName = AppStrings.appName;
      userEmail = "Welcom Back";
    }
    setState(() {});
  }

  Widget customTile({
    required String text,
    required IconData leadingIcon,
    required Function()? onTap,
  }) {
    return ListTileTheme(
      contentPadding: const EdgeInsets.symmetric(vertical: 0),
      child: ListTile(
        // contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        leading: Icon(leadingIcon),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }

  @override
  void initState() {
    getDefaultData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Drawer(
      child: SizedBox(
        height: deviceHeight,
        width: deviceWidth / 1.5,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.06,
                    ),
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('images/logo.png'),
                    ),
                    const SizedBox(height: 10),
                    CustomTextWidget(
                      text: userName,
                      fontSize: 18,
                    ),
                    CustomTextWidget(
                      text: userEmail,
                      fontSize: 14,
                    ),
                    SizedBox(
                      height: deviceHeight * 0.02,
                    ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: EdgeInsets.only(
                  left: deviceWidth / 20,
                  right: deviceWidth / 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customTile(
                      text: "Home",
                      onTap: () {
                        Navigator.pop(context);
                      },
                      leadingIcon: Icons.home,
                    ),
                    const Divider(),
                    customTile(
                      text: "Term & Conditions",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermAndCondion(),
                          ),
                        );
                      },
                      leadingIcon: Icons.dvr_sharp,
                    ),
                    const Divider(),
                    customTile(
                      text: "Privacy & Policy",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyAndPolicy(),
                          ),
                        );
                      },
                      leadingIcon: Icons.privacy_tip,
                    ),
                    if (widget.isLogin) ...[
                      const Divider(),
                      customTile(
                        text: "Setting & Profile",
                        onTap: () async {
                          var res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
                            ),
                          );
                          if (res == true) {
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                                (Route<dynamic> route) => false,
                              );
                            }
                          }
                        },
                        leadingIcon: Icons.settings,
                      ),
                    ],
                    const Divider(),
                    customTile(
                      text: "About Us",
                      leadingIcon: Icons.info_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutUsScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    customTile(
                      text: "Contact Support",
                      leadingIcon: Icons.phone_in_talk_outlined,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        backgroundColor: AppColors.kbuttonColor,
                        child: CustomTextWidget(
                          text: widget.isLogin ? 'Sign Out' : 'Sign In',
                          color: AppColors.kwhiteColor,
                        ),
                        onPressed: () async {
                          if (widget.isLogin) {
                            setState(() {
                              Utility.logoutFromApp(context);
                            });
                          } else {
                            if (context.mounted) {
                              var response = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginScreen(),
                                ),
                              );
                              if (response == true) {
                                if (context.mounted) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              }
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    child: CustomTextWidget(
                      text: "Version 1.0.0",
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.02,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
