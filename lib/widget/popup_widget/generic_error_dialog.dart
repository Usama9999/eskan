import 'package:eskan/widget/popup_widget/parent_alert.dart';
import 'package:flutter/material.dart';

import '../button_widget/register_button.dart';
import '../design_util.dart';

class GenericErrorDialog {
  static show(BuildContext context, String msg, {String btnMsg = ""}) {
    ParentAlert(context, contentBox(context, msg, btnMsg));
  }

  static contentBox(context, msg, btnMsg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: UiUtils.getBoxShadow(
                offset: 10, blurRadius: 16, color: Colors.black12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: UiUtils.getDeviceBasedHeight(33),
              ),
              UiUtils.getIcon("infoIcon.svg"),
              SizedBox(
                height: UiUtils.getDeviceBasedHeight(20),
              ),
              Padding(
                padding: UiUtils.getDeviceBasedPadding(10, 10, 10, 10),
                child: Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: UiUtils.getDeviceBasedFont(15),
                  ),
                ),
              ),
              SizedBox(
                height: UiUtils.getDeviceBasedHeight(20),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ButtonWidget(
                    buttonText: "Close",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: UiUtils.getDeviceBasedHeight(20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  hide(BuildContext context) {
    Navigator.pop(context);
  }
}
