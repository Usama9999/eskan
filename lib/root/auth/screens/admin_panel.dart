import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/root/main/controller/main_controller.dart';
import 'package:eskan/root/main/screens/approved_explore_screen.dart';
import 'package:eskan/root/main/screens/explore_screen.dart';
import 'package:eskan/root/main/screens/pending_explore_screen.dart';
import 'package:eskan/root/main/service/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../auth/screens/landing.dart';
import 'active_users.dart';

class AdminDashboardScreen extends StatefulWidget {
  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late TabController tabController;

  MainController mainController =
      Get.put(MainController(mService: MainService()));

  late var bottomTabs = [];

  @override
  void initState() {
    super.initState();
    bottomTabs = [
      ExploreScreen(),
      PendingExploreScreen(),
      ApprovedExploreScreen(),
      ActiveUsersScreen(),
      LandingScreen(),
    ];

    tabController = TabController(length: 13, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary1,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: SizedBox(
          height: 90,
          child: BottomNavigationBar(
            currentIndex: mainController.currentIndex.value,
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.black,
            showUnselectedLabels: true,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            elevation: 15,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary1,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            items: const [
              BottomNavigationBarItem(
                  icon: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Icon(Icons.search)),
                  label: 'Properties'),
              BottomNavigationBarItem(
                  icon: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Icon(MaterialIcons.apartment)),
                  label: 'Pending'),
              BottomNavigationBarItem(
                  icon: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Icon(MaterialIcons.apartment)),
                  label: 'Approved'),
              BottomNavigationBarItem(
                  icon: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Icon(AntDesign.hearto)),
                  label: 'Active Users'),
              BottomNavigationBarItem(
                  icon: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Icon(Ionicons.person_circle_outline)),
                  label: 'Login'),
            ],
            onTap: (index) {
              setState(() {
                mainController.currentIndex.value = index;
              });
            },
          ),
        ),
        // drawer: Get.find<UserDetail>().login
        //     ? Container(
        //         color: Colors.white,
        //         width: width - 150,
        //         child: Column(
        //           children: [
        //             const SizedBox(
        //               height: 40,
        //             ),
        //             Padding(
        //               padding: UiUtils.getDeviceBasedPadding(18, 18, 2, 2),
        //               child: Row(
        //                 children: [
        //                   const SizedBox(
        //                     width: 50,
        //                     height: 50,
        //                     child: CircleAvatar(
        //                       foregroundImage:
        //                           AssetImage('assets/svgs/avatar.webp'),
        //                       radius: 50,
        //                     ),
        //                   ),
        //                   const SizedBox(
        //                     width: 20,
        //                   ),
        //                   Column(
        //                     mainAxisSize: MainAxisSize.min,
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       SizedBox(
        //                         width: width - 250,
        //                         child: TextWidget(
        //                           text: CacheManager().userName,
        //                           fontWeight: FontWeight.w900,
        //                           color: Colors.black,
        //                           fontSize: 16,
        //                           maxLines: 1,
        //                         ),
        //                       ),
        //                       const SizedBox(
        //                         height: 3,
        //                       ),
        //                       SizedBox(
        //                         width: width - 270,
        //                         child: AutoSizeText(
        //                           CacheManager().phoneNumber,
        //                           minFontSize: 8,
        //                           style: TextStyle(
        //                               color: Colors.black,
        //                               fontWeight: FontWeight.w700),
        //                           softWrap: true,
        //                           maxLines: 1,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             SizedBox(
        //               height: 10,
        //             ),
        //             Divider(
        //               color: Colors.grey,
        //             ),
        //             SizedBox(
        //               height: 30,
        //             ),
        //             GestureDetector(
        //               onTap: () async {
        //                 Navigator.pop(context);
        //                 final result = await Get.to(MyPropertyScreen());
        //                 if (result != null && result) {
        //                   print(' HEREEEEE');
        //                   mainController.update();
        //                   Navigator.of(context).pushAndRemoveUntil(
        //                       MaterialPageRoute(
        //                           builder: (context) => AdminDashboardScreen()),
        //                       (Route<dynamic> route) => false);

        //                   // mainController.hasAllPropertiesCome.value = false;
        //                   // mainController.update();
        //                   // final DataRepository repository = DataRepository();
        //                   // print('getting more properties');
        //                   // // ignore: use_build_context_synchronously
        //                   // await repository.getAllProperties(
        //                   //     context, mainController);
        //                   // print(mainController.allProperties.length);
        //                   //
        //                   // mainController.hasAllPropertiesCome.value = true;
        //                   //
        //                   // mainController.update();
        //                 }
        //               },
        //               child: Container(
        //                 color: Colors.white,
        //                 child: Row(
        //                   // ignore: prefer_const_literals_to_create_immutables
        //                   children: [
        //                     SizedBox(
        //                       width: 20,
        //                     ),
        //                     Icon(
        //                       FontAwesome.building_o,
        //                       color: AppColors.primary1,
        //                       size: 17,
        //                     ),
        //                     SizedBox(
        //                       width: 20,
        //                     ),
        //                     TextWidget(
        //                       text: 'My Properties',
        //                       fontSize: 15,
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             Spacer(),
        //             GestureDetector(
        //               onTap: () async {
        //                 SharedPreferences prefs =
        //                     await SharedPreferences.getInstance();
        //                 // await prefs.setString('email', '');
        //                 // await prefs.setString('password', '');

        //                 CacheManager().phoneNumber = '';
        //                 Navigator.pop(context);
        //                 Navigator.of(context).pushAndRemoveUntil(
        //                     MaterialPageRoute(
        //                         builder: (context) => AdminDashboardScreen()),
        //                     (Route<dynamic> route) => false);
        //               },
        //               child: Container(
        //                 color: Colors.white,
        //                 child: Row(
        //                   // ignore: prefer_const_literals_to_create_immutables
        //                   children: [
        //                     SizedBox(
        //                       width: 20,
        //                     ),
        //                     Icon(
        //                       SimpleLineIcons.logout,
        //                       color: AppColors.primary1,
        //                       size: 17,
        //                     ),
        //                     SizedBox(
        //                       width: 20,
        //                     ),
        //                     TextWidget(
        //                       text: 'Log Out',
        //                       fontSize: 15,
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             SizedBox(
        //               height: 30,
        //             ),
        //           ],
        //         ),
        //       )
        //     : Container(
        //         color: Colors.white,
        //         width: width - 150,
        //         child: Padding(
        //           padding: const EdgeInsets.all(18.0),
        //           child: Column(
        //             children: [
        //               const SizedBox(
        //                 height: 40,
        //               ),
        //               Row(
        //                 children: [
        //                   Icon(
        //                     Ionicons.ios_home_outline,
        //                     color: AppColors.primary1,
        //                     size: 19,
        //                   ),
        //                   SizedBox(
        //                     width: 20,
        //                   ),
        //                   TextWidget(
        //                     text: 'Home',
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(
        //                 height: 20,
        //               ),
        //               Row(
        //                 children: [
        //                   Icon(
        //                     MaterialCommunityIcons.phone_message,
        //                     color: AppColors.primary1,
        //                     size: 19,
        //                   ),
        //                   SizedBox(
        //                     width: 20,
        //                   ),
        //                   TextWidget(
        //                     text: 'Contact Us',
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(
        //                 height: 20,
        //               ),
        //               Row(
        //                 children: [
        //                   Icon(
        //                     MaterialIcons.feedback,
        //                     color: AppColors.primary1,
        //                     size: 19,
        //                   ),
        //                   SizedBox(
        //                     width: 20,
        //                   ),
        //                   TextWidget(
        //                     text: 'Feedback',
        //                   ),
        //                 ],
        //               ),
        //               SizedBox(
        //                 height: 20,
        //               ),
        //               GestureDetector(
        //                 onTap: () {
        //                   Navigator.pop(context);
        //                   Get.to(LoginScreen());
        //                 },
        //                 child: Container(
        //                   color: Colors.white,
        //                   child: Row(
        //                     children: [
        //                       Icon(
        //                         FontAwesome.sign_in,
        //                         color: AppColors.primary1,
        //                         size: 19,
        //                       ),
        //                       SizedBox(
        //                         width: 20,
        //                       ),
        //                       TextWidget(
        //                         text: 'Sign In',
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        body: SafeArea(
            child: IndexedStack(
          index: mainController.currentIndex.value,
          children: List.generate(
              bottomTabs.length,
              (index) => Visibility(
                  visible: mainController.currentIndex.value == index,
                  child: bottomTabs[index])),
        )),
      ),
    );
  }
}
