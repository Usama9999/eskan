import 'dart:async';

import 'package:eskan/firebase/login_data.dart';
import 'package:eskan/root/main/screens/dashboard.dart';
import 'package:eskan/widget/design_util.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_constant.dart';
import '../../../repository/data_repository.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controller/auth_controller.dart';
import '../../auth/screens/admin_panel.dart';
import '../../auth/service/services.dart';
import '../../bindings/home_bindings.dart';

class EskanApp extends StatefulWidget {
  final PendingDynamicLinkData? initialLink;

  const EskanApp(this.initialLink, {super.key});

  @override
  State<EskanApp> createState() => _EskanAppState();
}

class _EskanAppState extends State<EskanApp> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MediaQuery(
        data: MediaQueryData(),
        child: GetMaterialApp(
          enableLog: false,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: AppConstants.appFont,
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home: SplashScreen(widget.initialLink),
          initialBinding: HomeBindings(),
          defaultTransition: Transition.rightToLeftWithFade,
          initialRoute: Routes.SPLASH,
          getPages: AppPages.pages,
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  PendingDynamicLinkData? initialLink;

  SplashScreen(this.initialLink);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthController authController =
      Get.put(AuthController(aService: AuthService()));

  @override
  void initState() {
    super.initState();
    if (widget.initialLink != null) {
      final Uri? deepLink = widget.initialLink?.link;
      // Example of using the dynamic link to push the user to a different screen
      final queryParams = deepLink?.queryParameters;
      print('Hellooo');
      if (queryParams!.isNotEmpty) {
        String? propertyType = queryParams['propertyType'];
        String? addId = queryParams['addId'];
        print('propertyType: $propertyType');

        DataRepository dataRepository = DataRepository();
        dataRepository.getAProperty(context, propertyType!, addId!);
      }
    } else {
      check();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: UiUtils.getIcon('EskanLogo.png'),
      ),
    );
  }

  check() {
    Timer(Duration(seconds: 1), () async {
      await Get.find<UserDetail>().getData();
      if (await Get.find<UserDetail>().isLogin()) {
        if (await Get.find<UserDetail>().isAdmin()) {
          Get.offAll(AdminDashboardScreen());
        } else {
          Get.offAll(DashboardScreen());
        }
      } else {
        Get.offAll(DashboardScreen());
      }
    });
  }
}
