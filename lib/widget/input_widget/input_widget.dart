import 'package:flutter/material.dart';

import '../design_util.dart';

class InputWidget extends StatelessWidget {
  Widget? suffixIcon;
  int? maxLines;
  String? hint;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  bool obscureText;
  TextStyle? style;
  InputDecoration? decoration;
  double? textSize;
  ValueChanged<String>? onChanged;
  double topContentPadding;
  double leftContentPadding;
  double rightContentPadding;
  double bottomContentPadding;
  Color hintColor;
  Color fillColor;
  double hintFontSize;
  FontWeight? hintFontWeight;
  bool underLine;
  bool passwordText;

  InputWidget(
      {this.suffixIcon,
      this.maxLines,
      this.hint,
      this.style,
      this.hintColor = Colors.grey,
      this.decoration,
      this.textSize = 18,
      this.onChanged,
        this.passwordText=false,
      this.underLine = true,
      this.hintFontWeight = FontWeight.w300,
      this.hintFontSize = 17,
      this.fillColor = Colors.white,
      this.topContentPadding = 15,
      this.leftContentPadding = 0,
      this.rightContentPadding = 20,
      this.bottomContentPadding = 15,
      this.controller,
      this.obscureText = false,
      this.validator});

  @override
  Widget build(BuildContext context) {
    print("$hint: $obscureText");
    return Padding(
      padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 0),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        cursorColor: Colors.black,
        onChanged: onChanged,
        style: style ??
            TextStyle(
                fontSize: UiUtils.getDeviceBasedFont(textSize!),
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.w600),
        decoration: decoration ??
            InputDecoration(
              filled: true,
              isDense: false,
              fillColor: fillColor,
              suffixIcon: suffixIcon,
              suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
              hintText: hint ?? "",
              hintStyle: TextStyle(
                  color: hintColor,
                  fontSize: UiUtils.getDeviceBasedFont(hintFontSize),
                  fontWeight: hintFontWeight),
              contentPadding: EdgeInsets.only(
                  left: UiUtils.getDeviceBasedWidth(leftContentPadding),
                  top: UiUtils.getDeviceBasedHeight(topContentPadding),
                  right: UiUtils.getDeviceBasedWidth(rightContentPadding),
                  bottom: UiUtils.getDeviceBasedHeight(bottomContentPadding)),
              enabledBorder: underLine
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.3),
                    )
                  : InputBorder.none,
              focusedBorder: underLine
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.3),
                    )
                  : InputBorder.none,
            ),
      ),
    );
  }
}
