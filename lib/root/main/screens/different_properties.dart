import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/root/main/controller/main_controller.dart';
import 'package:eskan/root/main/model/property_model.dart';
import 'package:eskan/root/main/screens/property_details.dart';
import 'package:eskan/root/main/service/services.dart';
import 'package:eskan/widget/input_widget/input_widget.dart';
import 'package:eskan/widget/input_widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../widget/design_util.dart';

class DifferentPropertiesScreen extends StatefulWidget {
  String propertyType;
  List<PropertyModel> properties = [];

  DifferentPropertiesScreen(
      {required this.propertyType, required this.properties});

  @override
  _DifferentPropertiesScreenState createState() =>
      _DifferentPropertiesScreenState();
}

class _DifferentPropertiesScreenState extends State<DifferentPropertiesScreen> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainController.hasDataCome.value = false;
    mainController.differentProperties = widget.properties;
    mainController.filteredDifferentProperties = widget.properties;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Container(
          padding: UiUtils.getDeviceBasedPadding(20, 50, 20, 20),
          color: AppColors.primary1,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  height: 45,
                  padding: UiUtils.getDeviceBasedPadding(15, 0, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        SimpleLineIcons.magnifier,
                        size: 17,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: InputWidget(
                          hint: 'Search in ${widget.propertyType}',
                          underLine: false,
                          textSize: 14,
                          hintFontSize: 14,
                          hintColor: Colors.black,
                          onChanged: (val) {
                            print("Val: $val");
                            if (val.isEmpty) {
                              mainController.filteredDifferentProperties =
                                  mainController.differentProperties;
                            } else {
                              mainController.filteredDifferentProperties =
                                  mainController.differentProperties
                                      .where((element) =>
                                          element.adTitle
                                              .toString()
                                              .toLowerCase()
                                              .contains(val.toLowerCase()) ||
                                          element.price.contains(val) ||
                                          element.propertyLocation
                                              .toString()
                                              .toLowerCase()
                                              .contains(val.toLowerCase()) ||
                                          element.postedBy
                                              .toString()
                                              .toLowerCase()
                                              .contains(val.toLowerCase()))
                                      .toList();
                            }

                            mainController.update();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: UiUtils.getDeviceBasedPadding(10, 0, 10, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GetBuilder<MainController>(
                        assignId: false,
                        builder: (logic) {
                          return TextWidget(
                            text:
                                'Results ${mainController.filteredDifferentProperties.length}',
                            fontSize: 16,
                          );
                        },
                      ),
                      Spacer(),
                      Icon(
                        Icons.apps_outlined,
                        color: AppColors.primary1,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        AntDesign.filter,
                        color: AppColors.primary1,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        FontAwesome.sort,
                        color: AppColors.primary1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GetBuilder<MainController>(
                    assignId: false,
                    builder: (logic) {
                      return ListView.builder(
                          itemCount:
                              mainController.filteredDifferentProperties.length,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            print('again');
                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  PropertyDetailsScreen(
                                      propertyModel: mainController
                                          .filteredDifferentProperties[index]),
                                );
                              },
                              child: DifferentProperty(
                                price: mainController
                                    .filteredDifferentProperties[index].price,
                                adTitle: mainController
                                    .filteredDifferentProperties[index].adTitle,
                                image: mainController
                                    .filteredDifferentProperties[index]
                                    .propertyImages[0],
                                location: mainController
                                    .filteredDifferentProperties[index]
                                    .propertyLocation,
                                postedBy: mainController
                                    .filteredDifferentProperties[index]
                                    .postedBy,
                              ),
                            );
                          });
                    },
                  ),
                  SizedBox(
                    height: 20,
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

class DifferentProperty extends StatelessWidget {
  String adTitle;
  String price;
  String? image;
  String location;
  String postedBy;

  DifferentProperty(
      {required this.adTitle,
      required this.price,
      required this.image,
      required this.location,
      required this.postedBy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UiUtils.getDeviceBasedPadding(0, 20, 0, 0),
      child: Material(
        elevation: 5,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: image ??
                        'https://i.pinimg.com/originals/ca/b9/7f/cab97fad1ae18490cb0b0c3aace95983.jpg',
                    width: double.infinity,
                    height: 150,
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 1),
                      ),
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: UiUtils.getDeviceBasedPadding(10, 10, 8, 8),
                        child: TextWidget(
                          text: adTitle,
                          fontSize: 14,
                          maxLines: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: UiUtils.getDeviceBasedPadding(10, 30, 8, 8),
                        child: Text.rich(TextSpan(
                            text: "$price QAR",
                            style: TextStyle(
                              fontSize: 14,
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
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  UiUtils.getDeviceBasedPadding(10, 7, 8, 0),
                              child: TextWidget(
                                text: location,
                                fontSize: 11,
                                maxLines: 1,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding:
                                  UiUtils.getDeviceBasedPadding(10, 0, 8, 6),
                              child: TextWidget(
                                text: postedBy,
                                maxLines: 1,
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
