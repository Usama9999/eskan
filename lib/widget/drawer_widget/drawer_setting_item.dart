import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../design_util.dart';

class DrawerSettingItem extends StatelessWidget {
  String settingText;
  String settingIcon;
  bool logoutSetting;
  GestureTapCallback? onTap;

  DrawerSettingItem(
      {required this.settingText,
      required this.settingIcon,
      this.onTap,
      this.logoutSetting = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UiUtils.getDeviceBasedPadding(30, 0, 20, 30),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            logoutSetting
                ? Icon(
                    SimpleLineIcons.logout,
                    color: Colors.black,
                  )
                : UiUtils.getIcon(settingIcon),
            SizedBox(
              width: UiUtils.getDeviceBasedWidth(10),
            ),
            Text(
              settingText,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: UiUtils.getDeviceBasedFont(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
