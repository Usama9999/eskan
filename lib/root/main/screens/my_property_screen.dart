import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/root/main/controller/main_controller.dart';
import 'package:eskan/root/main/screens/add_property.dart';
import 'package:eskan/root/main/screens/property_details.dart';
import 'package:eskan/root/main/service/services.dart';
import 'package:eskan/widget/app_bar_widget/my_app_bar_widget.dart';
import 'package:eskan/widget/input_widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repository/data_repository.dart';
import '../../../widget/design_util.dart';

class MyPropertyScreen extends StatefulWidget {
  @override
  _MyPropertyScreenState createState() => _MyPropertyScreenState();
}

class _MyPropertyScreenState extends State<MyPropertyScreen> {
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

  bool getAllPropertiesOnDashboard = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainController.hasDataCome.value = false;

    final DataRepository repository = DataRepository();
    repository.getMyProperties(context, mainController);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          backgroundColor: AppColors.primary1,
          onPressed: () async {
            if (mainController.hasDataCome.value) {
              mainController.hasDataCome.value = false;
            }
            final result = await Get.to(() => AddPropertyScreen());
            if (result != null && result) {
              final DataRepository repository = DataRepository();
              print('getting more properties');
              // ignore: use_build_context_synchronously
              await repository.getMyProperties(context, mainController);
              print(mainController.properties.properties.length);

              getAllPropertiesOnDashboard = true;

              mainController.hasDataCome.value = true;

              mainController.update();
            }
          },
          // isExtended: true,
          child: Icon(Icons.add),
        ),
        appBar:
            MyAppBarWidget(appBarTitle: 'My Properties', addBackArrow: false),
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: UiUtils.getDeviceBasedPadding(20, 20, 20, 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'My Properties',
                        fontSize: 18,
                        color: AppColors.primary1,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GetBuilder<MainController>(
                        builder: (logic) {
                          // print(
                          //     'Len: ${mainController.properties.properties[2].propertyImages.length}');
                          return ListView.builder(
                              itemCount:
                                  mainController.properties.properties.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                print('again');
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(PropertyDetailsScreen(
                                      propertyModel: mainController
                                          .properties.properties[index],
                                      myOwnProperty: true,
                                    ));
                                  },
                                  child: MyPropertyEntry(
                                    image1: mainController
                                            .properties
                                            .properties[index]
                                            .propertyImages
                                            .isEmpty
                                        ? null
                                        : mainController
                                            .properties
                                            .properties[index]
                                            .propertyImages[0],
                                    adTitle: mainController
                                        .properties.properties[index].adTitle,
                                    propertyType: mainController.properties
                                        .properties[index].apartmentType,
                                    bedroom: mainController.properties
                                        .properties[index].propertyBedrooms,
                                    price: mainController
                                        .properties.properties[index].price,
                                    location: mainController.properties
                                        .properties[index].propertyLocation,
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
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    Get.back(result: getAllPropertiesOnDashboard);
    return false;
  }
}

class MyPropertyEntry extends StatelessWidget {
  String adTitle;
  String propertyType;
  String bedroom;
  String price;
  String location;
  String? image1;

  MyPropertyEntry(
      {required this.adTitle,
      required this.propertyType,
      required this.bedroom,
      required this.price,
      required this.location,
      required this.image1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UiUtils.getDeviceBasedPadding(0, 10, 10, 25),
      child: Material(
        elevation: 5,
        borderRadius: const BorderRadius.all(Radius.circular(0)),
        color: Colors.transparent,
        child: Container(
          padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: CachedNetworkImage(
                    imageUrl: image1 ??
                        'https://i.pinimg.com/originals/ca/b9/7f/cab97fad1ae18490cb0b0c3aace95983.jpg',
                    width: double.infinity,
                    height: 200,
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 1),
                      ),
                    ),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: UiUtils.getDeviceBasedPadding(12, 8, 8, 8),
                child: TextWidget(
                  text: adTitle,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: UiUtils.getDeviceBasedPadding(12, 8, 8, 8),
                child: TextWidget(
                  text: propertyType,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: UiUtils.getDeviceBasedPadding(12, 8, 8, 8),
                child: TextWidget(
                  text: "$price QAR",
                  fontSize: 13,
                  color: AppColors.primary1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
