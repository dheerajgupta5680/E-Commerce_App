import 'package:aakriti_inteligence/utils/constant.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.headerText,
    required this.headerDiscription,
    this.padding,
  });
  final String headerText;
  final String headerDiscription;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            headerText,
            style: const TextStyle(color: Colors.white, fontSize: globalHeaderTextSize),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            headerDiscription,
            style: const TextStyle(color: Colors.white, fontSize: globalHeaderDiscriptionSize),
          ),
        ],
      ),
    );
  }
}
