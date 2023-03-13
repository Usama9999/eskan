import 'package:eskan/widget/design_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../widget/button_widget/signin_button.dart';

class InvitePage extends StatelessWidget {
  const InvitePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textDescPan = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text:
                "Please refer a friend to Eskan and help us grow our community ",
            style: TextStyle(
                color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
            children: <TextSpan>[]));

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: InviteAppBarWidget(),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text('Share Eskan',
                    style: Get.textTheme.bodyText2!
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 17)),
                SizedBox(
                  height: 30,
                ),
                UiUtils.getIcon('share.png'),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: UiUtils.getDeviceBasedPadding(20, 10, 20, 20),
                  child: textDescPan,
                ),
                SizedBox(
                  height: 50,
                ),
                SigninButton(
                  buttonText: "Share Link",
                  onPressed: share,
                ),
                SizedBox(
                  height: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Share invite to',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }
}
