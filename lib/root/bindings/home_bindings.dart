import 'package:eskan/firebase/login_data.dart';
import 'package:eskan/root/auth/service/services.dart';
import 'package:eskan/root/main/controller/main_controller.dart';
import 'package:get/get.dart';

import '../auth/controller/auth_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(aService: AuthService()));
    Get.lazyPut<UserDetail>(() => UserDetail(), fenix: true);
    Get.lazyPut<MainController>(() => MainController(), fenix: true);
  }
}
