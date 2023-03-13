import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/firebase/login_data.dart';
import 'package:eskan/root/auth/screens/login.dart';
import 'package:eskan/root/main/controller/main_controller.dart';
import 'package:eskan/root/main/screens/property_details.dart';
import 'package:eskan/widget/input_widget/text_widget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../repository/data_repository.dart';
import '../../../widget/design_util.dart';
import '../../../widget/input_widget/input_widget.dart';

class ExploreScreen extends StatefulWidget {
  bool goToSharedAdd;
  ExploreScreen({this.goToSharedAdd = false});
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState>? globalKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  int currentIndex = 0;
  late TabController tabController;

  MainController mainController = Get.put(MainController());

  var tempProperties = [];

  var scrollController = ScrollController();

  late String propertyType;

  @override
  void initState() {
    super.initState();
    print('initState bitch');
    scrollController.addListener(pagination);
    tabController = TabController(length: 13, vsync: this);
    Future.delayed(Duration.zero, () {
      propertyType = 'Apartment';
      getProperties('Apartment', goToSharedAdd: widget.goToSharedAdd);
      initDynamicLinks(context);
    });
  }

  initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      print('dynamicLink: ${dynamicLinkData}');
      var deepLink = dynamicLinkData.link;

      final queryParams = deepLink.queryParameters;
      print('deepLink.query: ${deepLink.query}');
      print('deepLink.query: ${deepLink.queryParametersAll}');
      print('queryParams: $queryParams');

