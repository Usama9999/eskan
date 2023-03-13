import 'package:eskan/root/main/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import '../../../cache/cache_manager.dart';
import '../../../repository/data_repository.dart';
import '../../../widget/alert.dart';
import '../../../widget/button_widget/social_button.dart';
import '../../../widget/design_util.dart';
import '../../../widget/loading_widget/loading_widget.dart';
import '../../../widget/popup_widget/generic_error_dialog.dart';
import '../controller/auth_controller.dart';
import '../model/register_model.dart';

class OTPScreen extends StatefulWidget {
  bool comingFromLoginScreen;
  String phoneNumber;

  OTPScreen({this.comingFromLoginScreen = false, this.phoneNumber = ''});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  AuthController authController = Get.put(AuthController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormFieldState<String>> _formKey =
      GlobalKey<FormFieldState<String>>(debugLabel: '_formkey');

  final TextEditingController pinEditingController =
      TextEditingController(text: "");

  @override
  void initState() {
    pinEditingController.addListener(() {
      debugPrint('controller execute. pin:${pinEditingController.text}');
    });
  }

  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: UiUtils.getDeviceBasedPadding(20, 20, 20, 20),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: UiUtils.getDeviceBasedPadding(0, 20, 0, 20),
                  child: Text(
                    'Please enter the code we sent to your number.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: UiUtils.getDeviceBasedFont(18),
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Padding(
                  padding: UiUtils.getDeviceBasedPadding(20, 20, 20, 20),
                  child: PinInputTextFormField(
                    pinLength: 6,
                    key: _formKey,
                    keyboardType: TextInputType.phone,
                    enabled: true,
                    autoFocus: true,
                    controller: pinEditingController,
                    validator: (pin) {
                      if (pin!.isEmpty) {
                        setState(() {
                          _hasError = true;
                        });
                        return 'Pin cannot empty.';
                      }
                      if (pin.length < 6) {
                        setState(() {
                          _hasError = true;
                        });
                        return 'Pin is not completed.';
                      }
                      setState(() {
                        _hasError = false;
                      });
                      return null;
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    decoration: UnderlineDecoration(
                      lineHeight: 3,
                      colorBuilder:
                          PinListenColorBuilder(Colors.blue, Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: UiUtils.getDeviceBasedPadding(20, 80, 20, 20),
                  child: SocialButton(
                      buttonText: "Continue",
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _formKey.currentState!.save();

                        try {
                          // LoadingWidget(context).showProgressIndicator();

                          FirebaseAuth _auth = FirebaseAuth.instance;
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: CacheManager().verificationId,
                                  smsCode: pinEditingController.text);

                          UserCredential userCredential =
                              await _auth.signInWithCredential(credential);
                          if (userCredential.user != null) {
                            if (widget.comingFromLoginScreen) {
                              final repository = DataRepository();
                              repository.getLoginData(context);
                            } else {
                              final DataRepository repository =
                                  DataRepository();
                              final newUser = RegisterRequestModel(
                                  id: userCredential.user!.uid,
                                  comment: '',
                                  enabledUser: false,
                                  // CacheManager().registerModel.userType == 0
                                  //     ? true
                                  //     : false,
                                  email: CacheManager().registerModel.email,
                                  phoneNumber: CacheManager()
                                      .registerModel
                                      .phoneNumber
                                      ?.replaceAll(new RegExp(r"\s+"), ""),
                                  location:
                                      CacheManager().registerModel.location,
                                  businessName:
                                      CacheManager().registerModel.businessName,
                                  fullName:
                                      CacheManager().registerModel.fullName,
                                  userType:
                                      CacheManager().registerModel.userType);
                              await repository
                                  .addUser(newUser)
                                  .then((value) {});
                              print('Registered Successfully');

                              LoadingWidget(context).hideProgressIndicator();

                              print(userCredential);

                              Get.offAll(DashboardScreen());
                              showCustomAlertInfo(
                                context: Get.overlayContext!,
                                strTitle: 'Profile submitted',
                                strMessage:
                                    'Your Profile is submitted and is under review. Please wait until we approve your profile',
                                strRightBtnText: 'Yes',
                              );
                            }
                          } else {
                            // ignore: use_build_context_synchronously
                            await GenericErrorDialog.show(
                                context, 'Invalid OTP');
                          }
                        } on FirebaseAuthException catch (e) {
                          LoadingWidget(context).hideProgressIndicator();
                          if (e.code == 'session-expired') {
                            Get.back();
                            await GenericErrorDialog.show(
                                context, 'OTP expired');

                            Get.back();
                          } else if (e.code == 'invalid-verification-code') {
                            await GenericErrorDialog.show(
                                context, 'Invalid OTP');
                          }
                        } catch (e) {
                          Get.back();
                          await GenericErrorDialog.show(
                              context, 'Something went wrong. Try again!');

                          LoadingWidget(context).hideProgressIndicator();
                          print(e);
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
