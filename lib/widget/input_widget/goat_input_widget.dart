import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../constants/app_colors.dart';
import '../design_util.dart';

class GoatInputWidget extends StatelessWidget {
  Widget? suffixIcon;
  int? maxLines;
  String? hint;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  bool passwordText;
  bool userNameField;
  TextInputType? keyboardType;
  bool error;
  ValueChanged<String>? onChanged;

  bool? price;

  var maskFormatter = MaskTextInputFormatter(
      mask: '#### ####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  GoatInputWidget(
      {this.suffixIcon,
      this.maxLines,
      this.hint,
      this.onChanged,
      this.price,
      this.controller,
      this.error = false,
      this.keyboardType,
      this.userNameField = false,
      this.passwordText = false,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      controller: controller,
      validator: validator,
      obscureText: passwordText,
      cursorColor: Colors.black,
      onChanged: onChanged,
      inputFormatters: keyboardType != null && price == null
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              maskFormatter
            ]
          : keyboardType != null && price != null
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
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
          fontSize: UiUtils.getDeviceBasedFont(14),
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
    );
  }
}
