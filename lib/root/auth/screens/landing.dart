import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/firebase/login_data.dart';
import 'package:eskan/root/auth/screens/pre_signup.dart';
import 'package:eskan/widget/input_widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widget/button_widget/main_color_button.dart';
import '../../../widget/design_util.dart';
import 'login.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<UserDetail>(builder: (value) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: Padding(
              padding: UiUtils.getDeviceBasedPadding(20, 20, 20, 20),
              child: value.login
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(text: value.admin ? 'Admin' : value.name),
                        SizedBox(
                          height: 45,
                        ),
                        Row(
                          children: [
                            TextWidget(
                              text: 'Phone No: ',
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            TextWidget(
                              text: value.phoneNumber,
                              fontSize: 18,
                              color: AppColors.primary1,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: 'Location: ',
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: TextWidget(
                                text: value.admin
                                    ? '27th Avenue Street, Doha'
                                    : value.location,
                                fontSize: 18,
                                color: AppColors.primary1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            Get.find<UserDetail>().logout();
                          },
                          child: TextWidget(
                            text: 'Log out',
                            underLine: true,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: 'Your profile',
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextWidget(
                          text: 'Log in to start adding your own properties.',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: 45,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: MainColorButton(
                              buttonText: 'Log in',
                              onPressed: () {
                                Get.to(LoginScreen());
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            TextWidget(
                              text: 'Don\'t have an account?',
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(PreSignupScreen());
                              },
                              child: TextWidget(
                                text: 'Sign up',
                                fontSize: 13,
                                underLine: true,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        );
      }),
    );
  }
}
