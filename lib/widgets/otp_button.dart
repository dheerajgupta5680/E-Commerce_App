// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'package:aakriti_inteligence/utils/colors.dart';
import 'package:flutter/material.dart';

class OTPButton extends StatefulWidget {
  final int timeOutInSeconds = 30;

  const OTPButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.color = Colors.white,
  });

  final VoidCallback onPressed;
  final Color color;
  final Widget title;

  @override
  State<OTPButton> createState() => _OTPButtonState();
}

class _OTPButtonState extends State<OTPButton> {
  bool timeUpFlag = true;
  // Timer? _timer;

  int timeCounter = 0;
  String get _timerText => '$timeCounter s';

  @override
  void initState() {
    super.initState();
    timeCounter = widget.timeOutInSeconds;
  }

  _timerUpdate() {
    // _timer =
    Timer(const Duration(seconds: 1), () async {
      if (mounted) {
        setState(() {
          timeCounter--;
        });
      }
      if (timeCounter != 0)
        _timerUpdate();
      else
        timeUpFlag = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: timeUpFlag ? Colors.green : Colors.red,
        foregroundColor: AppColors.kwhiteColor,
      ),
      onPressed: _onPressed,
      child: timeUpFlag
          ? widget.title
          : Text(
              "wait ${_timerText.toString()}",
              style: const TextStyle(
                color: AppColors.kwhiteColor,
              ),
            ),
    );
  }

  _onPressed() {
    if (timeUpFlag) {
      if (mounted) {
        setState(() {
          timeUpFlag = false;
        });
      }
      timeCounter = widget.timeOutInSeconds;

      widget.onPressed();
      _timerUpdate();
    }
  }
}
