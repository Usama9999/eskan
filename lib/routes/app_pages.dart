import 'package:eskan/root/auth/screens/login.dart';
import 'package:get/get.dart';

import '../root/bindings/home_bindings.dart';

part './app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.LANDING,
      page: () => LoginScreen(),
      binding: HomeBindings(),
    ),
  ];
}
