import 'package:eskan/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../design_util.dart';

class MainColorButton extends StatelessWidget {
  String buttonText;
  VoidCallback? onPressed;
  double? fontSize;

  MainColorButton(
      {required this.buttonText, this.onPressed, this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(AppColors.primary1),
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary1),
        padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: AppColors.primary1, width: 1.5),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        maxLines: 1,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: UiUtils.getDeviceBasedFont(fontSize!),
        ),
      ),
    );
  }
}
