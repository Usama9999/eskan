import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../design_util.dart';

class DisabledButton extends StatelessWidget {
  String buttonText;
  String? iconText;
  VoidCallback? onPressed;

  DisabledButton({required this.buttonText, this.iconText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(12)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
              side: BorderSide(color: backgroundColor),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          maxLines: 1,
          style: TextStyle(
            color: disabledFontColor,
            fontWeight: FontWeight.w700,
            fontSize: UiUtils.getDeviceBasedFont(13),
          ),
        ),
      ),
    );
  }
}
