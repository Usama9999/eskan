import 'package:eskan/cache/cache_manager.dart';
import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/root/auth/screens/bus_signup.dart';
import 'package:eskan/root/auth/screens/ind_signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widget/app_bar_widget/app_bar_widget.dart';
import '../../../widget/button_widget/register_button.dart';
import '../../../widget/design_util.dart';
import '../../../widget/input_widget/text_widget.dart';
import '../controller/auth_controller.dart';
import '../service/services.dart';

class PreSignupScreen extends StatefulWidget {
  @override
  _PreSignupScreenState createState() => _PreSignupScreenState();
}

class _PreSignupScreenState extends State<PreSignupScreen> {
  AuthController authController =
      Get.put(AuthController(aService: AuthService()));
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
                padding: UiUtils.getDeviceBasedPadding(20, 0, 20, 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: UiUtils.getDeviceBasedHeight(0),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextWidget(
                          text: 'Eskan',
                          color: AppColors.primary1,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: UiUtils.getDeviceBasedHeight(40),
                      ),
                      Text(
                        "Hello!",
                        style: TextStyle(
                          color: AppColors.primary1,
                          fontWeight: FontWeight.w900,
                          fontSize: UiUtils.getDeviceBasedFont(20),
                        ),
                      ),
                      SizedBox(
                        height: UiUtils.getDeviceBasedHeight(6),
                      ),
                      Text(
                        "Let's sign up with your Phone",
                        style: TextStyle(
                          color: AppColors.primary1,
                          fontWeight: FontWeight.w700,
                          fontSize: UiUtils.getDeviceBasedFont(17),
                        ),
                      ),
                      SizedBox(
                        height: UiUtils.getDeviceBasedHeight(96),
                      ),
                      ButtonWidget(
                        buttonText: 'Register as Individual',
                        onPressed: () {
                          CacheManager().registerModel.userType = 0;
                          Get.to(IndividualSignupScreen());
                        },
                      ),
                      SizedBox(
                        height: UiUtils.getDeviceBasedHeight(10),
                      ),
                      ButtonWidget(
                        buttonText: 'Register as Business',
                        onPressed: () {
                          CacheManager().registerModel.userType = 1;
                          Get.to(BusinessSignupScreen());
                        },
                      ),
                      SizedBox(
                        height: UiUtils.getDeviceBasedHeight(20),
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
