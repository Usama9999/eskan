import 'package:eskan/root/auth/model/register_model.dart';
import 'package:eskan/root/main/screens/dashboard.dart';
import 'package:eskan/widget/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetail extends GetxController {
  String userId = '';
  String name = '';
  String email = '';
  String phoneNumber = '';
  String location = '';
  bool login = false;
  bool admin = false;

  Future<void> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    name = sharedPreferences.getString('name') ?? '';
    userId = sharedPreferences.getString('id') ?? '';
    email = sharedPreferences.getString('email') ?? '';
    phoneNumber = sharedPreferences.getString('phone') ?? '';
    location = sharedPreferences.getString('location') ?? '';
    login = sharedPreferences.getBool('isLogin') ?? false;
    admin = sharedPreferences.getBool('isAdmin') ?? false;
    update();
  }

  Future<void> setData(RegisterRequestModel user,
      {isAdmin = false, isLogin = false}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('name', user.fullName!);
    await sharedPreferences.setString('id', user.id!);
    await sharedPreferences.setString('email', user.email!);
    await sharedPreferences.setString('phone', user.phoneNumber!);
    await sharedPreferences.setString('location', user.location!);
    await sharedPreferences.setBool('isLogin', isLogin);
    await sharedPreferences.setBool('isAdmin', isAdmin);
    await getData();
    update();
  }

  Future<bool> isLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isLogin') ?? false;
  }

  Future<bool> isAdmin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('isAdmin') ?? false;
  }

  // Future<void> delete() async {
  //   showCustomAlert(
  //       context: Get.overlayContext!,
  //       strTitle: "Delete Account",
  //       strMessage: 'Are you sure you want to delete your account permanently?',
  //       strLeftBtnText: 'No',
  //       onTapLeftBtn: () {
  //         Get.back();
  //       },
  //       strRightBtnText: 'Yes',
  //       onTapRightBtn: () async {
  //         try {
  //           await FirebaseAuth.instance.currentUser!
  //               .delete()
  //               .then((value) async {
  //             SharedPreferences sharedPreferences =
  //                 await SharedPreferences.getInstance();
  //             await sharedPreferences.clear();
  //             await sharedPreferences.remove('isLogin');
  //             Get.offAll(() => LoginScreen());
  //           });
  //         } on FirebaseAuthException catch (e) {
  //           if (e.code == 'requires-recent-login') {
  //             Global.showToastAlert(
  //                 context: Get.overlayContext!,
  //                 strTitle: "ok",
  //                 strMsg: 'You need to login again',
  //                 toastType: TOAST_TYPE.toastError);
  //           }
  //         }
  //       });
  // }

  Future<void> logout() async {
    showCustomAlert(
        context: Get.overlayContext!,
        strTitle: 'Logout',
        strMessage: 'Are you sure you want to logout?',
        strLeftBtnText: 'No',
        onTapLeftBtn: () {
          Get.back();
        },
        strRightBtnText: 'Yes',
        onTapRightBtn: () async {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          await sharedPreferences.clear();
          await sharedPreferences.remove('isLogin');
          await FirebaseAuth.instance.signOut();
          await getData();
          update();
          Get.offAll(() => DashboardScreen());
        });
  }
}
