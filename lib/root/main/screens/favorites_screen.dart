import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/firebase/login_data.dart';
import 'package:eskan/root/auth/screens/login.dart';
import 'package:eskan/root/main/controller/main_controller.dart';
import 'package:eskan/root/main/model/property_model.dart';
import 'package:eskan/root/main/screens/property_details.dart';
import 'package:eskan/root/main/service/services.dart';
import 'package:eskan/widget/input_widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../repository/data_repository.dart';
import '../../../widget/button_widget/main_color_button.dart';
import '../../../widget/design_util.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  MainController mainController =
      Get.put(MainController(mService: MainService()));
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  GlobalKey<ScaffoldState>? globalKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  late PropertyModel propertyModel;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (Get.find<UserDetail>().login) {
      mainController.properties.properties.clear();
      final DataRepository repository = DataRepository();
      repository.getMyFavoriteProperties(context, mainController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: GetBuilder<UserDetail>(builder: (value) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: UiUtils.getDeviceBasedPadding(20, 20, 20, 20),
                child: !value.login
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: 'Favorites',
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          TextWidget(
                            text: 'Log in to view your favorites',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextWidget(
                            text:
                                'You can see your favorites once you have logged in.',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          MainColorButton(
                              buttonText: 'Log in',
                              onPressed: () {
                                Get.to(LoginScreen());
                              }),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: 'Your Favorites',
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          GetBuilder<MainController>(
                            builder: (logic) {
                              print(
                                  'Len: ${mainController.properties.properties.length}');
                              return ListView.builder(
                                  itemCount: mainController.hasDataCome.value
                                      ? mainController
                                          .properties.properties.length
                                      : 0,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    print('again');
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(PropertyDetailsScreen(
                                          propertyModel: mainController
                                              .properties.properties[index],
                                        ));
                                      },
                                      child: Padding(
                                        padding: UiUtils.getDeviceBasedPadding(
                                            0, 10, 0, 30),
                                        child: GestureDetector(
                                          onTap: () async {
                                            var result = await Get.to(
                                                PropertyDetailsScreen(
                                                    propertyModel:
                                                        mainController
                                                                .properties
                                                                .properties[
                                                            index]));

                                            if (result != null && result) {
                                              //getProperties();
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
                                                              Duration(
                                                                  seconds: 2),
                                                          enableInfiniteScroll:
                                                              false,
                                                          aspectRatio: 20,
                                                          viewportFraction: 1,
                                                          onPageChanged:
                                                              (index2, ssd) {
                                                            mainController
                                                                    .properties
                                                                    .properties[
                                                                        index]
                                                                    .currentIndex =
                                                                index2;
                                                            mainController
                                                                .update();
                                                          }),
                                                      items: mainController
                                                              .properties
                                                              .properties
                                                              .isNotEmpty
                                                          ? mainController
                                                              .properties
                                                              .properties[index]
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
                                                                        imageUrl:
                                                                            i ??
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
                                                                            new Icon(Icons.error),
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
                                                    Positioned(
                                                      top: 10.0,
                                                      right: 10.0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(40),
                                                          ),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              mainController
                                                                  .properties
                                                                  .properties[
                                                                      index]
                                                                  .favorite = false;
                                                              mainController
                                                                  .update();

                                                              DataRepository
                                                                  repository =
                                                                  DataRepository();
                                                              repository
                                                                  .removeFavorite(
                                                                      context,
                                                                      mainController
                                                                          .properties
                                                                          .properties[index],
                                                                      mainController)
                                                                  .then((value) {
                                                                mainController
                                                                    .properties
                                                                    .properties
                                                                    .removeWhere((element) =>
                                                                        element
                                                                            .docId ==
                                                                        mainController
                                                                            .properties
                                                                            .properties[index]
                                                                            .docId);
                                                              });

                                                              mainController
                                                                  .update();
                                                            },
                                                            child: Container(
                                                              padding: UiUtils
                                                                  .getDeviceBasedPadding(
                                                                      10,
                                                                      10,
                                                                      10,
                                                                      10),
                                                              color: Colors.grey
                                                                  .shade300,
                                                              child: Icon(
                                                                AntDesign
                                                                    .hearto,
                                                                size: 18,
                                                                color: mainController
                                                                        .properties
                                                                        .properties[
                                                                            index]
                                                                        .favorite
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 0.0,
                                                      left: 0.0,
                                                      right: 0.0,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: mainController
                                                                .properties
                                                                .properties
                                                                .isNotEmpty
                                                            ? mainController
                                                                .properties
                                                                .properties[
                                                                    index]
                                                                .propertyImages
                                                                .map(
                                                                (image) {
                                                                  int index1 = mainController
                                                                      .properties
                                                                      .properties[
                                                                          index]
                                                                      .propertyImages
                                                                      .indexOf(
                                                                          image);
                                                                  print(
                                                                      'index1: $index1');
                                                                  return Container(
                                                                    width: 8.0,
                                                                    height: 8.0,
                                                                    margin: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            10.0,
                                                                        horizontal:
                                                                            2.0),
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: mainController.properties.properties[index].currentIndex ==
                                                                                index1
                                                                            ? Colors.white
                                                                            : Colors.grey),
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
                                                          .properties
                                                          .properties
                                                          .isNotEmpty
                                                      ? mainController
                                                          .properties
                                                          .properties[index]
                                                          .adTitle
                                                      : '',
                                                  fontSize: 18,
                                                ),
                                                TextWidget(
                                                  text: mainController
                                                          .properties
                                                          .properties
                                                          .isNotEmpty
                                                      ? mainController
                                                          .properties
                                                          .properties[index]
                                                          .propertyLocation
                                                      : '',
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                TextWidget(
                                                  text: mainController
                                                          .properties
                                                          .properties
                                                          .isNotEmpty
                                                      ? "${mainController.properties.properties[index].price} QAR"
                                                      : '',
                                                  color: AppColors.primary1,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
