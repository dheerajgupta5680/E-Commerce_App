import 'package:aakriti_inteligence/models/products_model.dart';
import 'package:aakriti_inteligence/models/user_profile_model.dart';
import 'package:aakriti_inteligence/screens/drawer_screen.dart';
import 'package:aakriti_inteligence/screens/buy_sell_screen.dart';
import 'package:aakriti_inteligence/screens/my_line_chart.dart';
import 'package:aakriti_inteligence/utils/api_service.dart';
import 'package:aakriti_inteligence/utils/app_string.dart';
import 'package:aakriti_inteligence/utils/colors.dart';
import 'package:aakriti_inteligence/utils/my_utitlity.dart';
import 'package:aakriti_inteligence/utils/constant.dart';
import 'package:aakriti_inteligence/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:aakriti_inteligence/widgets/custom_btn.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  Utility utility = Utility();
  List<ProductData> mobileItems = [];
  List<ProductData> totalItem = [];
  bool pageLoading = true;
  String username = AppStrings.appName;
  String userEmail = "";
  bool loginStatus = false;

  setLoading(bool value) {
    setState(() {
      pageLoading = value;
    });
  }

  //---getProfile---
  checkLogin() async {
    var emailData = await Utility.getLogin();
    debugPrint("getProfileData ===> $emailData ");
    if (emailData != "") {
      await userProfile(email: emailData);
      setState(() {
        loginStatus = true;
      });
    } else {
      username = AppStrings.appName;
      setState(() {
        loginStatus = false;
      });
    }
    productsData();
  }

  productsData() async {
    setLoading(true);
    try {
      final response = await ApiService.getApi(
        endpoint: AppStrings.productsApi,
        context: context,
      );
      // debugPrint('productsData Res: ${response.statusCode} ${response.body}');
      mobileItems = [];
      totalItem = [];
      if (response.statusCode == 200) {
        final productListModel =
            productListModelFromJson(response.body.toString());
        mobileItems = productListModel.data ?? [];
        totalItem.addAll(mobileItems);
      } else {
        debugPrint("Error = ${response.statusCode} message = ${response.body}");
      }
    } catch (e) {
      debugPrint('Exception Caught: $e');
    } finally {
      setLoading(false);
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
              var firstName = res.user.fname;
              var lastName = res.user.lname;
              username = "$firstName $lastName";
              userEmail = res.user.email ?? '';
            });
            await Utility.saveLogin(res.user.email ?? "");
            await Utility.saveAdminStatus(res.user.isAdmin ?? false);
          }
        } else {
          setState(() {
            username = AppStrings.appName;
            userEmail = "";
          });
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

  void filterSearchResults(String query) {
    List<ProductData> searchResults = [];
    if (query.isNotEmpty) {
      for (var item in mobileItems) {
        if (item.name.toString().toLowerCase().contains(query.toLowerCase())) {
          searchResults.add(item);
        }
      }
    } else {
      searchResults.addAll(totalItem);
    }
    setState(() {
      mobileItems.clear();
      mobileItems.addAll(searchResults);
    });
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: CustomNavigationDrawer(
        isLogin: loginStatus,
        fullName: username,
        userEmail: userEmail,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: globalPadding),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 12.sp),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomTextWidget(
                              text: "Hello, welcome",
                              color: Colors.black38,
                            ),
                            CustomTextWidget(
                              text: username.toString(),
                              color: Colors.black,
                              textAlign: TextAlign.center,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage(
                            'images/logo.png',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 45.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 45.h,
                              child: TextFormField(
                                onChanged: (value) {
                                  filterSearchResults(value);
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: 'Search items...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide:
                                        const BorderSide(color: Colors.black54),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 40.sp,
                            width: 40.sp,
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              color: AppColors.kbuttonColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () {
                                _key.currentState!.openDrawer();
                              },
                              child: Icon(
                                Icons.menu,
                                size: globalIconSize,
                                color: AppColors.kwhiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: pageLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 50),
                        itemCount: mobileItems.length,
                        itemBuilder: (context, index) {
                          final ProductData mobileItem = mobileItems[index];
                          return Container(
                            height: 0.18.sh,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 0),
                                )
                              ],
                            ),
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.sp, vertical: 8.sp),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 100.sp,
                                    width: 100.sp,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          "${AppStrings.baseUrl}${mobileItem.img}",
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomTextWidget(
                                          text: mobileItem.name ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 18,
                                        ),
                                        SizedBox(
                                          height: 2.sp,
                                        ),
                                        Row(
                                          children: [
                                            CustomTextWidget(
                                              text:
                                                  "Rs ${mobileItem.sp ?? "0"} /",
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            CustomTextWidget(
                                              text: " ${mobileItem.mrp ?? "0"}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 16,
                                              decorationStyle:
                                                  TextDecorationStyle.wavy,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2.sp,
                                        ),
                                        SizedBox(
                                          height: 0.05.sh,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomElevatedButton(
                                                backgroundColor:
                                                    AppColors.kaccentColor,
                                                child: const CustomTextWidget(
                                                  text: "Sell",
                                                  color: AppColors.kwhiteColor,
                                                ),
                                                onPressed: () {
                                                  if (context.mounted) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            BuySellScreen(
                                                          isBuy: false,
                                                          productId:
                                                              mobileItem.id ??
                                                                  0,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                width: 2.sp,
                                              ),
                                              CustomElevatedButton(
                                                backgroundColor:
                                                    AppColors.kbuttonColor,
                                                child: const CustomTextWidget(
                                                  text: "Buy",
                                                  color: AppColors.kwhiteColor,
                                                ),
                                                onPressed: () {
                                                  if (context.mounted) {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            BuySellScreen(
                                                          isBuy: true,
                                                          productId:
                                                              mobileItem.id ??
                                                                  0,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.kprimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyLineChart(
                                                          productId:
                                                              mobileItem.id ??
                                                                  0,
                                                          currentPrice:
                                                              mobileItem.sp
                                                                  .toString(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.auto_graph_rounded,
                                                    color:
                                                        AppColors.kwhiteColor,
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
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
