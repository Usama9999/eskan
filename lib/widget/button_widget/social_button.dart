import 'package:eskan/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../design_util.dart';

class SocialButton extends StatelessWidget {
  String? buttonText;
  String? imageName;
  IconData? buttonIcon;
  VoidCallback? onPressed;

  SocialButton(
      {this.buttonText, this.buttonIcon, this.imageName, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 20),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(1)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: AppColors.primary1, width: 2),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: UiUtils.getDeviceBasedPadding(25, 15, 20, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText!.toUpperCase(),
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: UiUtils.getDeviceBasedFont(17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
