import 'package:eskan/root/main/controller/main_controller.dart';
import 'package:eskan/root/main/model/property_model.dart';
import 'package:eskan/root/main/service/services.dart';
import 'package:eskan/widget/input_widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widget/button_widget/main_color_button.dart';
import '../../../widget/design_util.dart';
import '../../auth/screens/login.dart';

class MyPropertiesScreen extends StatefulWidget {
  @override
  _MyPropertiesScreenState createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  MainController mainController =
      Get.put(MainController(mService: MainService()));
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  GlobalKey<ScaffoldState>? globalKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  late PropertyModel propertyModel;
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState bitch");
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: UiUtils.getDeviceBasedPadding(20, 20, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'My Properties',
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextWidget(
                    text: 'Log in to view your own properties',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text:
                        'You can add, view and edit your own properties once you have logged in.',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  MainColorButton(
                      buttonText: 'Log in',
                      onPressed: () {
                        Get.to(LoginScreen());
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
