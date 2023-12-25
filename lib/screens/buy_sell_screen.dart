import 'dart:io';
import 'package:aakriti_inteligence/models/buy_model.dart';
import 'package:aakriti_inteligence/models/login_data_model.dart';
import 'package:aakriti_inteligence/utils/api_service.dart';
import 'package:aakriti_inteligence/utils/app_string.dart';
import 'package:aakriti_inteligence/utils/colors.dart';
import 'package:aakriti_inteligence/utils/constant.dart';
import 'package:aakriti_inteligence/utils/my_utitlity.dart';
import 'package:aakriti_inteligence/widgets/custom_btn.dart';
import 'package:aakriti_inteligence/widgets/custom_text.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class BuySellScreen extends StatefulWidget {
  const BuySellScreen({
    super.key,
    required this.isBuy,
    required this.productId,
  });
  final bool isBuy;
  final int productId;

  @override
  State<BuySellScreen> createState() => _BuySellScreenState();
}

class _BuySellScreenState extends State<BuySellScreen> {
  bool pageLoading = true;
  bool isBtnClicked = false;
  Utility utility = Utility();
  LoginDataModel? profileData;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String customMessage =
      "Your Request has been accepted our team will connect to you soon within 24 hours.";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

//     getProfileData() async {
//     var emailData = await Utility.getLogin();
//     debugPrint("getEmailData ===> $emailData ");
//     if (emailData != "") {
//       userProfile(email: emailData);
//     } else {
//       setState(() {
//         pageLoading = false;
//       });
//     }
//   }

//   //-----User-Profile-----------------
//   userProfile({
//     required String email,
//   }) async {
//     var data = {
//       "email": email.trim(),
//     };
//     try {
//       final response = await ApiService.postApi(
//         endpoint: AppStrings.profileUpdateApi,
//         body: data,
//         context: context,
//       );
//       debugPrint('Get User Profile: ${response.statusCode} ${response.body}');
//       if (response.statusCode == 200) {
//         var res = userProfileModleFromJson(response.body.toString());
//         if (res.status == 200) {
//           if (context.mounted) {
//             setState(() {
//               firstNameController.text = res.user.fname ?? "";
//               lastNameController.text = res.user.lname ?? "";
//               emailController.text = res.user.email ?? "";
//               phoneNoController.text = res.user.phone ?? "";
//             });
//             await Utility.saveLogin(res.user.email ?? "");
//           }
//         }
//       } else {
//         debugPrint("Error = ${response.statusCode} message = ${response.body}");
//       }
//     } catch (e) {
//       debugPrint('Exception Caught: $e');
//     } finally {
//       setState(() {
//         pageLoading = false;
//       });
//     }
//   }
// //-

//-------Login-With-Password-----------------

  buySellData({
    required bool isBuy,
    required String product,
    required String firstname,
    required String lastname,
    required String email,
    required String subject,
    required String message,
  }) async {
    setLoading(true);
    var data = {
      "product": product,
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "subject": subject,
      "message": message,
    };
    try {
      final response = await ApiService.postApi(
        endpoint: isBuy ? AppStrings.buyRequestApi : AppStrings.sellRequestApi,
        body: data,
        context: context,
      );
      debugPrint('buysell Res: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        if (isBuy == true) {
          //---Buy----
          var res = buyModleFromJson(response.body.toString());
          if (res.status == 200) {
            clearForm();
            if (context.mounted) {
              Utility.showCustomSnackbar(
                  context, res.message ?? "Success", true);
              Utility.showSucessDialogBox(
                  context: context, title: "Success", message: customMessage);
            }
          } else {
            if (context.mounted) {
              Utility.showCustomSnackbar(context, res.message ?? "Fail", false);
            }
          }
        } else {
          //---Sell----
          var res = buyModleFromJson(response.body.toString());
          if (res.status == 200) {
            clearForm();
            if (context.mounted) {
              Utility.showCustomSnackbar(
                  context, res.message ?? "Success", true);
              Utility.showSucessDialogBox(
                  context: context, title: "Success", message: customMessage);
            }
          } else {
            if (context.mounted) {
              Utility.showCustomSnackbar(context, res.message ?? "Fail", false);
            }
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

  clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneNoController.clear();
    subjectController.clear();
    messageController.clear();
  }

  @override
  void initState() {
    // getUserDaata();
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
            SizedBox(
              height: topHeaderHeight,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 10, 5),
              child: Row(
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
                  CustomTextWidget(
                    text: widget.isBuy == true ? "Buy Screen" : "Sell Screen",
                    color: AppColors.kwhiteColor,
                    fontSize: 24,
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
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
                                  duration: const Duration(milliseconds: 1000),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
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
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors
                                                          .grey.shade200))),
                                          child: TextFormField(
                                            controller: firstNameController,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter first name';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                                hintText: "Enter first name",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        //lastname
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors
                                                          .grey.shade200))),
                                          child: TextFormField(
                                            controller: lastNameController,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter last name';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                                hintText: "Enter last name",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        //email
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors
                                                          .grey.shade200))),
                                          child: TextFormField(
                                            controller: emailController,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            keyboardType:
                                                TextInputType.emailAddress,
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
                                            decoration: const InputDecoration(
                                                hintText: "Enter email",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        //phone-number
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors
                                                          .grey.shade200))),
                                          child: TextFormField(
                                            controller: phoneNoController,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            keyboardType: TextInputType.phone,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter phone number';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                                hintText: "Enter phone number",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        //email
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors
                                                          .grey.shade200))),
                                          child: TextFormField(
                                            controller: subjectController,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter subject';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                                hintText: "Enter subject",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        //phone-number
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors
                                                          .grey.shade200))),
                                          child: TextFormField(
                                            maxLines: 5,
                                            controller: messageController,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter message';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                                hintText: "Enter message.....",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
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
                                  duration: const Duration(milliseconds: 1000),
                                  child: SizedBox(
                                    height: 50,
                                    child: CustomElevatedButton(
                                      backgroundColor: widget.isBuy
                                          ? AppColors.kbuttonColor
                                          : AppColors.kaccentColor,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          buySellData(
                                            isBuy: widget.isBuy,
                                            product:
                                                widget.productId.toString(),
                                            firstname: firstNameController.text,
                                            lastname: lastNameController.text,
                                            email: emailController.text,
                                            subject: subjectController.text,
                                            message: messageController.text,
                                          );
                                        }
                                      },
                                      child: Center(
                                        child: loading
                                            ? const CircularProgressIndicator()
                                            : CustomTextWidget(
                                                text: widget.isBuy == true
                                                    ? "proceed to buy"
                                                        .toUpperCase()
                                                    : "proceed to sell"
                                                        .toUpperCase(),
                                                color: AppColors.kwhiteColor,
                                                fontWeight: FontWeight.bold,
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
