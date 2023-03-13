import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../design_util.dart';

class SigninButton extends StatelessWidget {
  String? buttonText;
  String? imageName;
  IconData? buttonIcon;
  VoidCallback? onPressed;

  SigninButton(
      {this.buttonText = 'Sign in',
      this.buttonIcon,
      this.imageName,
      this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 20),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
          foregroundColor: MaterialStateProperty.all<Color>(AppColors.primary1),
          backgroundColor: MaterialStateProperty.all<Color>(AppColors.primary1),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(1)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(color: AppColors.primary1, width: 2),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: UiUtils.getDeviceBasedPadding(15, 13, 20, 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText?.toUpperCase() ?? '',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: UiUtils.getDeviceBasedFont(15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
