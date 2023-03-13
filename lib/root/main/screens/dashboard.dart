import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/firebase/login_data.dart';
import 'package:eskan/root/main/controller/main_controller.dart';
import 'package:eskan/root/main/screens/explore_screen.dart';
import 'package:eskan/root/main/screens/favorites_screen.dart';
import 'package:eskan/root/main/screens/my_property_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../auth/screens/landing.dart';
import 'my_properties.dart';

class DashboardScreen extends StatefulWidget {
  bool goToSharedAdd;
  int initIndex;
  DashboardScreen({super.key, this.goToSharedAdd = false, this.initIndex = 0});
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  int currentIndex = 0;
  late TabController tabController;

  MainController mainController = Get.put(MainController());

  late var bottomTabs = [];

  @override
  void initState() {
    super.initState();
    mainController.currentIndex.value = widget.initIndex;
    print('initState bitch');

    bottomTabs = [
      ExploreScreen(goToSharedAdd: widget.goToSharedAdd),
      FavoritesScreen(),
      GetBuilder<UserDetail>(builder: (value) {
        return value.login ? MyPropertyScreen() : MyPropertiesScreen();
      }),
      // MyPropertiesScreen(),
      LandingScreen(),
    ];

    tabController = TabController(length: 13, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary1,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: SizedBox(
          height: 89,
          child: GetBuilder<UserDetail>(builder: (value) {
            return BottomNavigationBar(
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
              items: [
                BottomNavigationBarItem(
                    icon: Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Icon(Icons.search)),
                    label: 'Explore'),
                BottomNavigationBarItem(
                    icon: Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Icon(AntDesign.hearto)),
                    label: 'Favorites'),
                BottomNavigationBarItem(
                    icon: Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Icon(MaterialCommunityIcons.home_city)),
                    label: 'My Properties'),
                BottomNavigationBarItem(
                    icon: Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Icon(Ionicons.person_circle_outline)),
                    label: value.login
                        ? value.admin
                            ? 'Admin'
                            : value.name
                        : 'Login'),
              ],
              onTap: (index) {
                setState(() {
                  mainController.currentIndex.value = index;
                });
              },
            );
          }),
        ),
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

  getName(String name) {
    print("Length: ${name.split(' ')[0]}");
    String firstNameInitial =
        name.split(' ')[0].isNotEmpty ? name.split(' ')[0].substring(0, 1) : '';
    String lastNameInitial =
        name.split(' ').length > 1 ? name.split(' ')[1].substring(0, 1) : '';

    // ignore: prefer_single_quotes
    return "$firstNameInitial$lastNameInitial";
  }
}
