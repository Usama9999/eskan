import 'package:flutter/material.dart';

import '../design_util.dart';

class BlackInputWidget extends StatelessWidget {
  Widget? suffixIcon;
  int? maxLines;
  String? hint;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  bool obscureText;
  TextStyle? style;
  InputDecoration? decoration;
  Color hintColor;

  BlackInputWidget(
      {this.suffixIcon,
      this.maxLines,
      this.hint,
      this.style,
      this.decoration,
      this.controller,
      this.hintColor = Colors.grey,
      this.obscureText = false,
      this.validator});

  @override
  Widget build(BuildContext context) {
    print("$hint: $obscureText");
    return Padding(
      padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 0),
      child: TextFormField(
        maxLines: 1,
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        style: style ??
            TextStyle(
                fontSize: UiUtils.getDeviceBasedFont(18),
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w600),
        decoration: decoration ??
            InputDecoration(
              filled: true,
              isDense: true,
              fillColor: Colors.white,
              suffixIcon: suffixIcon,
              suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              hintText: hint ?? "Enter Here",
              hintStyle: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: UiUtils.getDeviceBasedFont(12),
                  fontWeight: FontWeight.w500),
              contentPadding: EdgeInsets.only(
                  left: UiUtils.getDeviceBasedWidth(20),
                  top: UiUtils.getDeviceBasedHeight(15),
                  right: UiUtils.getDeviceBasedWidth(20),
                  bottom: UiUtils.getDeviceBasedHeight(15)),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.3),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 0.3),
              ),
            ),
      ),
    );
  }
}
