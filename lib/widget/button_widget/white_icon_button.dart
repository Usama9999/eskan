import 'package:flutter/material.dart';

import '../design_util.dart';

class WhiteIconButton extends StatelessWidget {
  String buttonText;
  String iconText;
  VoidCallback? onPressed;

  WhiteIconButton(
      {required this.buttonText,
      required this.iconText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
              side: BorderSide(color: Colors.black),
            ),
          ),
        ),
        onPressed: onPressed,
        icon: Padding(
          padding: UiUtils.getDeviceBasedPadding(0, 0, 6, 0),
          child: UiUtils.getIcon(iconText),
        ),
        label: Text(
          buttonText,
          maxLines: 1,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: UiUtils.getDeviceBasedFont(14),
          ),
        ),
      ),
    );
  }
}
