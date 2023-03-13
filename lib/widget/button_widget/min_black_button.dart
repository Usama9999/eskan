import 'package:flutter/material.dart';

import '../design_util.dart';

class MinBlackButton extends StatelessWidget {
  String buttonText;
  VoidCallback? onPressed;

  MinBlackButton({required this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.only(left: 60, top: 12, bottom: 12, right: 60)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
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
            fontSize: UiUtils.getDeviceBasedFont(15),
          ),
        ),
      ),
    );
  }
}
