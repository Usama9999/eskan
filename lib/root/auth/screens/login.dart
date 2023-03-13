import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eskan/cache/cache_manager.dart';
import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/root/auth/screens/pre_signup.dart';
import 'package:eskan/widget/popup_widget/generic_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widget/app_bar_widget/app_bar_widget.dart';
import '../../../widget/button_widget/signin_button.dart';
import '../../../widget/design_util.dart';
import '../../../widget/input_widget/goat_input_widget.dart';
import '../../../widget/input_widget/text_widget.dart';
import '../controller/auth_controller.dart';
import '../service/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController =
      Get.put(AuthController(aService: AuthService()));
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool rememberMe = false;
  final auth = LocalAuthentication();

  late bool _canCheckBiometric;
  late List<BiometricType> _availableBiometric;

  bool biometricAuthenticated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRememberMe();
    _checkBiometric();
    _getAvailableBiometric();
    checkIfBiometricAuthenticated();
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  void getRememberMe() async {
    SharedPreferences.getInstance().then(
      (prefs) {
        print('rememberMe: ${prefs.getBool("rememberMe")}');
        print('email: ${prefs.getString("email")}');
        print('password: ${prefs.getString("password")}');

        rememberMe = prefs.getBool('rememberMe') ?? false;
        if (rememberMe) {
          emailController.text = prefs.getString('email') ?? '';
          passwordController.text = prefs.getString('password') ?? '';
        }

        setState(() {});
      },
    );
  }

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
                padding: UiUtils.getDeviceBasedPadding(20, 10, 20, 40),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        height: UiUtils.getDeviceBasedHeight(90),
                      ),
                      Text(
                        'Hello!',
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
                        "Let's sign in with your Phone",
                        style: TextStyle(
                          color: AppColors.primary1,
                          fontWeight: FontWeight.w700,
                          fontSize: UiUtils.getDeviceBasedFont(17),
                        ),
                      ),
                      SizedBox(
                        height: UiUtils.getDeviceBasedHeight(46),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 47,
                            padding:
                                UiUtils.getDeviceBasedPadding(10, 11, 10, 11),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.primary1, width: 2),
                              borderRadius: UiUtils.makeBorderRadius(all: 5),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: TextWidget(
                                text: '+974',
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: UiUtils.getDeviceBasedWidth(15),
                          ),
                          Expanded(
                            flex: 7,
                            child: GoatInputWidget(
                              hint: '0000 0000',
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Phone Number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: UiUtils.getDeviceBasedHeight(20),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            rememberMe = !rememberMe;
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 10,
                              child: Checkbox(
                                  value: rememberMe,
                                  onChanged: (val) {
                                    setState(() {
                                      rememberMe = !rememberMe;
                                    });
                                  }),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            TextWidget(
                              text: 'Remember Me',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: UiUtils.getDeviceBasedHeight(40),
                      ),
                      SigninButton(
                        onPressed: () async {
                          CacheManager().registerModel.phoneNumber =
                              phoneController.text
                                  .replaceAll(RegExp(r'\s+'), '');

                          CacheManager().rememberMe = rememberMe;
                          FirebaseFirestore.instance
                              .collection('user')
                              .where('phoneNumber',
                                  isEqualTo:
                                      CacheManager().registerModel.phoneNumber)
                              .get()
                              .then(
                            (value) async {
                              if (value.docs.isEmpty) {
                                await GenericErrorDialog.show(context,
                                    'No account with this phone exist');
                              } else {
                                // final repository = DataRepository();
                                // repository.getLoginData(context);
                                authController.registerUser(context,
                                    fromLogin: true);
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: UiUtils.getDeviceBasedHeight(0),
                      ),
                      SizedBox(
                        height: UiUtils.getDeviceBasedHeight(60),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Trouble ',
                            style: TextStyle(
                              color: AppColors.primary1,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //Get.to(SignupScreen());
                              Get.to(PreSignupScreen());
                            },
                            child: const Text(
                              'Signing In?',
                              style: TextStyle(
                                color: AppColors.primary1,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Future<void> checkIfBiometricAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String biometricPhoneNumber = prefs.getString('biometricPhoneNumber') ?? '';
    print('biometricPhoneNumber: $biometricPhoneNumber');
    if (biometricPhoneNumber.isNotEmpty) {
      biometricAuthenticated = true;
    } else {
      biometricAuthenticated = false;
    }
  }
}
