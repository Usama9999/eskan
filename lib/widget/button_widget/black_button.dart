import 'package:flutter/material.dart';

import '../design_util.dart';

class BlackButton extends StatelessWidget {
  String buttonText;
  VoidCallback? onPressed;
  double fontSize;

  BlackButton({required this.buttonText, this.onPressed, this.fontSize = 17});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.black),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: UiUtils.getDeviceBasedFont(fontSize),
        ),
      ),
    );
  }
}
