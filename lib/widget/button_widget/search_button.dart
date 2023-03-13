import 'package:flutter/material.dart';

import '../design_util.dart';

class SearchButton extends StatelessWidget {
  String buttonText;
  VoidCallback? onPressed;

  SearchButton({required this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20)),
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
            fontWeight: FontWeight.w400,
            fontSize: UiUtils.getDeviceBasedFont(14),
          ),
        ),
      ),
    );
  }
}
