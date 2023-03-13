import 'package:eskan/widget/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showCustomAlert(
    {required BuildContext context,
    required String strTitle,
    required String strMessage,
    String? strLeftBtnText,
    String? strRightBtnText,
    Function? onTapLeftBtn,
    Function? onTapRightBtn}) {
  return showGeneralDialog(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strTitle,
                          style: subHeadingText(size: 16),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          strMessage,
                          style: normalText(size: 16),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              strLeftBtnText!.isNotEmpty
                                  ? TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.blue,
                                          disabledForegroundColor: Colors.blue,
                                          backgroundColor: Colors.blue),
                                      onPressed: () {
                                        if (onTapLeftBtn != null) {
                                          onTapLeftBtn();
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text(strLeftBtnText,
                                          style: subHeadingText(
                                              color: Colors.white)),
                                    )
                                  : const SizedBox(
                                      height: 0,
                                      width: 0,
                                    ),
                              const SizedBox(
                                height: 0,
                                width: 10,
                              ),
                              strRightBtnText!.isNotEmpty
                                  ? TextButton(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.blue,
                                          disabledForegroundColor: Colors.blue,
                                          backgroundColor: Colors.blue),
                                      onPressed: () {
                                        if (onTapRightBtn != null) {
                                          onTapRightBtn();
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text(strRightBtnText,
                                          style: subHeadingText(
                                              color: Colors.white)),
                                    )
                                  : const SizedBox(
                                      height: 0,
                                      width: 0,
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });
}

showCustomAlertInfo(
    {required BuildContext context,
    required String strTitle,
    required String strMessage,
    String? strRightBtnText}) {
  return showGeneralDialog(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strTitle,
                          style: subHeadingText(size: 16),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          strMessage,
                          style: normalText(size: 16),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    disabledForegroundColor: Colors.blue,
                                    backgroundColor: Colors.blue),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('Ok',
                                    style: subHeadingText(color: Colors.white)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
