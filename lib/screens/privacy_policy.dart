import 'package:aakriti_inteligence/utils/api_service.dart';
import 'package:aakriti_inteligence/utils/app_string.dart';
import 'package:aakriti_inteligence/utils/my_utitlity.dart';
import 'package:aakriti_inteligence/utils/constant.dart';
import 'package:aakriti_inteligence/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../models/privacy_policy_model.dart';

class PrivacyAndPolicy extends StatefulWidget {
  const PrivacyAndPolicy({super.key});

  @override
  State<PrivacyAndPolicy> createState() => _PrivacyAndPolicyState();
}

class _PrivacyAndPolicyState extends State<PrivacyAndPolicy> {
  Utility utility = Utility();
  bool loading = true;
  String? htmlData;
  String noDataFound = '''<center><p>No data found </p></center>''';

  setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  privacyPolicyData() async {
    setLoading(true);
    try {
      final response = await ApiService.getApi(
        endpoint: AppStrings.privacyPolicyApi,
        context: context,
      );
      debugPrint(
          'privacyPolicyData Res: ${response.statusCode} ${response.body}');
      htmlData = null;
      if (response.statusCode == 200) {
        final res = privacyPolicyModelFromJson(response.body.toString());
        if (res.status == 200) {
          if (context.mounted) {
            htmlData = res.data!.description;
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

  @override
  void initState() {
    privacyPolicyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomTextWidget(
          text: "Privacy & Policy",
          fontSize: headerFontSize,
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : htmlData == null
              ? const Center(
                  child: CustomTextWidget(
                    text: "No Data Found",
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: globalPadding, vertical: 2),
                    child: HtmlWidget(
                      htmlData ?? noDataFound,
                      renderMode: RenderMode.column,
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
    );
  }
}
