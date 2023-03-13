import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/root/main/controller/main_controller.dart';
import 'package:eskan/root/main/screens/approved_property_details.dart';
import 'package:eskan/root/main/service/services.dart';
import 'package:eskan/widget/input_widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../repository/data_repository.dart';
import '../../../widget/design_util.dart';

class ApprovedExploreScreen extends StatefulWidget {
  @override
  _ApprovedExploreScreenState createState() => _ApprovedExploreScreenState();
}

class _ApprovedExploreScreenState extends State<ApprovedExploreScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  GlobalKey<ScaffoldState>? globalKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  int currentIndex = 0;
  late TabController tabController;

  MainController mainController =
      Get.put(MainController(mService: MainService()));

  var scrollController = ScrollController();

  late String propertyType;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(pagination);
    tabController = TabController(length: 13, vsync: this);

    getApprovedProperties();
  }

  Future<void> getApprovedProperties(
      {bool goToSharedAdd = false, bool showLoading = true}) async {
    final DataRepository repository = DataRepository();
    await repository.getAllApprovedProperties(
      context,
      mainController,
      showLoading: showLoading,
    );

    print('KILLME');
  }

  Future<void> updateProperties(String propertyType,
      {bool showLoading = true}) async {
    final DataRepository repository = DataRepository();
    // await repository.paginateAllProperties(context, propertyType,
    //     showLoading: showLoading);

    print('KILLME');
  }

  void pagination() {
    if ((scrollController.position.pixels ==
        scrollController.position.maxScrollExtent)) {
      Future.delayed(Duration.zero, () {
        setState(() {
          //updateProperties(propertyType);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary1,
      ),
      child: Scaffold(
        key: globalKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: scrollController,
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: UiUtils.getDeviceBasedPadding(20, 20, 0, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: 'Approved Properties',
                      fontSize: 20,
                    ),
                    Padding(
                      padding: UiUtils.getDeviceBasedPadding(0, 20, 20, 0),
                      child: GetBuilder<MainController>(
                        assignId: false,
                        builder: (logic) {
                          return ListView.builder(
                              itemCount:
                                  mainController.approvedProperties.length,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                print('again');
                                return Padding(
                                  padding: UiUtils.getDeviceBasedPadding(
                                      0, 10, 0, 30),
                                  child: GestureDetector(
                                    onTap: () async {
                                      final result = await Get.to(() =>
                                          ApprovedPropertyDetailsScreen(
                                              propertyModel: mainController
                                                  .approvedProperties[index]));
                                      if (result != null && result) {
                                        final DataRepository repository =
                                            DataRepository();
                                        print('getting more properties');
                                        // ignore: use_build_context_synchronously
                                        await repository
                                            .getAllApprovedProperties(
                                                context, mainController);
                                        print(mainController
                                            .properties.properties.length);

                                        mainController.hasDataCome.value = true;

                                        mainController.update();
                                      }
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              CarouselSlider(
                                                options: CarouselOptions(
                                                    height: 300.0,
                                                    autoPlay: false,
                                                    autoPlayInterval:
                                                        Duration(seconds: 2),
                                                    enableInfiniteScroll: false,
                                                    aspectRatio: 20,
                                                    viewportFraction: 1,
                                                    onPageChanged:
                                                        (index2, ssd) {
                                                      mainController
                                                          .approvedProperties[
                                                              index]
                                                          .currentIndex = index2;
                                                      mainController.update();
                                                    }),
                                                items:
                                                    mainController
                                                            .approvedProperties
                                                            .isNotEmpty
                                                        ? mainController
                                                            .approvedProperties[
                                                                index]
                                                            .propertyImages
                                                            .map((i) {
                                                            return Builder(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          20),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          10),
                                                                    ),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl: i ??
                                                                          'https://i.pinimg.com/originals/ca/b9/7f/cab97fad1ae18490cb0b0c3aace95983.jpg',
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          300,
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              Center(
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          child:
                                                                              CircularProgressIndicator(strokeWidth: 1),
                                                                        ),
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Icon(Icons
                                                                              .error),
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          }).toList()
                                                        : [],
                                              ),
                                              // if (CacheManager().phoneNumber !=
                                              //     '11223344')
                                              //   Positioned(
                                              //     top: 10.0,
                                              //     right: 10.0,
                                              //     child: GestureDetector(
                                              //       onTap: () {
                                              //         Navigator.pop(context);
                                              //       },
                                              //       child: ClipRRect(
                                              //         borderRadius:
                                              //             BorderRadius.all(
                                              //           Radius.circular(40),
                                              //         ),
                                              //         child: GestureDetector(
                                              //           onTap: () {
                                              //             if (CacheManager()
                                              //                 .phoneNumber
                                              //                 .isEmpty) {
                                              //               Get.to(
                                              //                   LoginScreen());
                                              //             } else {
                                              //               mainController
                                              //                       .approvedProperties[
                                              //                           index]
                                              //                       .favorite =
                                              //                   !mainController
                                              //                       .approvedProperties[
                                              //                           index]
                                              //                       .favorite;

                                              //               DataRepository
                                              //                   repository =
                                              //                   DataRepository();
                                              //               repository.addFavorite(
                                              //                   context,
                                              //                   mainController
                                              //                           .approvedProperties[
                                              //                       index]);

                                              //               mainController
                                              //                   .update();
                                              //             }
                                              //           },
                                              //           child: Container(
                                              //             padding: UiUtils
                                              //                 .getDeviceBasedPadding(
                                              //                     10,
                                              //                     10,
                                              //                     10,
                                              //                     10),
                                              //             color: Colors
                                              //                 .grey.shade300,
                                              //             child: Icon(
                                              //               AntDesign.hearto,
                                              //               size: 18,
                                              //               color: CacheManager()
                                              //                           .userEmail
                                              //                           .isNotEmpty &&
                                              //                       mainController
                                              //                           .approvedProperties[
                                              //                               index]
                                              //                           .favorite
                                              //                   ? Colors.red
                                              //                   : Colors.black,
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              Positioned(
                                                bottom: 0.0,
                                                left: 0.0,
                                                right: 0.0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: mainController
                                                          .approvedProperties
                                                          .isNotEmpty
                                                      ? mainController
                                                          .approvedProperties[
                                                              index]
                                                          .propertyImages
                                                          .map(
                                                          (image) {
                                                            int index1 = mainController
                                                                .approvedProperties[
                                                                    index]
                                                                .propertyImages
                                                                .indexOf(image);
                                                            print(
                                                                'index1: $index1');
                                                            return Container(
                                                              width: 8.0,
                                                              height: 8.0,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10.0,
                                                                      horizontal:
                                                                          2.0),
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: mainController
                                                                              .approvedProperties[
                                                                                  index]
                                                                              .currentIndex ==
                                                                          index1
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .grey),
                                                            );
                                                          },
                                                        ).toList()
                                                      : [], //
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: mainController
                                                    .approvedProperties
                                                    .isNotEmpty
                                                ? mainController
                                                    .approvedProperties[index]
                                                    .adTitle
                                                : '',
                                            fontSize: 18,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          TextWidget(
                                            text: mainController
                                                    .approvedProperties
                                                    .isNotEmpty
                                                ? mainController
                                                    .approvedProperties[index]
                                                    .propertyLocation
                                                : '',
                                            color: Colors.grey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: mainController
                                                    .approvedProperties
                                                    .isNotEmpty
                                                ? "${mainController.approvedProperties[index].price} QAR"
                                                : '',
                                            color: AppColors.primary1,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getPropertyCount(String propertyType) {
    print('propertyType: $propertyType');
    int count = 0;
    mainController.allProperties.forEach((element) {
      if (element.apartmentType == propertyType) {
        count += 1;
      }
    });

    print('count: ${count.toString()}');

    return count.toString();
  }
}

class PropertyTypeEntry extends StatelessWidget {
  String label;
  IconData iconData;
  final GestureTapCallback? onTap;

  PropertyTypeEntry({required this.label, required this.iconData, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UiUtils.getDeviceBasedPadding(10, 10, 10, 10),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(iconData),
            SizedBox(
              height: 10,
            ),
            TextWidget(
              text: label,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
