import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eskan/cache/cache_manager.dart';
import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/widget/input_widget/goat_input_widget.dart';
import 'package:eskan/widget/input_widget/text_widget.dart';
import 'package:eskan/widget/popup_widget/generic_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../widget/app_bar_widget/app_bar_widget.dart';
import '../../../widget/button_widget/register_button.dart';
import '../../../widget/design_util.dart';
import '../../../widget/dropdown_search_widget/dropdown_search_widget.dart';
import '../controller/auth_controller.dart';
import '../service/services.dart';

class IndividualSignupScreen extends StatefulWidget {
  @override
  _IndividualSignupScreenState createState() => _IndividualSignupScreenState();
}

class _IndividualSignupScreenState extends State<IndividualSignupScreen> {
  AuthController authController =
      Get.put(AuthController(aService: AuthService()));
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

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

    return await Geolocator.getCurrentPosition();
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    getAddressFromLatLong(position);
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    String address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    print('Address: $address');

    setState(() {
      locationController.text = address;
    });
  }

  @override
  void initState() {
    super.initState();
    authController.listOfQatarZones.sort();
    authController.filteredListOfQatarZones.sort();
    authController.selectedQatarZone.value = 'Select Location';
    authController.selectedQatarZoneError.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
        child: ButtonWidget(
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                authController.selectedQatarZone.value != 'Select Location') {
              CacheManager().registerModel.password = passwordController.text;
              CacheManager().registerModel.userType = 0;

              CacheManager().registerModel.email =
                  emailController.text.toLowerCase().trim();
              CacheManager().registerModel.fullName = nameController.text;
              CacheManager().registerModel.phoneNumber =
                  phoneController.text.replaceAll(RegExp(r'\s+'), '');
              CacheManager().registerModel.location =
                  authController.selectedQatarZone.value;

              print(
                  'Phone number: +974${CacheManager().registerModel.phoneNumber}');

              //authController.registerUser(context);
            } else if (authController.selectedQatarZone.value ==
                'Select Location') {
              authController.selectedQatarZoneError.value = true;
              authController.update();
            }

            if (_formKey.currentState!.validate()) {
              FirebaseFirestore.instance
                  .collection('user')
                  .where('phoneNumber',
                      isEqualTo: CacheManager().registerModel.phoneNumber)
                  .get()
                  .then(
                (value) async {
                  if (value.docs.isEmpty) {
                    authController.registerUser(context);
                  } else {
                    await GenericErrorDialog.show(
                        context, 'An account with this phone already exist');
                  }
                },
              );
              print('register user');
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
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
