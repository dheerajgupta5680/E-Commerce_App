import 'dart:io';

import 'package:aakriti_inteligence/models/generate_otp_model.dart';
import 'package:aakriti_inteligence/models/login_data_model.dart';
import 'package:aakriti_inteligence/screens/forget_password_screen.dart';
import 'package:aakriti_inteligence/utils/api_service.dart';
import 'package:aakriti_inteligence/utils/app_string.dart';
import 'package:aakriti_inteligence/utils/colors.dart';
import 'package:aakriti_inteligence/utils/constant.dart';
import 'package:aakriti_inteligence/utils/my_utitlity.dart';
import 'package:aakriti_inteligence/widgets/custom_text.dart';
import 'package:aakriti_inteligence/widgets/header_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController getVerificationController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  bool otpField = false;
  bool loading = false;
  bool isUserLogin = false;
  bool pageLoading = true;
  bool sBtnClicked = false;
  int durationTime = 1000;

  setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

//-------Login-With-Password-----------------
  loginWithPassword({
    required String email,
    required String password,
  }) async {
    setLoading(true);
    var data = {
      "email": email.trim(),
      "password": password.trim(),
    };
    try {
      final response = await ApiService.postApi(
        endpoint: AppStrings.loginWithPasswordApi,
        body: data,
        context: context,
      );
      debugPrint(
          'LoginWithPassword Res: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var res = loginDataModelFromJson(response.body.toString());
        if (res.status == 200) {
          // await Utility.saveUserData(response.body.toString());
          debugPrint("res.user!.isAdmin  = ${res.user!.isAdmin}");
          await Utility.saveLogin(res.user!.email ?? "");
          await Utility.saveAdminStatus(res.user!.isAdmin ?? false)
              .then((value) => resetData());
          if (context.mounted) {
            Utility.showCustomSnackbar(context, res.message ?? "Success", true);
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

//-------Login-With-Otp-----------------
  gererateOtp(String email) async {
    setLoading(true);
    var data = {"email": email.trim()};
    try {
      final response = await ApiService.postApi(
        endpoint: AppStrings.generateOtpApi,
        body: data,
        context: context,
      );
      debugPrint('GererateOtp Res: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var res = restaurantsModelFromJson(response.body.toString());
        if (res.status == 200) {
          if (context.mounted) {
            Utility.showCustomSnackbar(context, res.message ?? "Success", true);
          }
          setState(() {
            otpField = true;
          });
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

  loginWithOtp({
    required String email,
    required String otp,
  }) async {
    setLoading(true);
    var data = {
      "email": email.trim(),
      "otp": otp.trim(),
    };
    try {
      final response = await ApiService.postApi(
        endpoint: AppStrings.loginWithOptApi,
        body: data,
        context: context,
      );
      debugPrint('GererateOtp Res: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var res = loginDataModelFromJson(response.body.toString());
        if (res.status == 200) {
          debugPrint("res.user!.isAdmin  = ${res.user!.isAdmin}");
          await Utility.saveLogin(res.user!.email ?? "");
          await Utility.saveAdminStatus(res.user!.isAdmin ?? false)
              .then((value) => resetData());
          // await Utility.saveUserData(response.body.toString());
          if (context.mounted) {
            Utility.showCustomSnackbar(context, res.message ?? "Success", true);
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

  getBackScreen(bool value) {
    Navigator.pop(context, value);
  }

  resetData() {
    getVerificationController.clear();
    otpController.clear();
    otpField = false;
    getBackScreen(true);
  }

  getInitilaData() async {
    try {
      var data = await Utility.getLogin();
      if (data != "" && data != "null") {
        setState(() {
          pageLoading = false;
          isUserLogin = true;
        });
      } else {
        setState(() {
          pageLoading = false;
          isUserLogin = false;
        });
      }
      debugPrint("is user login = $isUserLogin");
    } catch (e) {
      debugPrint('Exception Caught: $e');
    }
  }

  clearform(int index) {
    if (index == 0) {
      getVerificationController.clear();
      otpController.clear();
      otpField = false;
    } else {
      emailController.clear();
      passwordController.clear();
      otpField = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getInitilaData();
    _tabController = TabController(length: 2, vsync: this);
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
        child: pageLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: topHeaderHeight,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Platform.isIOS
                                ? Icons.arrow_back_ios
                                : Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                  ),
                  const HeaderWidget(
                    headerText: "Login Screen",
                    headerDiscription: "Login to continue",
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 5,
                            ),
                            TabBar(
                              controller: _tabController,
                              indicatorColor: Colors.green,
                              labelColor: Colors.green,
                              onTap: (index) {
                                clearform(index);
                              },
                              labelPadding: EdgeInsets.only(
                                bottom: customNomalPadding,
                              ),
                              tabs: const [
                                CustomTextWidget(
                                  text: "Login With Password",
                                  fontSize: 13,
                                ),
                                CustomTextWidget(
                                  text: "Login With OTP",
                                  fontSize: 13,
                                ),
                              ],
                            ),
                            Expanded(
                              child: SizedBox(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    // Login With Password Tab
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: SingleChildScrollView(
                                        child: Form(
                                          key: _formKey1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              FadeInUp(
                                                duration: Duration(
                                                    milliseconds: durationTime),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color:
                                                                Color.fromRGBO(
                                                                    225,
                                                                    95,
                                                                    27,
                                                                    .3),
                                                            blurRadius: 20,
                                                            offset:
                                                                Offset(0, 10))
                                                      ]),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200))),
                                                        child: TextFormField(
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please enter email';
                                                            } else if (!RegExp(
                                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                                .hasMatch(
                                                                    value)) {
                                                              return 'Invalid email';
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              emailController,
                                                          decoration: const InputDecoration(
                                                              hintText:
                                                                  "Enter Email id",
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200))),
                                                        child: TextFormField(
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please enter password';
                                                            }
                                                            return null;
                                                          },
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          controller:
                                                              passwordController,
                                                          obscureText: true,
                                                          decoration: const InputDecoration(
                                                              hintText:
                                                                  "Enter Password",
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              FadeInUp(
                                                duration: Duration(
                                                    milliseconds: durationTime),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const SizedBox(),
                                                    InkWell(
                                                      onTap: () {
                                                        clearform(1);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child:
                                                            const CustomTextWidget(
                                                          text: "Cancel",
                                                          color: AppColors
                                                              .kaccentColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              FadeInUp(
                                                duration: Duration(
                                                    milliseconds: durationTime),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        clearform(_tabController
                                                                    .index ==
                                                                0
                                                            ? 1
                                                            : 0);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const ForgetPasswordScreen(),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: const Text(
                                                            "Forget Password"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              FadeInUp(
                                                duration: Duration(
                                                    milliseconds: durationTime),
                                                child: SizedBox(
                                                  height: 50,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      if (_formKey1
                                                          .currentState!
                                                          .validate()) {
                                                        if (!loading) {
                                                          loginWithPassword(
                                                            email:
                                                                emailController
                                                                    .text,
                                                            password:
                                                                passwordController
                                                                    .text,
                                                          );
                                                        }
                                                      }
                                                    },
                                                    child: Center(
                                                      child: loading
                                                          ? const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )
                                                          : const CustomTextWidget(
                                                              text: "Login",
                                                              color: AppColors
                                                                  .kwhiteColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Login With OTP Tab
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Form(
                                        key: _formKey,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              FadeInUp(
                                                duration: Duration(
                                                    milliseconds: durationTime),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color:
                                                                Color.fromRGBO(
                                                                    225,
                                                                    95,
                                                                    27,
                                                                    .3),
                                                            blurRadius: 20,
                                                            offset:
                                                                Offset(0, 10))
                                                      ]),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200))),
                                                        child: TextFormField(
                                                          controller:
                                                              getVerificationController,
                                                          readOnly: otpField,
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please enter email';
                                                            } else if (!RegExp(
                                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                                .hasMatch(
                                                                    value)) {
                                                              return 'Invalid email';
                                                            }
                                                            return null;
                                                          },
                                                          decoration: const InputDecoration(
                                                              hintText:
                                                                  "Get Verification Code On Email",
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                        ),
                                                      ),
                                                      //----otp-button-----
                                                      otpField
                                                          ? Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade200))),
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    otpController,
                                                                autovalidateMode:
                                                                    AutovalidateMode
                                                                        .onUserInteraction,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                validator:
                                                                    (value) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    return 'Please enter otp';
                                                                  }
                                                                  return null;
                                                                },
                                                                decoration:
                                                                    const InputDecoration(
                                                                  hintText:
                                                                      "Enter Otp",
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              FadeInUp(
                                                duration: Duration(
                                                    milliseconds: durationTime),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const SizedBox(),
                                                    InkWell(
                                                      onTap: () {
                                                        clearform(0);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child:
                                                            const CustomTextWidget(
                                                          text: "Cancel",
                                                          color: AppColors
                                                              .kaccentColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              FadeInUp(
                                                duration: Duration(
                                                    milliseconds: durationTime),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        clearform(_tabController
                                                                    .index ==
                                                                0
                                                            ? 1
                                                            : 0);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const ForgetPasswordScreen(),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: const Text(
                                                            "Forget Password"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              FadeInUp(
                                                duration: const Duration(
                                                    milliseconds: 1600),
                                                child: SizedBox(
                                                  height: 50,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      if (otpField == true) {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          loginWithOtp(
                                                            email:
                                                                getVerificationController
                                                                    .text,
                                                            otp: otpController
                                                                .text,
                                                          );
                                                        }
                                                      } else {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          if (!loading) {
                                                            gererateOtp(
                                                                getVerificationController
                                                                    .text);
                                                          }
                                                        }
                                                      }
                                                    },
                                                    child: Center(
                                                      child: loading
                                                          ? const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            )
                                                          : Text(
                                                              otpField
                                                                  ? "Login"
                                                                  : "Get Verification Code",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
