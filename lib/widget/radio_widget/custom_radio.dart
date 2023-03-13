import 'package:flutter/material.dart';

import '../design_util.dart';

class CustomRadio extends StatefulWidget {
  String radioValue;
  String selectedRadioValue;
  CustomRadio({required this.radioValue, required this.selectedRadioValue});

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(widget.radioValue),
      margin: UiUtils.getDeviceBasedPadding(0, 0, 0, 0),
      child: Container(
        height: UiUtils.getDeviceBasedHeight(18),
        width: UiUtils.getDeviceBasedWidth(18),
        child: Visibility(
          visible: widget.radioValue == widget.selectedRadioValue,
          child: Padding(
            padding: UiUtils.getDeviceBasedPadding(3.5, 3.5, 3.5, 3.5),
            child: Container(
              height: UiUtils.getDeviceBasedHeight(10),
              width: UiUtils.getDeviceBasedWidth(10),
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  width: UiUtils.getDeviceBasedWidth(1),
                  color: Colors.grey,
                ),
                //borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          border: Border.all(
              width: UiUtils.getDeviceBasedWidth(1), color: Colors.white),
          //borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
        ),
      ),
    );
  }
}
