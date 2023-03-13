import 'package:eskan/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../design_util.dart';

class BlackCustomRadio extends StatefulWidget {
  String radioValue;
  String selectedRadioValue;
  BlackCustomRadio(
      {required this.radioValue, required this.selectedRadioValue});

  @override
  _BlackCustomRadioState createState() => _BlackCustomRadioState();
}

class _BlackCustomRadioState extends State<BlackCustomRadio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(widget.radioValue),
      margin: UiUtils.getDeviceBasedPadding(0, 0, 0, 0),
      child: Container(
        height: UiUtils.getDeviceBasedHeight(18),
        width: UiUtils.getDeviceBasedWidth(18),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
              width: UiUtils.getDeviceBasedWidth(1), color: Colors.black),
          //borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
        ),
        child: Visibility(
          visible: widget.radioValue == widget.selectedRadioValue,
          child: Padding(
            padding: UiUtils.getDeviceBasedPadding(2.5, 2.5, 2.5, 2.5),
            child: Container(
              height: UiUtils.getDeviceBasedHeight(10),
              width: UiUtils.getDeviceBasedWidth(10),
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(
                  width: UiUtils.getDeviceBasedWidth(1),
                  color: Colors.black,
                ),
                //borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
