import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/widget/input_widget/goat_input_widget.dart';
import 'package:eskan/widget/input_widget/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../repository/auth_exception_handler.dart';
import '../../../widget/app_bar_widget/app_bar_widget.dart';
import '../../../widget/button_widget/register_button.dart';
import '../../../widget/design_util.dart';
import '../controller/auth_controller.dart';
import '../service/services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  AuthController authController =
      Get.put(AuthController(aService: AuthService()));
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late AuthStatus _status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBarWidget(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
                padding: UiUtils.getDeviceBasedPadding(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: TextWidget(
                        text: 'Forgot Password',
                        color: AppColors.primary1,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: UiUtils.getDeviceBasedHeight(30),
                    ),
                    GoatInputWidget(
                      hint: 'Email Address',
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: UiUtils.getDeviceBasedHeight(20),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(ForgotPasswordScreen());
                        },
                        child: TextWidget(
                          text: 'Put your email to reset your password.',
                          color: Colors.grey.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Spacer(),
                    ButtonWidget(
                      buttonText: 'Reset Password',
                      onPressed: () {
                        // nameController.text = 'Wasif';
                        //emailController.text = 'wasif.ibrahim29@gmail.com';
                        // passwordController.text = '123456';
                        // phoneController.text = '3176016598';
                        // locationController.text = 'Lahoree';
                        if (_formKey.currentState!.validate()) {
                          resetPassword(email: emailController.text);

                          showDialog(
                              useRootNavigator: false,
                              context: context,
                              useSafeArea: true,
                              barrierDismissible: true,
                              barrierColor: Colors.transparent,
                              builder: (BuildContext context) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.all(0),
                                  backgroundColor: Colors.black54,
                                  child: Padding(
                                    padding: UiUtils.getDeviceBasedPadding(
                                        30, 0, 30, 0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            color: Colors.white,
                                            boxShadow: UiUtils.getBoxShadow(
                                                offset: 10,
                                                blurRadius: 16,
                                                color: Colors.black12),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(Entypo.cross),
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding: UiUtils
                                                      .getDeviceBasedPadding(
                                                          30, 10, 30, 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: UiUtils
                                                            .getDeviceBasedHeight(
                                                                13),
                                                      ),
                                                      UiUtils.getIcon(
                                                          "redInfoIcon.svg"),
                                                      SizedBox(
                                                        height: UiUtils
                                                            .getDeviceBasedHeight(
                                                                20),
                                                      ),
                                                      Text(
                                                        "An email has been sent to your email to reset your password.",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: UiUtils
                                                              .getDeviceBasedFont(
                                                                  14),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: UiUtils
                                                            .getDeviceBasedHeight(
                                                                20),
                                                      ),
                                                      ButtonWidget(
                                                        buttonText: 'Okay',
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: UiUtils
                                                            .getDeviceBasedHeight(
                                                                10),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }

                        // if (_formKey.currentState!.validate()) {
                        //   print('register user');
                        //   authController.registerUser(context,
                        //       emailController.text, passwordController.text);
                        // }
                      },
                    ),
                    SizedBox(
                      height: UiUtils.getDeviceBasedHeight(20),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Future<AuthStatus> resetPassword({required String email}) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));

    print("STATUS: $_status");
    return _status;
  }
}
