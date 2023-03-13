import 'package:flutter/material.dart';

import '../design_util.dart';

class StaticInputWidget extends StatelessWidget {
  Widget? suffixIcon;
  int? maxLines;
  String? hint;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  bool passwordText;
  TextStyle? style;
  InputDecoration? decoration;

  StaticInputWidget(
      {this.suffixIcon,
      this.maxLines,
      this.hint,
      this.style,
      this.decoration,
      this.controller,
      this.passwordText = false,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 0),
      child: TextFormField(
        maxLines: maxLines ?? maxLines,
        controller: controller,
        validator: validator,
        obscureText: passwordText,
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
                  color: Colors.grey,
                  fontSize: UiUtils.getDeviceBasedFont(17),
                  fontWeight: FontWeight.w300),
              contentPadding: EdgeInsets.only(
                  left: UiUtils.getDeviceBasedWidth(0),
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
