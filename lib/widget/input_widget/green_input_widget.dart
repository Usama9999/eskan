import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_colors.dart';
import '../design_util.dart';

class GreenInputWidget extends StatelessWidget {
  Widget? suffixIcon;
  int? maxLines;
  String? hint;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  bool passwordText;
  bool userNameField;
  bool error;
  ValueChanged<String>? onChanged;

  GreenInputWidget(
      {this.suffixIcon,
      this.maxLines,
      this.hint,
      this.error = false,
      this.controller,
      this.onChanged,
      this.userNameField = false,
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
        cursorColor: Colors.black,
        onChanged: onChanged,
        autofocus: false,
        inputFormatters: userNameField
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[^ ]*")),
              ]
            : null,
        style: TextStyle(
            fontSize: UiUtils.getDeviceBasedFont(16),
            color: Colors.black,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          counterText: "",
          suffixIcon: suffixIcon ?? suffixIcon,
          hintText: hint != null ? hint : "Enter Here",
          hintStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: UiUtils.getDeviceBasedFont(15),
          ),
          contentPadding: EdgeInsets.only(
              left: UiUtils.getDeviceBasedWidth(15),
              top: UiUtils.getDeviceBasedHeight(10),
              right: UiUtils.getDeviceBasedWidth(0),
              bottom: UiUtils.getDeviceBasedHeight(10)),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                width: 2, color: error ? Colors.red : AppColors.primary1),
            borderRadius: UiUtils.makeBorderRadius(all: 5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: error ? Colors.red : AppColors.primary1, width: 2),
            borderRadius: UiUtils.makeBorderRadius(all: 5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: error ? Colors.red : AppColors.primary1, width: 2),
            borderRadius: UiUtils.makeBorderRadius(all: 5),
          ),
        ),
      ),
    );
  }
}
