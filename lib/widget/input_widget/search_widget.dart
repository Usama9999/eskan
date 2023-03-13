import 'package:flutter/material.dart';

import '../design_util.dart';

class SearchWidget extends StatelessWidget {
  Widget? suffixIcon;
  int maxLines;
  String? hint;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  bool passwordText;
  ValueChanged<String>? onChanged;
  FocusNode? focusNode;

  SearchWidget(
      {this.suffixIcon,
      this.maxLines = 1,
      this.hint,
      this.controller,
      this.onChanged,
      this.focusNode,
      this.passwordText = false,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        validator: validator,
        obscureText: passwordText,
        focusNode: focusNode,
        textInputAction:
            maxLines > 1 ? TextInputAction.newline : TextInputAction.search,
        onChanged: onChanged,
        style: TextStyle(
            fontSize: UiUtils.getDeviceBasedFont(14),
            color: Colors.black,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          filled: true,
          isDense: true,
          fillColor: Colors.white,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.search_rounded,
              color: Colors.grey,
              size: 24,
            ),
          ),
          suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          hintText: hint,
          hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: UiUtils.getDeviceBasedFont(14),
              fontWeight: FontWeight.w500),
          contentPadding: EdgeInsets.only(
              left: UiUtils.getDeviceBasedWidth(20),
              top: UiUtils.getDeviceBasedHeight(10),
              right: UiUtils.getDeviceBasedWidth(20),
              bottom: UiUtils.getDeviceBasedHeight(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(0),
            ),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(0),
            ),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
        ),
      ),
    );
  }
}
