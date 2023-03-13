import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/icon_constants.dart';

abstract class UiUtils {
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getDeviceBasedWidth(double width) {
    var deviceWidth = Get.width;
    return (width / 375) * deviceWidth;
  }

  static double getDeviceBasedHeight(double height) {
    var deviceHeight = Get.height;
    return (height / 812) * deviceHeight;
  }

  static EdgeInsets getDeviceBasedPadding(
      double left, double top, double right, double bottom) {
    return EdgeInsets.fromLTRB(
        UiUtils.getDeviceBasedWidth(left),
        UiUtils.getDeviceBasedHeight(top),
        UiUtils.getDeviceBasedWidth(right),
        UiUtils.getDeviceBasedHeight(bottom));
  }

  static Widget getIcon(String imgName) {
    try {
      if (imgName.contains(IconsConstants.svgExt)) {
        return SvgPicture.asset(
          IconsConstants.svgFolderPath + imgName,
          fit: BoxFit.scaleDown,
        );
      } else if (imgName.contains(IconsConstants.pngExt)) {
        return Image.asset(
          IconsConstants.pngFolderPath + imgName,
          fit: BoxFit.scaleDown,
        );
      }
    } catch (_) {
      return SvgPicture.asset(
          IconsConstants.svgFolderPath + IconsConstants().icPlaceHolder);
    }
    return SvgPicture.asset(
        IconsConstants.svgFolderPath + IconsConstants().icPlaceHolder);
  }

  static String getImageWithPath(String imageName) {
    return IconsConstants.pngFolderPath + imageName;
  }

  static makeBorderRadius(
      {double all = 0,
      double topLeft = 0,
      double topRight = 0,
      double bottomLeft = 0,
      double bottomRight = 0}) {
    if (all != 0) {
      topLeft = all;
      topRight = all;
      bottomLeft = all;
      bottomRight = all;
    }

    return BorderRadius.only(
        topLeft: Radius.circular(getDeviceBasedRadius(topLeft)),
        topRight: Radius.circular(getDeviceBasedRadius(topRight)),
        bottomLeft: Radius.circular(getDeviceBasedRadius(bottomLeft)),
        bottomRight: Radius.circular(getDeviceBasedRadius(bottomRight)));
  }

  static makeBorder(
      {Color color = Colors.grey,
      double width = 0,
      BorderStyle borderStyle = BorderStyle.solid}) {
    return Border.all(
        color: color,
        width: UiUtils.getDeviceBasedWidth(width),
        style: borderStyle);
  }

  static getDeviceBasedRadius(var value) {
    var deviceWidth = Get.width;
    var percentage = ((value / 375.0)); //zeplin default width
    return (deviceWidth * percentage);
  }

  static double getDeviceBasedFont(double value) {
    /*   var scaleWidth = Get.width / 375;
    var scaleHeight = Get.height / 812;

    var scaleText = min(scaleWidth, scaleHeight);
    return value * scaleText;*/
    return value;
  }

  static getBoxShadow(
      {Color color = boxShadowColor,
      double blurRadius = 7,
      double spreadRadius = 1,
      double offset = 5}) {
    return [
      BoxShadow(
        color: color.withOpacity(0.5),
        spreadRadius: getDeviceBasedRadius(spreadRadius),
        blurRadius: getDeviceBasedRadius(blurRadius),
        offset: Offset(0, offset), // changes position of shadow
      ),
    ];
  }
}
