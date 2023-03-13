import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/root/main/controller/main_controller.dart';
import 'package:eskan/root/main/model/property_model.dart';
import 'package:eskan/root/main/service/services.dart';
import 'package:eskan/widget/button_widget/register_button.dart';
import 'package:eskan/widget/input_widget/text_widget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../cache/cache_manager.dart';
import '../../../repository/data_repository.dart';
import '../../../widget/design_util.dart';

class PendingPropertyDetailsScreen extends StatefulWidget {
  PropertyModel propertyModel;
  bool myOwnProperty;

  PendingPropertyDetailsScreen(
      {required this.propertyModel, this.myOwnProperty = false});
  @override
  _PendingPropertyDetailsScreenState createState() =>
      _PendingPropertyDetailsScreenState();
}

class _PendingPropertyDetailsScreenState
    extends State<PendingPropertyDetailsScreen> {
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

  PageController _controller = PageController(
    initialPage: 0,
  );

  bool changedAd = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("initState bitch");
    propertyModel = widget.propertyModel;
    print("Ad enable: ${propertyModel.id}");

    print('COUNT: ${propertyModel.viewCount}');

    updateCount();
  }

  Future<void> updateCount() async {
    int count = propertyModel.viewCount;
    count = count + 1;
    DataRepository dataRepository = DataRepository();
    if (CacheManager().loggedIn == true &&
        CacheManager().phoneNumber != propertyModel.phoneNumber) {
      await dataRepository.updateAdCount(
        context,
        propertyModel,
        propertyModel.apartmentType,
        count,
      );
    }
  }

  var commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: globalKey,
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          padding: UiUtils.getDeviceBasedPadding(20, 20, 20, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ButtonWidget(
                buttonText: 'Approve Ad',
                onPressed: () async {
                  changedAd = true;
                  DataRepository dataRepository = DataRepository();

                  await dataRepository.approved(context, propertyModel,
                      propertyModel.apartmentType, commentController.text);
                  Get.back();
                  mainController.pendingProperties.removeWhere(
                    (element) => element.docId == propertyModel.docId,
                  );
                  mainController.update();
                  setState(() {
                    propertyModel.adEnabled = true;
                  });
                },
              ),
            ],
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                            autoPlay: false,
                            autoPlayInterval: Duration(seconds: 2),
                            enableInfiniteScroll: false,
                            aspectRatio: 1 / 0.99999,
                            viewportFraction: 1,
                            onPageChanged: (index, ssd) {
                              setState(() {
                                currentIndex = index;
                              });
                            }),
                        items: propertyModel.propertyImages.map((i) {
                          //_controller.jumpTo(currentIndex.toDouble());
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  //Get.to(GalleryScreen());
                                  _controller =
                                      PageController(initialPage: currentIndex);
                                  showDialog(
                                      useRootNavigator: false,
                                      context: context,
                                      barrierDismissible: true,
                                      barrierColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Dialog(
                                            elevation: 0,
                                            insetPadding: EdgeInsets.all(0),
                                            backgroundColor: Colors.black,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Padding(
                                                padding: UiUtils
                                                    .getDeviceBasedPadding(
                                                        0, 0, 0, 0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        height: 300,
                                                        child: PageView.builder(
                                                            controller:
                                                                _controller,
                                                            allowImplicitScrolling:
                                                                true,
                                                            itemBuilder: (context,
                                                                pagePosition) {
                                                              return Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: UiUtils.getBoxShadow(
                                                                      offset:
                                                                          10,
                                                                      blurRadius:
                                                                          16,
                                                                      color: Colors
                                                                          .black12),
                                                                ),
                                                                child: SizedBox(
                                                                  height: 550,
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: propertyModel.propertyImages[pagePosition %
                                                                        propertyModel
                                                                            .propertyImages
                                                                            .length],
                                                                    height: 550,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: CachedNetworkImage(
                                  imageUrl: i ??
                                      'https://i.pinimg.com/originals/ca/b9/7f/cab97fad1ae18490cb0b0c3aace95983.jpg',
                                  width: double.infinity,
                                  placeholder: (context, url) => Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 1),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Positioned(
                        top: 10.0,
                        left: 10.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            child: Container(
                              padding:
                                  UiUtils.getDeviceBasedPadding(10, 10, 10, 10),
                              color: Colors.grey.shade300,
                              child: Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10.0,
                        right: 10.0,
                        child: GestureDetector(
                          onTap: () async {
                            String link = await createDynamicLink(
                                propertyModel.apartmentType,
                                propertyModel.id.toString());
                            await FlutterShare.share(
                              title: 'Share Ad',
                              text: link,
                            );

                            print("LINK: $link");
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            child: Container(
                              padding:
                                  UiUtils.getDeviceBasedPadding(10, 10, 10, 10),
                              color: Colors.grey.shade300,
                              child: Icon(
                                Icons.share,
                                size: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // if (CacheManager().userEmail != 'admin@gmail.com')
                      //   Positioned(
                      //     top: 10.0,
                      //     right: 10.0,
                      //     child: GestureDetector(
                      //       onTap: () {
                      //         if (CacheManager().userEmail.isEmpty) {
                      //           Get.to(LoginScreen());
                      //         } else {
                      //           mainController
                      //                   .filteredAllProperties[index].favorite =
                      //               !mainController
                      //                   .filteredAllProperties[index].favorite;
                      //
                      //           DataRepository repository = DataRepository();
                      //           repository.addFavorite(
                      //               context,
                      //               mainController
                      //                   .filteredAllProperties[index]);
                      //
                      //           mainController.update();
                      //         }
                      //       },
                      //       child: ClipRRect(
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(40)),
                      //         child: Container(
                      //           padding: UiUtils.getDeviceBasedPadding(
                      //               10, 10, 10, 10),
                      //           color: Colors.grey.shade300,
                      //           child: Icon(
                      //             AntDesign.hearto,
                      //             size: 18,
                      //             color: Colors.black,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: propertyModel.propertyImages.map(
                            (image) {
                              int index =
                                  propertyModel.propertyImages.indexOf(image);
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentIndex == index
                                        ? Colors.white
                                        : Colors.grey),
                              );
                            },
                          ).toList(), //
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: UiUtils.getDeviceBasedPadding(15, 30, 15, 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: propertyModel.adTitle,
                          fontSize: 18,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text.rich(TextSpan(
                            text: "${propertyModel.price} QAR",
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.primary1,
                              fontWeight: FontWeight.w900,
                            ),
                            children: const <InlineSpan>[
                              TextSpan(
                                text: '/ Month',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w300),
                              )
                            ])),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            TextWidget(
                              text: propertyModel.propertyLocation,
                              fontSize: 13,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextWidget(
                          text: 'Apartment Details',
                          fontSize: 16,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: UiUtils.getDeviceBasedPadding(10, 10, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: 'Apartment Type'.toUpperCase(),
                                    fontSize: 13,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: propertyModel.apartmentType,
                                    fontSize: 13,
                                    maxLines: 1,
                                    color: AppColors.primary1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: UiUtils.getDeviceBasedPadding(10, 10, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: 'Property Furnish'.toUpperCase(),
                                    fontSize: 13,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: propertyModel.propertyFurnish,
                                    fontSize: 13,
                                    maxLines: 1,
                                    color: AppColors.primary1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: UiUtils.getDeviceBasedPadding(10, 10, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: 'Property Bedrooms'.toUpperCase(),
                                    fontSize: 13,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: propertyModel.propertyBedrooms,
                                    fontSize: 13,
                                    color: AppColors.primary1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: UiUtils.getDeviceBasedPadding(10, 10, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: 'Property Bathrooms'.toUpperCase(),
                                    fontSize: 13,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: propertyModel.propertyBathrooms,
                                    fontSize: 13,
                                    color: AppColors.primary1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: UiUtils.getDeviceBasedPadding(10, 10, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: 'Deposit'.toUpperCase(),
                                    fontSize: 13,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: propertyModel.depositDropDown,
                                    fontSize: 13,
                                    color: AppColors.primary1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: UiUtils.getDeviceBasedPadding(10, 10, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: 'Commission'.toUpperCase(),
                                    fontSize: 13,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: propertyModel.commission,
                                    fontSize: 13,
                                    color: AppColors.primary1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: UiUtils.getDeviceBasedPadding(10, 10, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: 'Rental Period'.toUpperCase(),
                                    fontSize: 13,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: propertyModel.rentalPeriod,
                                    fontSize: 13,
                                    color: AppColors.primary1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: UiUtils.getDeviceBasedPadding(10, 10, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: 'Contract Duration'.toUpperCase(),
                                    fontSize: 13,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: TextWidget(
                                    text: propertyModel.contractDuration,
                                    fontSize: 13,
                                    color: AppColors.primary1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextWidget(
                          text: 'Features',
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        if (propertyModel.immunities.acWindow)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    AntDesign.checkcircleo,
                                    color: AppColors.primary1,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      TextWidget(
                                        text: 'Ac Window',
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        if (propertyModel.immunities.acSplit)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    AntDesign.checkcircleo,
                                    color: AppColors.primary1,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      TextWidget(
                                        text: 'AC Split',
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        if (propertyModel.immunities.gardenView)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    AntDesign.checkcircleo,
                                    color: AppColors.primary1,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      TextWidget(
                                        text: 'Garden View',
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        if (propertyModel.immunities.kitchenOpen)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    AntDesign.checkcircleo,
                                    color: AppColors.primary1,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      TextWidget(
                                        text: 'Kitchen Open',
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        if (propertyModel.immunities.kitchenSeparate)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    AntDesign.checkcircleo,
                                    color: AppColors.primary1,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      TextWidget(
                                        text: 'Kitchen Separate',
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        if (propertyModel.immunities.maidRoom)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    AntDesign.checkcircleo,
                                    color: AppColors.primary1,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      TextWidget(
                                        text: 'Maid Room',
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        if (propertyModel.immunities.parking)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    AntDesign.checkcircleo,
                                    color: AppColors.primary1,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      TextWidget(
                                        text: 'Parking',
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        if (propertyModel.immunities.seaView)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    AntDesign.checkcircleo,
                                    color: AppColors.primary1,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      TextWidget(
                                        text: 'Sea View',
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        TextWidget(
                          text: 'Description',
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextWidget(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          text: propertyModel.adDescription,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  if (!widget.myOwnProperty)
                    Column(
                      children: [
                        Divider(
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: UiUtils.getDeviceBasedPadding(15, 0, 15, 30),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircleAvatar(
                                      foregroundImage:
                                          AssetImage('assets/svgs/avatar.webp'),
                                      radius: 50,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  TextWidget(
                                    text: 'Posted By',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  TextWidget(
                                    text: widget.propertyModel.postedBy.isEmpty
                                        ? 'Administrator'
                                        : widget.propertyModel.postedBy,
                                    fontSize: 13,
                                    color: AppColors.primary1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  var url = Uri.parse(
                                      'tel:+974${widget.propertyModel.phoneNumber}');
                                  if (await launchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      TextWidget(
                                        text: 'Phone No: ',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      TextWidget(
                                        text: widget.propertyModel.phoneNumber
                                                .isEmpty
                                            ? '0900-78601'
                                            : widget.propertyModel.phoneNumber,
                                        fontSize: 13,
                                        color: AppColors.primary1,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  TextWidget(
                                    text: 'Location: ',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  TextWidget(
                                    text: widget.propertyModel.location.isEmpty
                                        ? '27th Avenue Street, Doha'
                                        : widget.propertyModel.location,
                                    fontSize: 13,
                                    color: AppColors.primary1,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> createDynamicLink(String propertyType, String addId) async {
    var parameters = DynamicLinkParameters(
      uriPrefix: 'https://eskann.page.link',
      link: Uri.parse(
          'https://eskann.page.link.com/?propertyType=$propertyType&addId=$addId'),
      androidParameters: AndroidParameters(
        packageName: "com.example.eskan",
      ),
      iosParameters: IOSParameters(
          bundleId: "com.example.eskan",
          customScheme: "https://eskann.page.link",
          appStoreId: '232323'),
    );
    // var dynamicUrl = await parameters.link;
    // var shortLink = await parameters.buildShortLink();
    // var shortUrl = shortLink.shortUrl;

    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);

    return dynamicLink.shortUrl.toString();
  }

  Future<bool> _onWillPop() async {
    Get.back(result: changedAd);
    return false;
  }
}
