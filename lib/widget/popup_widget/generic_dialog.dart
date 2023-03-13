import 'package:eskan/widget/popup_widget/parent_alert.dart';
import 'package:flutter/material.dart';

import '../../constants/icon_constants.dart';
import '../design_util.dart';

class GenericDialog {
  static show(
    BuildContext context, {
    required String? img,
    required String? title,
    Widget? desc,
    required String? filledBtnMsg,
    Function? firstFunction,
    Function? secondFunction,
    Function? thirdFunction,
    String? outlinedBtnMsg,
    String? thirdBtnMsg,
  }) {
    ParentAlert(
        context,
        contentBox(context, img, title, desc, filledBtnMsg, firstFunction,
            secondFunction, thirdFunction, outlinedBtnMsg, thirdBtnMsg));
  }

  static contentBox(context, img, title, desc, filledBtnMsg, firstFunction,
      secondFunction, thirdFunction, outlinedBtnMsg, thirdBtnMsg) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          margin: UiUtils.getDeviceBasedPadding(20, 0, 20, 0),
          width: double.infinity,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: UiUtils.getBoxShadow(blurRadius: 16, offset: 10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Visibility(
                // image
                visible: (img != null),
                child: Padding(
                  padding: UiUtils.getDeviceBasedPadding(0, 43, 0, 0),
                  child: makeImageWidget(img),
                ),
              ),
              Visibility(
                // text title
                visible: isVisible(title),
                child: Padding(
                  padding: UiUtils.getDeviceBasedPadding(31, 29, 31, 0),
                  child: Text("text"),
                ),
              ),
              Visibility(
                // text desc
                visible: desc != null ? true : false,
                child: Padding(
                  padding: UiUtils.getDeviceBasedPadding(31, 16, 31, 0),
                  child: desc ?? Container(),
                ),
              ),
              Visibility(
                // filled button
                visible: isVisible(filledBtnMsg),
                child: Padding(
                  padding: UiUtils.getDeviceBasedPadding(25, 40, 25, 0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("child"),
                  ),
                ),
              ),
              Visibility(
                // outline button
                visible: isVisible(outlinedBtnMsg),
                child: Padding(
                  padding: UiUtils.getDeviceBasedPadding(25, 16, 25, 0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("child"),
                  ),
                ),
              ),
              Visibility(
                // outline button
                visible: isVisible(thirdBtnMsg),
                child: Padding(
                  padding: UiUtils.getDeviceBasedPadding(25, 16, 25, 0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("child"),
                  ),
                ),
              ),
              SizedBox(
                height: UiUtils.getDeviceBasedHeight(40),
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

  static bool isVisible(String? flag) {
    return (flag != null);
  }

  static makeImageWidget(String? img) {
    if (img != null) {
      if (img.contains(IconsConstants.svgExt)) {
        return UiUtils.getIcon(img);
      } else {
        return Image(
          image: AssetImage(
            UiUtils.getImageWithPath(img),
          ),
        );
      }
    }
  }
}
