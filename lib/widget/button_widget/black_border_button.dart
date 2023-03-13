import 'package:flutter/material.dart';

import '../design_util.dart';

class BlackBorderButton extends StatelessWidget {
  String buttonText;
  VoidCallback? onPressed;
  double? fontSize;

  BlackBorderButton(
      {required this.buttonText, this.onPressed, this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            side: BorderSide(color: Colors.black, width: 1.5),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        maxLines: 1,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: UiUtils.getDeviceBasedFont(fontSize!),
        ),
      ),
    );
  }
}
