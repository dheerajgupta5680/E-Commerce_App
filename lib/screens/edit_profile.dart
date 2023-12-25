import 'dart:io';
import 'package:aakriti_inteligence/models/login_data_model.dart';
import 'package:aakriti_inteligence/models/update_profile_model.dart';
import 'package:aakriti_inteligence/models/user_profile_model.dart';
import 'package:aakriti_inteligence/utils/api_service.dart';
import 'package:aakriti_inteligence/utils/app_string.dart';
import 'package:aakriti_inteligence/utils/colors.dart';
import 'package:aakriti_inteligence/utils/my_utitlity.dart';
import 'package:aakriti_inteligence/widgets/custom_btn.dart';
import 'package:aakriti_inteligence/widgets/custom_text.dart';
import 'package:aakriti_inteligence/widgets/header_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool pageLoading = true;
  bool isBtnClicked = false;
  Utility utility = Utility();
  LoginDataModel? profileData;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();

  setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  //-----Edit-Profile-----------------
  editProfile({
    required String fname,
    required String lname,
    required String phoneNo,
    required String email,
  }) async {
    setLoading(true);
    var data = {
      "fname": fname.trim(),
      "lname": lname.trim(),
      "phone": phoneNo.trim(),
      "email": email.trim(),
    };
    try {
      final response = await ApiService.postApi(
        endpoint: AppStrings.profileUpdateApi,
        body: data,
        context: context,
      );
      debugPrint('Edit Profile Res: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var res = updateProfileModleFromJson(response.body.toString());
        if (res.status == 200) {
          if (context.mounted) {
            Utility.showCustomSnackbar(context, res.message ?? "Success", true);
            if (context.mounted) {
              Navigator.pop(context, true);
            }
          }
        } else {
          if (context.mounted) {
            Utility.showCustomSnackbar(context, res.message ?? "Fail", false);
          }
        }
      } else {
        debugPrint("Error = ${response.statusCode} message = ${response.body}");
      }
    } catch (e) {
      debugPrint('Exception Caught: $e');
    } finally {
      setLoading(false);
    }
  }
//-

  getProfileData() async {
    var emailData = await Utility.getLogin();
    debugPrint("getEmailData ===> $emailData ");
    if (emailData != "") {
      userProfile(email: emailData);
    } else {
      setState(() {
        pageLoading = false;
      });
    }
  }

  //-----User-Profile-----------------
  userProfile({
    required String email,
  }) async {
    setLoading(true);
    var data = {
      "email": email.trim(),
    };
    try {
      final response = await ApiService.postApi(
        endpoint: AppStrings.getuserProfile,
        body: data,
        context: context,
      );
      debugPrint('Get User Profile: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var res = userProfileModleFromJson(response.body.toString());
        if (res.status == 200) {
          if (context.mounted) {
            setState(() {
              firstNameController.text = res.user.fname ?? "";
              lastNameController.text = res.user.lname ?? "";
              emailController.text = res.user.email ?? "";
              phoneNoController.text = res.user.phone ?? "";
            });
          }
        }
      } else {
        debugPrint("Error = ${response.statusCode} message = ${response.body}");
      }
    } catch (e) {
      debugPrint('Exception Caught: $e');
    } finally {
      setState(() {
        pageLoading = false;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          const Color(0xFF2ecc71),
          const Color(0xFF2ecc71).withOpacity(0.8),
          const Color(0xFF2ecc71).withOpacity(0.4),
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
            const HeaderWidget(
              headerText: "Edit Profile Screen",
              headerDiscription: "Update your profile",
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: pageLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      FadeInUp(
                                        duration:
                                            const Duration(milliseconds: 1000),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Color.fromRGBO(
                                                        225, 95, 27, .3),
                                                    blurRadius: 20,
                                                    offset: Offset(0, 10))
                                              ]),
                                          child: Column(
                                            children: <Widget>[
                                              //firstname
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey
                                                                .shade200))),
                                                child: TextFormField(
                                                  controller:
                                                      firstNameController,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter first name';
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              "Enter first name",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                          border:
                                                              InputBorder.none),
                                                ),
                                              ),
                                              //lastname
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey
                                                                .shade200))),
                                                child: TextFormField(
                                                  controller:
                                                      lastNameController,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter last name';
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              "Enter last name",
                                                          hintStyle:
                                                              TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                          border:
                                                              InputBorder.none),
                                                ),
                                              ),
                                              //email
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey
                                                                .shade200))),
                                                child: TextFormField(
                                                  controller: emailController,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  readOnly: true,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter email';
                                                    } else if (!RegExp(
                                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                        .hasMatch(value)) {
                                                      return 'Invalid email';
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              "Enter email",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                          border:
                                                              InputBorder.none),
                                                ),
                                              ),
                                              //phone-number
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey
                                                                .shade200))),
                                                child: TextFormField(
                                                  controller: phoneNoController,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter phone number';
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              "Enter phone number",
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                          border:
                                                              InputBorder.none),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      FadeInUp(
                                        duration:
                                            const Duration(milliseconds: 1000),
                                        child: SizedBox(
                                          height: 50,
                                          child: CustomElevatedButton(
                                            backgroundColor:
                                                AppColors.kbuttonColor,
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                editProfile(
                                                  fname:
                                                      firstNameController.text,
                                                  lname:
                                                      lastNameController.text,
                                                  email: emailController.text,
                                                  phoneNo:
                                                      phoneNoController.text,
                                                );
                                              }
                                            },
                                            child: Center(
                                              child: loading
                                                  ? const CircularProgressIndicator()
                                                  : CustomTextWidget(
                                                      text: "Update"
                                                          .toUpperCase(),
                                                      color:
                                                          AppColors.kwhiteColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