      if (queryParams.isNotEmpty) {
        String? propertyType = queryParams['propertyType'];
        String? addId = queryParams['addId'];
        print('propertyType: $propertyType');

        DataRepository dataRepository = DataRepository();
        dataRepository.getAProperty(context, propertyType!, addId!);
      }
      debugPrint('DynamicLinks onLink $deepLink');
    }).onError((error) {
      // Handle errors
      debugPrint('DynamicLinks onError $error');
    });
  }

  Future<void> getProperties(String propertyType,
      {bool goToSharedAdd = false, bool showLoading = true}) async {
    final DataRepository repository = DataRepository();
    await repository
        .getAllProperties(
      context,
      propertyType,
      showLoading: showLoading,
    )
        .then((value) {
      mainController.filterProperties();
    });

    if (goToSharedAdd) {
      Get.to(PropertyDetailsScreen(propertyModel: mainController.sharedAdd));
    }

    print('KILLME');
  }

  Future<void> updateProperties(String propertyType,
      {bool showLoading = true}) async {
    final DataRepository repository = DataRepository();
    // await repository.paginateAllProperties(context, propertyType,
    //     showLoading: showLoading);

    print('KILLME');
  }

  Future<void> searchProperties(String propertyType, String val,
      {bool showLoading = true}) async {
    final DataRepository repository = DataRepository();
    // await repository.searchProperties(context, propertyType, val,
    //     showLoading: showLoading);

    print('KILLME');
  }

  void pagination() {
    if ((scrollController.position.pixels ==
        scrollController.position.maxScrollExtent)) {
      Future.delayed(Duration.zero, () {
        setState(() {
          updateProperties(propertyType);
        });
      });
    }
  }

  late Timer searchOnStoppedTyping = Timer(Duration(), () {});

  _onChangeHandler(value) {
    const duration = Duration(
        milliseconds:
            400); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping.cancel()); // clear timer
    }
    setState(
        () => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  search(value) async {
    Future.delayed(Duration.zero, () {
      mainController.filteredAllProperties = mainController.allProperties
          .where((element) =>
              element.adTitle.toLowerCase().isCaseInsensitiveContainsAny(value))
          .toList();
      mainController.update();
    });

    print('hello world from search . the value is $value');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary1,
      ),
      child: GetBuilder<MainController>(
          init: MainController(),
          builder: (controller) {
            return Scaffold(
              key: globalKey,
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                controller: scrollController,
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: UiUtils.getDeviceBasedPadding(0, 20, 0, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                UiUtils.getDeviceBasedPadding(20, 0, 20, 0),
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(70),
                              ),
                              elevation: 10,
                              child: Container(
                                height: 65,
                                padding: UiUtils.getDeviceBasedPadding(
                                    20, 10, 20, 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(70),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: InputWidget(
                                        hint: 'Search a property',
                                        underLine: false,
                                        textSize: 13,
                                        maxLines: 1,
                                        hintFontSize: 13,
                                        hintColor: Colors.black,
                                        onChanged: (val) {
                                          print('Val: $val');
                                          if (val.isEmpty) {
                                            getProperties(propertyType);
                                          } else {
                                            _onChangeHandler(val);
                                          }

                                          mainController.update();
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        mainController.showFilterBox();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        padding: UiUtils.getDeviceBasedPadding(
                                            10, 10, 10, 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(70),
                                          ),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.4),
                                        ),
                                        child: UiUtils.getIcon('filter1.png'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Stack(
                            fit: StackFit.passthrough,
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                padding:
                                    UiUtils.getDeviceBasedPadding(0, 0, 0, 0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0.3),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    UiUtils.getDeviceBasedPadding(10, 0, 10, 0),
                                child: TabBar(
                                  controller: tabController,
                                  isScrollable: true,
                                  padding: UiUtils.getDeviceBasedPadding(
                                      0, 10, 0, 0),
                                  unselectedLabelColor: Colors.grey,
                                  automaticIndicatorColorAdjustment: true,
                                  unselectedLabelStyle: TextStyle(
                                      color: Colors.red,
                                      fontSize: 10.0,
                                      fontFamily: 'Family Name'),
                                  indicatorColor: Colors.black,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  dragStartBehavior: DragStartBehavior.start,
                                  onTap: (index) {
                                    if (index == 0) {
                                      mainController.mySelectedPropertyType
                                          .value = 'Apartment';
                                      propertyType = 'Apartment';
                                      getProperties(propertyType);
                                    } else if (index == 1) {
                                      mainController.mySelectedPropertyType
                                          .value = 'Villa';
                                      propertyType = 'Villa';
                                      getProperties(propertyType);
                                    } else if (index == 2) {
                                      mainController.mySelectedPropertyType
                                          .value = 'Villa-Apartment';
                                      propertyType = 'Villa-Apartment';
                                      getProperties(propertyType);
                                    } else if (index == 3) {
                                      mainController.mySelectedPropertyType
                                          .value = 'Townhouse';
                                      propertyType = 'Townhouse';
                                      getProperties(propertyType);
                                    } else if (index == 4) {
                                      mainController.mySelectedPropertyType
                                          .value = 'Penthouse';
                                      propertyType = 'Penthouse';
                                      getProperties(propertyType);
                                    } else if (index == 5) {
                                      mainController.mySelectedPropertyType
                                          .value = 'Compound';
                                      propertyType = 'Compound';
                                      getProperties(propertyType);
                                    } else if (index == 6) {
                                      mainController.mySelectedPropertyType
                                          .value = 'Duplex';
                                      propertyType = 'Duplex';
                                      getProperties(propertyType);
                                    } else if (index == 7) {
                                      mainController.mySelectedPropertyType
                                          .value = 'Whole Building';
                                      propertyType = 'Whole-Building';
                                      getProperties(propertyType);
                                    } else if (index == 8) {
                                      mainController.mySelectedPropertyType
                                          .value = 'Hotel Apartments';
                                      propertyType = 'Hotel-Apartments';

                                      getProperties(propertyType);
                                    } else if (index == 9) {
                                      mainController.mySelectedPropertyType
                                          .value = 'Hotel Rooms';
                                      propertyType = 'Hotel-Rooms';

                                      getProperties(propertyType);
                                    } else if (index == 10) {
                                      mainController.mySelectedPropertyType
                                          .value = 'Staff Accommodation';
                                      propertyType = 'Staff-Accommodation';

                                      getProperties(propertyType);
                                    } else if (index == 11) {
                                      mainController.mySelectedPropertyType
                                          .value = 'Bed Space';
                                      propertyType = 'Bed-Space';

                                      getProperties(propertyType);
                                    } else if (index == 12) {
                                      mainController.mySelectedPropertyType
                                          .value = 'Studio';
                                      propertyType = 'Studio';

                                      getProperties(propertyType);
                                    }
                                  },
                                  tabs: [
                                    Tab(
                                      height: 65,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.apartment,
                                            color: tabController.index == 0
                                                ? Colors.black
                                                : greyFontColor,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: 'Apartment',
                                            fontWeight: FontWeight.w500,
                                            color: tabController.index == 0
                                                ? Colors.black
                                                : greyFontColor,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      height: 65,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.apartment,
                                            color: tabController.index == 1
                                                ? Colors.black
                                                : greyFontColor,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: 'Villa',
                                            fontWeight: FontWeight.w500,
                                            color: tabController.index == 1
                                                ? Colors.black
                                                : greyFontColor,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      height: 65,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.apartment,
                                            color: tabController.index == 2
                                                ? Colors.black
                                                : greyFontColor,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: 'Villa-Apartment',
                                            fontWeight: FontWeight.w500,
                                            color: tabController.index == 2
                                                ? Colors.black
                                                : greyFontColor,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      height: 65,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.apartment,
                                            color: tabController.index == 3
                                                ? Colors.black
                                                : greyFontColor,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: 'Townhouse',
                                            fontWeight: FontWeight.w500,
                                            color: tabController.index == 3
                                                ? Colors.black
                                                : greyFontColor,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      height: 65,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.apartment,
                                            color: tabController.index == 4
                                                ? Colors.black
                                                : greyFontColor,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: 'Penthouse',
                                            fontWeight: FontWeight.w500,
                                            color: tabController.index == 4
                                                ? Colors.black
                                                : greyFontColor,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      height: 65,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.apartment,
                                            color: tabController.index == 5
                                                ? Colors.black
                                                : greyFontColor,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: 'Compound',
                                            fontWeight: FontWeight.w500,
                                            color: tabController.index == 5
                                                ? Colors.black
                                                : greyFontColor,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      height: 65,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.apartment,
                                            color: tabController.index == 6
                                                ? Colors.black
                                                : greyFontColor,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: 'Duplex',
                                            fontWeight: FontWeight.w500,
                                            color: tabController.index == 6
                                                ? Colors.black
                                                : greyFontColor,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      height: 65,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.apartment,
                                            color: tabController.index == 7
                                                ? Colors.black
                                                : greyFontColor,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: 'Whole Building',
                                            fontWeight: FontWeight.w500,
                                            color: tabController.index == 7
                                                ? Colors.black
                                                : greyFontColor,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      height: 65,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.apartment,
                                            color: tabController.index == 8
                                                ? Colors.black
                                                : greyFontColor,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: 'Hotel Apartments',
                                            fontWeight: FontWeight.w500,
                                            color: tabController.index == 8
                                                ? Colors.black
                                                : greyFontColor,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      height: 65,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.apartment,
                                            color: tabController.index == 9
                                                ? Colors.black
                                                : greyFontColor,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: 'Hotel Rooms',
                                            fontWeight: FontWeight.w500,
                                            color: tabController.index == 9
                                                ? Colors.black
                                                : greyFontColor,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      height: 65,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.apartment,
                                            color: tabController.index == 10
                                                ? Colors.black
                                                : greyFontColor,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: 'Staff Accommodation',
                                            fontWeight: FontWeight.w500,
                                            color: tabController.index == 10
                                                ? Colors.black
                                                : greyFontColor,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      height: 65,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.apartment,
                                            color: tabController.index == 11
                                                ? Colors.black
                                                : greyFontColor,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: 'Bed Space',
                                            fontWeight: FontWeight.w500,
                                            color: tabController.index == 11
                                                ? Colors.black
                                                : greyFontColor,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tab(
                                      height: 65,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MaterialIcons.apartment,
                                            color: tabController.index == 12
                                                ? Colors.black
                                                : greyFontColor,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextWidget(
                                            text: 'Studio',
                                            fontWeight: FontWeight.w500,
                                            color: tabController.index == 12
                                                ? Colors.black
                                                : greyFontColor,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                UiUtils.getDeviceBasedPadding(20, 20, 20, 0),
                            child: ListView.builder(
                                itemCount:
                                    controller.filteredAllProperties.length,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  print('again');
                                  print(
                                      'Favorite: ${mainController.filteredAllProperties[index].favorite}');
                                  return Padding(
                                    padding: UiUtils.getDeviceBasedPadding(
                                        0, 10, 0, 30),
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Get.to(PropertyDetailsScreen(
                                            propertyModel: mainController
                                                .filteredAllProperties[index]));
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
                                                      enableInfiniteScroll:
                                                          false,
                                                      aspectRatio: 20,
                                                      viewportFraction: 1,
                                                      onPageChanged:
                                                          (index2, ssd) {
                                                        mainController
                                                            .filteredAllProperties[
                                                                index]
                                                            .currentIndex = index2;
                                                        mainController.update();
                                                      }),
                                                  items: mainController
                                                          .filteredAllProperties
                                                          .isNotEmpty
                                                      ? mainController
                                                          .filteredAllProperties[
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
                                                                    Radius
                                                                        .circular(
                                                                            20),
                                                                  ),
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl: i ??
                                                                        'https://i.pinimg.com/originals/ca/b9/7f/cab97fad1ae18490cb0b0c3aace95983.jpg',
                                                                    width: double
                                                                        .infinity,
                                                                    height: 300,
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            Center(
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            20,
                                                                        child: CircularProgressIndicator(
                                                                            strokeWidth:
                                                                                1),
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
                                                Positioned(
                                                  top: 10.0,
                                                  right: 10.0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(40),
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if (!Get.find<
                                                                  UserDetail>()
                                                              .login) {
                                                            Get.to(
                                                                LoginScreen());
                                                          } else {
                                                            mainController
                                                                    .filteredAllProperties[
                                                                        index]
                                                                    .favorite =
                                                                !mainController
                                                                    .filteredAllProperties[
                                                                        index]
                                                                    .favorite;

                                                            DataRepository
                                                                repository =
                                                                DataRepository();

                                                            if (mainController
                                                                .filteredAllProperties[
                                                                    index]
                                                                .favorite) {
                                                              print(
                                                                  'addFavorite');
                                                              repository.addFavorite(
                                                                  context,
                                                                  mainController
                                                                          .filteredAllProperties[
                                                                      index]);
                                                            } else {
                                                              print(
                                                                  'removeFavorite');
                                                              repository.removeFavorite(
                                                                  context,
                                                                  mainController
                                                                          .filteredAllProperties[
                                                                      index],
                                                                  mainController);
                                                            }

                                                            mainController
                                                                .update();
                                                          }
                                                        },
                                                        child: Container(
                                                          padding: UiUtils
                                                              .getDeviceBasedPadding(
                                                                  10,
                                                                  10,
                                                                  10,
                                                                  10),
                                                          color: Colors
                                                              .grey.shade300,
                                                          child: Icon(
                                                            AntDesign.hearto,
                                                            size: 18,
                                                            color: mainController
                                                                    .filteredAllProperties[
                                                                        index]
                                                                    .favorite
                                                                ? Colors.red
                                                                : Colors.black,
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
                                                            .filteredAllProperties
                                                            .isNotEmpty
                                                        ? mainController
                                                            .filteredAllProperties[
                                                                index]
                                                            .propertyImages
                                                            .map(
                                                            (image) {
                                                              int index1 = mainController
                                                                  .filteredAllProperties[
                                                                      index]
                                                                  .propertyImages
                                                                  .indexOf(
                                                                      image);
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
                                                                    color: mainController.filteredAllProperties[index].currentIndex ==
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
                                                      .filteredAllProperties
                                                      .isNotEmpty
                                                  ? mainController
                                                      .filteredAllProperties[
                                                          index]
                                                      .adTitle
                                                  : '',
                                              fontSize: 18,
                                            ),
                                            TextWidget(
                                              text: mainController
                                                      .filteredAllProperties
                                                      .isNotEmpty
                                                  ? mainController
                                                      .filteredAllProperties[
                                                          index]
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
                                                      .filteredAllProperties
                                                      .isNotEmpty
                                                  ? '${mainController.filteredAllProperties[index].price} QAR'
                                                  : '',
                                              color: AppColors.primary1,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            TextWidget(
                                              text: mainController
                                                      .filteredAllProperties
                                                      .isNotEmpty
                                                  ? 'Views: ${mainController.filteredAllProperties[index].viewCount}'
                                                  : '',
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  String getPropertyCount(String propertyType) {
    print('propertyType: $propertyType');
    int count = 0;
    for (var element in mainController.allProperties) {
      if (element.apartmentType == propertyType) {
        count += 1;
      }
    }

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
