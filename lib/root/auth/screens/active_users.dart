import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eskan/repository/data_repository.dart';
import 'package:eskan/root/main/controller/main_controller.dart';
import 'package:eskan/root/main/service/services.dart';
import 'package:eskan/widget/button_widget/enable_button.dart';
import 'package:eskan/widget/button_widget/register_button.dart';
import 'package:eskan/widget/input_widget/description_widget.dart';
import 'package:eskan/widget/input_widget/search_widget.dart';
import 'package:eskan/widget/input_widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../widget/design_util.dart';

class ActiveUsersScreen extends StatefulWidget {
  @override
  _ActiveUsersScreenState createState() => _ActiveUsersScreenState();
}

class _ActiveUsersScreenState extends State<ActiveUsersScreen> {
  MainController mainController =
      Get.put(MainController(mService: MainService()));
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  GlobalKey<ScaffoldState>? globalKey = GlobalKey();

  var db = FirebaseFirestore.instance;
  var commentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainController.isApiDataFetched.value = false;
    final DataRepository repository = DataRepository();
    repository.getAllUsers(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: UiUtils.getDeviceBasedPadding(20, 0, 10, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: 'Enable/Disable Users',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SearchWidget(
                    onChanged: (val) {
                      if (val.isEmpty) {
                        mainController.filteredAllUsers =
                            List.from(mainController.allUsers);
                      } else {
                        mainController.filteredAllUsers = mainController
                            .allUsers
                            .where((element) => element.fullName
                                .toString()
                                .toLowerCase()
                                .contains(val.toLowerCase()))
                            .toList();
                      }

                      mainController.update();
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GetBuilder<MainController>(
                    builder: (logic) {
                      // print(
                      //     'Len: ${mainController.properties.value.properties[2].propertyImages.length}');
                      return ListView.builder(
                        itemCount: mainController.isApiDataFetched.value
                            ? mainController.filteredAllUsers.length
                            : 0,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          print('again');
                          return Padding(
                            padding:
                                UiUtils.getDeviceBasedPadding(10, 10, 10, 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextWidget(
                                            text:
                                                'Name: ${mainController.filteredAllUsers[index].fullName}',
                                            fontSize: 13,
                                          ),
                                          TextWidget(
                                            text:
                                                "Phone No: ${mainController.filteredAllUsers[index].phoneNumber}",
                                            fontSize: 13,
                                          ),
                                          TextWidget(
                                            text:
                                                "Account Type: ${mainController.filteredAllUsers[index].userType == 0 ? "Individual" : "Business"}",
                                            fontSize: 13,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: EnableButtonWidget(
                                        buttonText: mainController
                                                .filteredAllUsers[index]
                                                .enabledUser
                                            ? 'Disable User'
                                            : 'Enable User',
                                        fontSize: 11,
                                        onPressed: () {
                                          if (mainController
                                              .filteredAllUsers[index]
                                              .enabledUser) {
                                            //User enabled
                                            showDialog(
                                                useRootNavigator: false,
                                                context: context,
                                                useSafeArea: true,
                                                barrierDismissible: true,
                                                barrierColor:
                                                    Colors.transparent,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    elevation: 0,
                                                    insetPadding:
                                                        EdgeInsets.all(0),
                                                    backgroundColor:
                                                        Colors.black54,
                                                    child: Padding(
                                                      padding: UiUtils
                                                          .getDeviceBasedPadding(
                                                              30, 0, 30, 0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    15),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: UiUtils
                                                                  .getBoxShadow(
                                                                      offset:
                                                                          10,
                                                                      blurRadius:
                                                                          16,
                                                                      color: Colors
                                                                          .black12),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                GestureDetector(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Icon(
                                                                        Entypo
                                                                            .cross),
                                                                  ),
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Padding(
                                                                    padding: UiUtils
                                                                        .getDeviceBasedPadding(
                                                                            30,
                                                                            10,
                                                                            30,
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: <
                                                                          Widget>[
                                                                        SizedBox(
                                                                          height:
                                                                              UiUtils.getDeviceBasedHeight(13),
                                                                        ),
                                                                        UiUtils.getIcon(
                                                                            "redInfoIcon.svg"),
                                                                        SizedBox(
                                                                          height:
                                                                              UiUtils.getDeviceBasedHeight(20),
                                                                        ),
                                                                        Text(
                                                                          "Are you sure you want to disable this user?",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                UiUtils.getDeviceBasedFont(14),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              UiUtils.getDeviceBasedHeight(20),
                                                                        ),
                                                                        TextWidget(
                                                                          fontSize:
                                                                              14,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          text:
                                                                              'Kindly add a comment for disabling this user!',
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              UiUtils.getDeviceBasedHeight(20),
                                                                        ),
                                                                        DescriptionWidget(
                                                                          controller:
                                                                              commentController,
                                                                          onChanged:
                                                                              (value) {},
                                                                          hint:
                                                                              'Add a comment',
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              UiUtils.getDeviceBasedHeight(20),
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            ButtonWidget(
                                                                              buttonText: mainController.filteredAllUsers[index].enabledUser ? 'Disable User' : 'Enable User',
                                                                              onPressed: () async {
                                                                                DataRepository dataRepository = DataRepository();

                                                                                await dataRepository.disableUser(context, mainController.filteredAllUsers[index], commentController.text);

                                                                                setState(() {
                                                                                  mainController.filteredAllUsers[index].enabledUser = false;
                                                                                });

                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              UiUtils.getDeviceBasedHeight(10),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          } else {
                                            //User disabled
                                            showDialog(
                                                useRootNavigator: false,
                                                context: context,
                                                useSafeArea: true,
                                                barrierDismissible: true,
                                                barrierColor:
                                                    Colors.transparent,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    elevation: 0,
                                                    insetPadding:
                                                        EdgeInsets.all(0),
                                                    backgroundColor:
                                                        Colors.black54,
                                                    child: Padding(
                                                      padding: UiUtils
                                                          .getDeviceBasedPadding(
                                                              30, 0, 30, 0),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    15),
                                                              ),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: UiUtils
                                                                  .getBoxShadow(
                                                                      offset:
                                                                          10,
                                                                      blurRadius:
                                                                          16,
                                                                      color: Colors
                                                                          .black12),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                GestureDetector(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Icon(
                                                                        Entypo
                                                                            .cross),
                                                                  ),
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Padding(
                                                                    padding: UiUtils
                                                                        .getDeviceBasedPadding(
                                                                            30,
                                                                            10,
                                                                            30,
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: <
                                                                          Widget>[
                                                                        SizedBox(
                                                                          height:
                                                                              UiUtils.getDeviceBasedHeight(13),
                                                                        ),
                                                                        UiUtils.getIcon(
                                                                            "redInfoIcon.svg"),
                                                                        SizedBox(
                                                                          height:
                                                                              UiUtils.getDeviceBasedHeight(20),
                                                                        ),
                                                                        Text(
                                                                          "Are you sure you want to enable this user?",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                UiUtils.getDeviceBasedFont(14),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              UiUtils.getDeviceBasedHeight(20),
                                                                        ),
                                                                        TextWidget(
                                                                          fontSize:
                                                                              14,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          text:
                                                                              'Kindly add a comment for enabling this user!',
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              UiUtils.getDeviceBasedHeight(20),
                                                                        ),
                                                                        DescriptionWidget(
                                                                          controller:
                                                                              commentController,
                                                                          onChanged:
                                                                              (value) {},
                                                                          hint:
                                                                              'Add a comment',
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              UiUtils.getDeviceBasedHeight(20),
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            ButtonWidget(
                                                                              buttonText: mainController.filteredAllUsers[index].enabledUser ? 'Disable User' : 'Enable User',
                                                                              onPressed: () async {
                                                                                //changedAd = true;
                                                                                DataRepository dataRepository = DataRepository();

                                                                                await dataRepository.enableUser(context, mainController.filteredAllUsers[index], commentController.text);

                                                                                setState(() {
                                                                                  mainController.filteredAllUsers[index].enabledUser = true;
                                                                                });

                                                                                Navigator.pop(context);
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              UiUtils.getDeviceBasedHeight(10),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Divider(
                                  height: 2,
                                  thickness: 1,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
