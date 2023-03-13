import 'package:eskan/widget/design_util.dart';
import 'package:flutter/material.dart';

class DescriptionWidget extends StatelessWidget {
  Widget? suffixIcon;
  int? maxLines;
  String? hint;
  double? borderRadius;
  TextEditingController? controller;
  bool passwordField;
  ValueChanged<String>? onChanged;

  DescriptionWidget(
      {this.suffixIcon,
      this.maxLines,
      this.hint,
      this.borderRadius,
      this.onChanged,
      this.passwordField = false,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UiUtils.getDeviceBasedHeight(150),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 0.3,
        ),
        borderRadius: BorderRadius.circular(0),
      ),
      child: TextFormField(
        maxLines: maxLines ?? maxLines,
        onChanged: onChanged,
        controller: controller,
        obscureText: passwordField,
        style: TextStyle(
            fontSize: UiUtils.getDeviceBasedFont(14),
            color: Colors.black,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          counterText: "",
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: UiUtils.getDeviceBasedFont(13),
          ),
          contentPadding: EdgeInsets.symmetric(
              vertical: UiUtils.getDeviceBasedHeight(12),
              horizontal: UiUtils.getDeviceBasedWidth(10)),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
