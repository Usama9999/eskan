import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/widget/input_widget/goat_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../cache/cache_manager.dart';
import '../../../widget/app_bar_widget/app_bar_widget.dart';
import '../../../widget/button_widget/register_button.dart';
import '../../../widget/design_util.dart';
import '../../../widget/dropdown_search_widget/dropdown_search_widget.dart';
import '../../../widget/input_widget/text_widget.dart';
import '../controller/auth_controller.dart';
import '../service/services.dart';

class BusinessSignupScreen extends StatefulWidget {
  @override
  _BusinessSignupScreenState createState() => _BusinessSignupScreenState();
}

class _BusinessSignupScreenState extends State<BusinessSignupScreen> {
  AuthController authController =
      Get.put(AuthController(aService: AuthService()));
  TextEditingController nameController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    GetAddressFromLatLong(position);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    String address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    print("Address: $address");

    setState(() {
      locationController.text = address;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController.listOfQatarZones.sort();
    authController.filteredListOfQatarZones.sort();
    authController.selectedQatarZone.value = 'Select Location';
    authController.selectedQatarZoneError.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
        child: ButtonWidget(
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                authController.selectedQatarZone.value != 'Select Location') {
              print('register user');
              CacheManager().registerModel.password = passwordController.text;
              CacheManager().registerModel.userType = 1;

              CacheManager().registerModel.businessName =
                  businessNameController.text;

              CacheManager().registerModel.email =
                  emailController.text.toLowerCase().trim();
              CacheManager().registerModel.fullName = nameController.text;
              CacheManager().registerModel.phoneNumber =
                  phoneController.text.replaceAll(new RegExp(r'\s+'), "");
              CacheManager().registerModel.location =
                  authController.selectedQatarZone.value;

              authController.registerUser(context);

              // authController.registerUser(
              //     context,
              //     nameController.text,
              //     emailController.text,
              //     passwordController.text);
            } else if (authController.selectedQatarZone.value ==
                "Select Location") {
              authController.selectedQatarZoneError.value = true;
              authController.update();
            }
          },
        ),
      ),
      appBar: AppBarWidget(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
                        height: UiUtils.getDeviceBasedHeight(30),
                      ),
                      GoatInputWidget(
                        hint: 'Business Name',
                        controller: businessNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Full Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: UiUtils.getDeviceBasedHeight(20),
                      ),
                      GoatInputWidget(
                        hint: 'Full Name',
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Full Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: UiUtils.getDeviceBasedHeight(20),
                      ),
                      // GoatInputWidget(
                      //   hint: 'Email Address',
                      //   controller: emailController,
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please enter Email';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // SizedBox(
                      //   height: UiUtils.getDeviceBasedHeight(20),
                      // ),
                      // Obx(() {
                      //   return GoatInputWidget(
                      //     hint: 'Password',
                      //     passwordText: authController.passwordProtected.value,
                      //     maxLines: 1,
                      //     controller: passwordController,
                      //     suffixIcon: GestureDetector(
                      //       onTap: () {
                      //         authController.passwordProtected.value =
                      //             !authController.passwordProtected.value;
                      //         authController.update();
                      //       },
                      //       child: const Icon(
                      //         Icons.remove_red_eye_outlined,
                      //         color: Colors.white,
                      //         size: 22,
                      //       ),
                      //     ),
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Please enter Password';
                      //       }
                      //       return null;
                      //     },
                      //   );
                      // }),
                      // SizedBox(
                      //   height: UiUtils.getDeviceBasedHeight(20),
                      // ),
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
                              hint: "0000 0000",
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
                      Obx(() {
                        return DropDownSearchWidget(
                          error: authController.selectedQatarZoneError.value,
                          filteredList: authController.filteredListOfQatarZones,
                          color: jobDropDownColor,
                          selectedId: 0,
                          suffixIcon: AntDesign.down,
                          normalList: authController.listOfQatarZones,
                          selectedValue: authController.selectedQatarZone.value,
                          onChangeState: (value, id) {
                            authController.selectedQatarZone.value =
                                value.toString();
                            authController.selectedQatarZoneError.value = false;
                            // mainController.propertyRentalPeriodError.value =
                            // false;
                            authController.update();
                          },
                        );
                      }),
                      Obx(() {
                        return Visibility(
                          visible: authController.selectedQatarZoneError.value,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              TextWidget(
                                text: 'Select a location',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        );
                      }),
                      // GoatInputWidget(
                      //   hint: 'Location',
                      //   suffixIcon: GestureDetector(
                      //     onTap: () async {
                      //       await _determinePosition();
                      //       getLocation();
                      //     },
                      //     child: Container(
                      //       height: 50,
                      //       padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 0),
                      //       child: Icon(
                      //         Foundation.marker,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //   ),
                      //   controller: locationController,
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please enter Location';
                      //     }
                      //     return null;
                      //   },
                      // ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
