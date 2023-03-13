import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eskan/cache/cache_manager.dart';
import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/repository/data_repository.dart';
import 'package:eskan/root/auth/model/register_model.dart';
import 'package:eskan/root/auth/screens/otp_screen.dart';
import 'package:eskan/root/main/screens/add_property.dart';
import 'package:eskan/root/main/screens/dashboard.dart';
import 'package:eskan/root/main/service/services.dart';
import 'package:eskan/widget/button_widget/black_button.dart';
import 'package:eskan/widget/design_util.dart';
import 'package:eskan/widget/input_widget/text_widget.dart';
import 'package:eskan/widget/loading_widget/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/property_model.dart';

class MainController extends GetxController {
  // ignore: non_constant_identifier_names
  MainService? mService;

  // ignore: non_constant_identifier_names
  MainController({this.mService});
  var passwordProtected = true.obs;
  var rePasswordProtected = true.obs;
  var currentIndex = 0.obs;

  var userEmail = '';

  var priceStartValue = 50.0.obs;
  var priceEndValue = 70000.0.obs;
  String bedroomFilter = 'Any';
  String bathroomFilter = 'Any';
  String furnishFilter = 'Any';
  String depositFilter = 'Any';
  String commissionFilter = 'Any';
  String rentalPeriodFilter = 'Any';
  String contractDurationFilter = 'Any';
  bool acSplitFilter = false;
  bool acWindowFilter = false;
  bool gardenViewFilter = false;
  bool kitchenOpenFilter = false;
  bool kitchenSeparateFilter = false;
  bool maidRoomFilter = false;
  bool parkingFilter = false;
  bool seaViewFilter = false;
  void filterProperties() {
    log("all propertes log:" + allProperties.length.toString());
    filteredAllProperties = allProperties
        .where((element) =>
            int.parse(element.price) > priceStartValue.value &&
            int.parse(element.price) < priceEndValue.value &&
            element.propertyBedrooms
                .contains(bedroomFilter == 'Any' ? '' : bedroomFilter) &&
            element.propertyBathrooms
                .contains(bathroomFilter == 'Any' ? '' : bathroomFilter) &&
            element.propertyFurnish
                .contains(furnishFilter == 'Any' ? '' : furnishFilter) &&
            element.depositDropDown
                .contains(depositFilter == 'Any' ? '' : depositFilter) &&
            element.commission
                .contains(commissionFilter == 'Any' ? '' : commissionFilter) &&
            element.rentalPeriod.contains(
                rentalPeriodFilter == 'Any' ? '' : rentalPeriodFilter) &&
            element.contractDuration.contains(
                contractDurationFilter == 'Any' ? '' : contractDurationFilter))
        .toList();

    log("after filter log:" + filteredAllProperties.length.toString());
    update();
  }

  resetFilter() {
    priceStartValue.value = 50;
    priceEndValue.value = 70000;
    bedroomFilter = 'Any';
    bathroomFilter = 'Any';
    furnishFilter = 'Any';
    depositFilter = 'Any';
    commissionFilter = 'Any';
    rentalPeriodFilter = 'Any';
    contractDurationFilter = 'Any';
    acSplitFilter = false;
    acWindowFilter = false;
    gardenViewFilter = false;
    kitchenOpenFilter = false;
    kitchenSeparateFilter = false;
    maidRoomFilter = false;
    parkingFilter = false;
    seaViewFilter = false;

    filteredAllProperties.addAll(allProperties);
    update();
  }

  showFilterBox() {
    showModalBottomSheet(
      context: Get.overlayContext!,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return Scaffold(
          bottomNavigationBar: Material(
            elevation: 10,
            child: Container(
              padding: UiUtils.getDeviceBasedPadding(15, 25, 15, 15),
              child: StatefulBuilder(builder:
                  (BuildContext context, StateSetter setModalOwnState) {
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        resetFilter();
                      },
                      child: TextWidget(
                        text: 'Clear',
                        fontSize: 15,
                      ),
                    ),
                    Spacer(),
                    BlackButton(
                      buttonText: 'Filter',
                      onPressed: () {
                        filterProperties();
                      },
                    ),
                  ],
                );
              }),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: UiUtils.getDeviceBasedPadding(20, 0, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextWidget(
                    text: 'Price range',
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: '$priceStartValue - $priceEndValue QAR+',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  RangeSlider(
                    min: 50,
                    activeColor: AppColors.primary1,
                    max: 70000,
                    values:
                        RangeValues(priceStartValue.value, priceEndValue.value),
                    onChanged: (RangeValues value) {
                      print('start: ${value.start}');
                      print('end: ${value.end}');
                      setModalState(() {
                        priceStartValue.value = value.start.toPrecision(0);
                        priceEndValue.value = value.end.toPrecision(0);
                      });
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: 'Rooms and beds',
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: 'Bedrooms',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  border: Border.all(
                                      color: bedroomFilter == 'Any'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  color: bedroomFilter == 'Any'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(25, 10, 25, 10),
                              child: TextWidget(
                                text: 'Any',
                                fontSize: 14,
                                color: bedroomFilter == 'Any'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bedroomFilter = 'Any';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: bedroomFilter == '1'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: bedroomFilter == '1'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '1',
                                fontSize: 14,
                                color: bedroomFilter == '1'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bedroomFilter = '1';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: bedroomFilter == '2'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: bedroomFilter == '2'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '2',
                                fontSize: 14,
                                color: bedroomFilter == '2'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bedroomFilter = '2';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: bedroomFilter == '3'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: bedroomFilter == '3'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '3',
                                fontSize: 14,
                                color: bedroomFilter == '3'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bedroomFilter = '3';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: bedroomFilter == '4'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: bedroomFilter == '4'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '4',
                                fontSize: 14,
                                color: bedroomFilter == '4'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bedroomFilter = '4';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: bedroomFilter == '5'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: bedroomFilter == '5'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '5',
                                fontSize: 14,
                                color: bedroomFilter == '5'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bedroomFilter = '5';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: bedroomFilter == '6'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: bedroomFilter == '6'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '6',
                                fontSize: 14,
                                color: bedroomFilter == '6'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bedroomFilter = '6';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: bedroomFilter == '7'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: bedroomFilter == '7'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '7',
                                fontSize: 14,
                                color: bedroomFilter == '7'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bedroomFilter = '7';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: bedroomFilter == '7+'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: bedroomFilter == '7+'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '7+',
                                fontSize: 14,
                                color: bedroomFilter == '7+'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bedroomFilter = '7+';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: 'Bathrooms',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  border: Border.all(
                                      color: bathroomFilter == 'Any'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  color: bathroomFilter == 'Any'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(25, 10, 25, 10),
                              child: TextWidget(
                                text: 'Any',
                                fontSize: 14,
                                color: bathroomFilter == 'Any'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bathroomFilter = 'Any';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: bathroomFilter == '1'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: bathroomFilter == '1'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '1',
                                fontSize: 14,
                                color: bathroomFilter == '1'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bathroomFilter = '1';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: bathroomFilter == '2'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: bathroomFilter == '2'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '2',
                                fontSize: 14,
                                color: bathroomFilter == '2'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bathroomFilter = '2';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: bathroomFilter == '3'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: bathroomFilter == '3'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '3',
                                fontSize: 14,
                                color: bathroomFilter == '3'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bathroomFilter = '3';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: bathroomFilter == '3+'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: bathroomFilter == '3+'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '3+',
                                fontSize: 14,
                                color: bathroomFilter == '3+'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              bathroomFilter = '3+';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: 'Immunities',
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Padding(
                        child: Row(
                          children: [
                            TextWidget(
                              text: 'AC Split',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                            Spacer(),
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: Checkbox(
                                  onChanged: (val) {
                                    setModalState(() {
                                      acSplitFilter = !acSplitFilter;
                                    });
                                  },
                                  value: acSplitFilter),
                            ),
                          ],
                        ),
                        padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 15),
                      ),
                      Padding(
                        padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 15),
                        child: Row(
                          children: [
                            TextWidget(
                              text: 'AC Window',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                            Spacer(),
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: Checkbox(
                                  onChanged: (val) {
                                    setModalState(() {
                                      acWindowFilter = !acWindowFilter;
                                    });
                                  },
                                  value: acWindowFilter),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 15),
                        child: Row(
                          children: [
                            TextWidget(
                              text: 'Garden View',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                            Spacer(),
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: Checkbox(
                                  onChanged: (val) {
                                    setModalState(() {
                                      gardenViewFilter = !gardenViewFilter;
                                    });
                                  },
                                  value: gardenViewFilter),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 15),
                        child: Row(
                          children: [
                            TextWidget(
                              text: 'Kitchen Open',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                            Spacer(),
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: Checkbox(
                                  onChanged: (val) {
                                    setModalState(() {
                                      kitchenOpenFilter = !kitchenOpenFilter;
                                    });
                                  },
                                  value: kitchenOpenFilter),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 15),
                        child: Row(
                          children: [
                            TextWidget(
                              text: 'Kitchen Separate',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                            Spacer(),
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: Checkbox(
                                  onChanged: (val) {
                                    setModalState(() {
                                      kitchenSeparateFilter =
                                          !kitchenSeparateFilter;
                                    });
                                  },
                                  value: kitchenSeparateFilter),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 15),
                        child: Row(
                          children: [
                            TextWidget(
                              text: 'Maid Room',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                            Spacer(),
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: Checkbox(
                                  onChanged: (val) {
                                    setModalState(() {
                                      maidRoomFilter = !maidRoomFilter;
                                    });
                                  },
                                  value: maidRoomFilter),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 15),
                        child: Row(
                          children: [
                            TextWidget(
                              text: 'Parking',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                            Spacer(),
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: Checkbox(
                                  onChanged: (val) {
                                    setModalState(() {
                                      parkingFilter = !parkingFilter;
                                    });
                                  },
                                  value: parkingFilter),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 15),
                        child: Row(
                          children: [
                            TextWidget(
                              text: 'Sea View',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                            Spacer(),
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: Checkbox(
                                  onChanged: (val) {
                                    setModalState(() {
                                      seaViewFilter = !seaViewFilter;
                                    });
                                  },
                                  value: seaViewFilter),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: 'Other Details',
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: 'Furnish',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  border: Border.all(
                                      color: furnishFilter == 'Any'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  color: furnishFilter == 'Any'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(25, 10, 25, 10),
                              child: TextWidget(
                                text: 'Any',
                                fontSize: 14,
                                color: furnishFilter == 'Any'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              furnishFilter = 'Any';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: furnishFilter == 'Furnished'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: furnishFilter == 'Furnished'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: 'Furnished',
                                fontSize: 14,
                                color: furnishFilter == 'Furnished'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              furnishFilter = 'Furnished';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: furnishFilter == 'UnFurnished'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: furnishFilter == 'UnFurnished'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: 'UnFurnished',
                                fontSize: 14,
                                color: furnishFilter == 'UnFurnished'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              furnishFilter = 'UnFurnished';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: furnishFilter == 'Semi-Furnished'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: furnishFilter == 'Semi-Furnished'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: 'Semi-Furnished',
                                fontSize: 14,
                                color: furnishFilter == 'Semi-Furnished'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              furnishFilter = 'Semi-Furnished';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: 'Deposit',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  border: Border.all(
                                      color: depositFilter == 'Any'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  color: depositFilter == 'Any'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(25, 10, 25, 10),
                              child: TextWidget(
                                text: 'Any',
                                fontSize: 14,
                                color: depositFilter == 'Any'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              depositFilter = 'Any';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: depositFilter == '1 Month'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: depositFilter == '1 Month'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '1 Month',
                                fontSize: 14,
                                color: depositFilter == '1 Month'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              depositFilter = '1 Month';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: depositFilter == '2 Month'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: depositFilter == '2 Month'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '2 Month',
                                fontSize: 14,
                                color: depositFilter == '2 Month'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              depositFilter = '2 Month';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextWidget(
                    text: 'Commission',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  border: Border.all(
                                      color: commissionFilter == 'Any'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  color: commissionFilter == 'Any'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(25, 10, 25, 10),
                              child: TextWidget(
                                text: 'Any',
                                fontSize: 14,
                                color: commissionFilter == 'Any'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              commissionFilter = 'Any';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: commissionFilter == '1 Month'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: commissionFilter == '1 Month'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '1 Month',
                                fontSize: 14,
                                color: commissionFilter == '1 Month'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              commissionFilter = '1 Month';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: commissionFilter == '1/2'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: commissionFilter == '1/2 Month'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '1/2 Month',
                                fontSize: 14,
                                color: commissionFilter == '1/2 Month'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              commissionFilter = '1/2 Month';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextWidget(
                    text: 'Rental Period',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  border: Border.all(
                                      color: rentalPeriodFilter == 'Any'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  color: rentalPeriodFilter == 'Any'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(25, 10, 25, 10),
                              child: TextWidget(
                                text: 'Any',
                                fontSize: 14,
                                color: rentalPeriodFilter == 'Any'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              rentalPeriodFilter = 'Any';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: rentalPeriodFilter == '1-30 Days'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: rentalPeriodFilter == '1-30 Days'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '1-30 Days',
                                fontSize: 14,
                                color: rentalPeriodFilter == '1-30 Days'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              rentalPeriodFilter = '1-30 Days';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: rentalPeriodFilter == '1-3 Months'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: rentalPeriodFilter == '1-3 Months'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '1-3 Months',
                                fontSize: 14,
                                color: rentalPeriodFilter == '1-3 Months'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              rentalPeriodFilter = '1-3 Months';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: rentalPeriodFilter == '6 Months'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: rentalPeriodFilter == '6 Months'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '6 Months',
                                fontSize: 14,
                                color: rentalPeriodFilter == '6 Months'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              rentalPeriodFilter = '6 Months';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: rentalPeriodFilter == '12 Months+'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: rentalPeriodFilter == '12 Months+'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: '12 Months+',
                                fontSize: 14,
                                color: rentalPeriodFilter == '12 Months+'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              rentalPeriodFilter = '12 Months+';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextWidget(
                    text: 'Contract Duration',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  border: Border.all(
                                      color: contractDurationFilter == 'Any'
                                          ? Colors.black
                                          : Colors.grey,
                                      width: 0.4),
                                  color: contractDurationFilter == 'Any'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(25, 10, 25, 10),
                              child: TextWidget(
                                text: 'Any',
                                fontSize: 14,
                                color: contractDurationFilter == 'Any'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              contractDurationFilter = 'Any';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          contractDurationFilter == 'Long Term'
                                              ? Colors.black
                                              : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: contractDurationFilter == 'Long Term'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: 'Long Term',
                                fontSize: 14,
                                color: contractDurationFilter == 'Long Term'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              contractDurationFilter = 'Long Term';
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          contractDurationFilter == 'Short Term'
                                              ? Colors.black
                                              : Colors.grey,
                                      width: 0.4),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: contractDurationFilter == 'Short Term'
                                      ? Colors.black
                                      : Colors.transparent),
                              padding:
                                  UiUtils.getDeviceBasedPadding(15, 10, 15, 10),
                              child: TextWidget(
                                text: 'Short Term',
                                fontSize: 14,
                                color: contractDurationFilter == 'Short Term'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          onTap: () {
                            setModalState(() {
                              contractDurationFilter = 'Short Term';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  var mySelectedPropertyType = 'Apartment'.obs;

  List<PropertyModel> differentProperties = <PropertyModel>[];
  List<PropertyModel> filteredDifferentProperties = <PropertyModel>[];

  List<PropertyModel> pendingProperties = <PropertyModel>[];
  List<PropertyModel> approvedProperties = <PropertyModel>[];
  List<PropertyModel> allProperties = [];
  List<DocumentSnapshot> newAllProperties = <DocumentSnapshot>[];
  List<RegisterRequestModel> allUsers = <RegisterRequestModel>[];
  List<RegisterRequestModel> filteredAllUsers = <RegisterRequestModel>[];
  List<PropertyModel> filteredAllProperties = [];
  List<PropertyModel> normalAllProperties = <PropertyModel>[];

  var sharedAdd = PropertyModel(
      apartmentType: '',
      propertyBedrooms: '',
      propertyBathrooms: '',
      propertyFurnish: '',
      immunities: Immunities(
          acSplit: true,
          acWindow: true,
          centralAc: true,
          gardenView: true,
          kitchenOpen: true,
          kitchenSeparate: true,
          maidRoom: true,
          parking: true,
          seaView: true),
      postedBy: '',
      depositDropDown: '',
      commission: '',
      rentalPeriod: '',
      price: '',
      propertyLocation: '',
      userId: '',
      adTitle: '',
      adDescription: '',
      contractDuration: '',
      propertyImages: []);

  var propertyTypeError = false.obs;
  var propertyBedroomError = false.obs;
  var propertyBathroomError = false.obs;
  var propertyFurnishError = false.obs;
  var propertyDepositError = false.obs;
  var propertyCommissionError = false.obs;
  var propertyRentalPeriodError = false.obs;
  var propertyContractDurationError = false.obs;
  var propertyPriceError = false.obs;
  var propertyMinimumPriceError = false.obs;
  var propertyLocationError = false.obs;
  var propertyAdTitleError = false.obs;
  var propertyAdDescriptionError = false.obs;
  var propertyImagesError = false.obs;

  var properties = Property(properties: []);

  var propertiesList = Property(properties: []);

  var registerModel = RegisterRequestModel();

  var hasDataCome = false.obs;

  List<String> listOfQatarZones = [
    'Al Jasrah',
    'Al Bidda',
    'Fereej Mohamed Bin Jasim Mushayrib',
    'Mushayrib',
    'Al Najada  Barahat Al Jufairi Fereej Al Asmakh',
    'Old Al Ghanim',
    'Al Souq',
    'Wadi Al Sail',
    'Rumeilah',
    'Al Bidda',
    'Mushayrib',
    'Fereej Abdel Aziz',
    'Ad Dawhah al Jadidah',
    'Old Al Ghanim',
    'Al Rufaa Old Al Hitmi',
    'As Salatah Al Mirqab',
    'Doha Port',
    'Wadi Al Sail',
    'Rumeilah',
    'Fereej Bin Mahmoud',
    'Rawdat Al Khail',
    'Fereej Bin Durham Al Mansoura',
    'Najma',
    'Umm Ghuwailina',
    'Al Khulaifat Ras Abu Aboud',
    'Duhail',
    'Umm Lekhba',
    'Madinat Khalifa North Dahl Al Hamam',
    'Al Markhiya',
    'Madinat Khalifa South',
    'Fereej Kulaib',
    'Al Messila',
    'Fereej Bin Omran New Al Hitmi Hamad Medical City',
    'Al Sadd',
    'Al Sadd New Al Mirqab Fereej Al Nasr',
    'New Salatah',
    'Nuaija',
    'Al Hilal',
    'Nuaija',
    'Old Airport',
    'Al Thumama',
    'Doha International Airport',
    'Zone 50',
    'Industrial Area',
    'Zone 58',
    'Al Dafna Al Qassar',
    'Onaiza',
    'Lejbailat',
    'Onaiza Leqtaifiya Al Qassar',
    'Hazm Al Markhiya',
    'Jelaiah Al Tarfa Jeryan Nejaima',
    'Al Gharrafa Gharrafat Al Rayyan Izghawa Bani Hajer Al Seej Rawdat Egdaim Al Themaid',
    'Al Luqta Lebday Old Al Rayyan Al Shagub Fereej Al Zaeem',
    'New Al Rayyan Al Wajbah Muaither',
    'Fereej Al Amir Luaib Muraikh Baaya Mehairja Fereej Al Soudan',
    'Fereej Al Soudan Al Waab Al Aziziya New Fereej Al Ghanim Fereej Al Murra Fereej Al Manaseer Bu Sidra Muaither Al Sailiya Al Mearad',
    'Fereej Al Asiri New Fereej Al Khulaifat Bu Samra Al Mamoura Abu Hamour Mesaimeer Ain Khaled',
    'Mebaireek',
    'Al Karaana',
    'Abu Samra',
    'Sawda Natheel',
    'Jabal Thuaileb Al Kharayej Lusail Al Egla Wadi Al Banat',
    'Leabaib Al Ebb Jeryan Jenaihat Al Kheesa Rawdat Al Hamama Wadi Al Wasaah Al Sakhama Al Masrouhiya Wadi Lusail Lusail Umm Qarn Al Daayen',
    'Bu Fasseela Izghawa Al Kharaitiyat Umm Salal Ali Umm Salal Mohammed Saina Al-Humaidi Umm Al Amad Umm Ebairiya',
    'Simaisma Al Jeryan Al Khor City',
    'Al Thakhira Ras Laffan Umm Birka',
    'Al Ghuwariyah',
    'Ain Sinan Madinat Al Kaaban Fuwayrit',
    'Abu Dhalouf Zubarah',
    "Madinat ash Shamal Ar Ru'ays",
    'Al Utouriya',
    'Al Jemailiya',
    'Al-Shahaniya City',
    'Rawdat Rashed',
    'Umm Bab',
    'Al Nasraniya',
    'Dukhan',
    'Al Wakrah',
    'Al Thumama Al Wukair Al Mashaf',
    'Mesaieed',
    'Mesaieed Industrial Area',
    'Shagra',
    'Al Kharrara',
    'Khawr al Udayd',
  ].obs;
  List<String> filteredListOfQatarZones = [
    'Al Jasrah',
    'Al Bidda',
    'Fereej Mohamed Bin Jasim Mushayrib',
    'Mushayrib',
    'Al Najada  Barahat Al Jufairi Fereej Al Asmakh',
    'Old Al Ghanim',
    'Al Souq',
    'Wadi Al Sail',
    'Rumeilah',
    'Al Bidda',
    'Mushayrib',
    'Fereej Abdel Aziz',
    'Ad Dawhah al Jadidah',
    'Old Al Ghanim',
    'Al Rufaa Old Al Hitmi',
    'As Salatah Al Mirqab',
    'Doha Port',
    'Wadi Al Sail',
    'Rumeilah',
    'Fereej Bin Mahmoud',
    'Rawdat Al Khail',
    'Fereej Bin Durham Al Mansoura',
    'Najma',
    'Umm Ghuwailina',
    'Al Khulaifat Ras Abu Aboud',
    'Duhail',
    'Umm Lekhba',
    'Madinat Khalifa North Dahl Al Hamam',
    'Al Markhiya',
    'Madinat Khalifa South',
    'Fereej Kulaib',
    'Al Messila',
    'Fereej Bin Omran New Al Hitmi Hamad Medical City',
    'Al Sadd',
    'Al Sadd New Al Mirqab Fereej Al Nasr',
    'New Salatah',
    'Nuaija',
    'Al Hilal',
    'Nuaija',
    'Old Airport',
    'Al Thumama',
    'Doha International Airport',
    'Zone 50',
    'Industrial Area',
    'Zone 58',
    'Al Dafna Al Qassar',
    'Onaiza',
    'Lejbailat',
    'Onaiza Leqtaifiya Al Qassar',
    'Hazm Al Markhiya',
    'Jelaiah Al Tarfa Jeryan Nejaima',
    'Al Gharrafa Gharrafat Al Rayyan Izghawa Bani Hajer Al Seej Rawdat Egdaim Al Themaid',
    'Al Luqta Lebday Old Al Rayyan Al Shagub Fereej Al Zaeem',
    'New Al Rayyan Al Wajbah Muaither',
    'Fereej Al Amir Luaib Muraikh Baaya Mehairja Fereej Al Soudan',
    'Fereej Al Soudan Al Waab Al Aziziya New Fereej Al Ghanim Fereej Al Murra Fereej Al Manaseer Bu Sidra Muaither Al Sailiya Al Mearad',
    'Fereej Al Asiri New Fereej Al Khulaifat Bu Samra Al Mamoura Abu Hamour Mesaimeer Ain Khaled',
    'Mebaireek',
    'Al Karaana',
    'Abu Samra',
    'Sawda Natheel',
    'Jabal Thuaileb Al Kharayej Lusail Al Egla Wadi Al Banat',
    'Leabaib Al Ebb Jeryan Jenaihat Al Kheesa Rawdat Al Hamama Wadi Al Wasaah Al Sakhama Al Masrouhiya Wadi Lusail Lusail Umm Qarn Al Daayen',
    'Bu Fasseela Izghawa Al Kharaitiyat Umm Salal Ali Umm Salal Mohammed Saina Al-Humaidi Umm Al Amad Umm Ebairiya',
    'Simaisma Al Jeryan Al Khor City',
    'Al Thakhira Ras Laffan Umm Birka',
    'Al Ghuwariyah',
    'Ain Sinan Madinat Al Kaaban Fuwayrit',
    'Abu Dhalouf Zubarah',
    "Madinat ash Shamal Ar Ru'ays",
    'Al Utouriya',
    'Al Jemailiya',
    'Al-Shahaniya City',
    'Rawdat Rashed',
    'Umm Bab',
    'Al Nasraniya',
    'Dukhan',
    'Al Wakrah',
    'Al Thumama Al Wukair Al Mashaf',
    'Mesaieed',
    'Mesaieed Industrial Area',
    'Shagra',
    'Al Kharrara',
    'Khawr al Udayd',
  ].obs;
  var selectedQatarZone = 'Location'.obs;

  var processIndex = 0.obs;
  late BuildContext splashContext;
  // List<CountryModel> listOfCountries = <CountryModel>[].obs;
  // List<CountryModel> filteredListOfCountries = <CountryModel>[].obs;
  //
  // List<CrewTypeModel> listOfCrewTypes = <CrewTypeModel>[].obs;
  // List<CrewTypeModel> filteredListOfCrewTypes = <CrewTypeModel>[].obs;
  var isApiDataFetched = false.obs;
  var selectedCountry = 'United States'.obs;
  var selectedPosition = "Pilot in Command".obs;

  var showCountryDropDrown = false.obs;
  var showPositionDropDown = false.obs;

  List<String> listOfPropertyTypes = [
    'Apartment',
    'Villa',
    'Villa-Apartment',
    'Townhouse',
    'Penthouse',
    'Compound',
    'Duplex',
    'Whole Building',
    'Hotel Apartments',
    'Hotel Room',
    'Staff Accommodation',
    'Bed Space',
    'Studio'
  ].obs;
  List<String> filteredListOfPropertyTypes = [
    'Apartment',
    'Villa',
    'Villa-Apartment',
    'Townhouse',
    'Penthouse',
    'Compound',
    'Duplex',
    'Whole Building',
    'Hotel Apartments',
    'Hotel Room',
    'Staff Accommodation',
    'Bed Space',
    'Studio'
  ].obs;

  var selectedPropertyType = 'Property Type'.obs;

  editPoperty(PropertyModel model) {
    selectedPropertyBedrooms.value = model.propertyBedrooms;
    selectedPropertyBathrooms.value = model.propertyBathrooms;
    selectedPropertyFurnish.value = model.propertyFurnish;
    selectedPropertyFurnish.value = model.propertyFurnish;
    acSplit.value = model.immunities.acSplit;
    acWindow.value = model.immunities.acWindow;
    centralAc.value = model.immunities.centralAc;
    kitchenOpen.value = model.immunities.kitchenOpen;
    kitchenSeparate.value = model.immunities.kitchenSeparate;
    parking.value = model.immunities.parking;
    seaView.value = model.immunities.seaView;
    gardenView.value = model.immunities.gardenView;
    maidRoom.value = model.immunities.maidRoom;
    selectedPropertyDeposit.value = model.depositDropDown;
    selectedPropertyCommission.value = model.commission;
    selectedPropertyRentalPeriod.value = model.rentalPeriod;
    selectedPropertyContractDuration.value = model.contractDuration;
    update();
    Get.to(() => AddPropertyScreen(
          propertyModel: model,
        ));
  }

  List<String> listOfPropertyBedrooms = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    'More than 7',
  ].obs;
  List<String> filteredListOfPropertyBedrooms = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    'More than 7',
  ].obs;

  var selectedPropertyBedrooms = "Property Bedrooms".obs;

  List<String> listOfPropertyBathrooms = [
    '1',
    '2',
    '2.5',
    '3',
    'More than 3',
  ].obs;
  List<String> filteredListOfPropertyBathrooms = [
    '1',
    '2',
    '2.5',
    '3',
  ].obs;

  var selectedPropertyBathrooms = "Property Bathrooms".obs;

  List<String> listOfPropertyFurnish =
      ['Furnished', 'Unfurnished', 'Semi-Furnished'].obs;
  List<String> filteredListOfPropertyFurnish =
      ['Furnished', 'Unfurnished', 'Semi-Furnished'].obs;
  var selectedPropertyFurnish = "Property Furnish".obs;

  List<String> listOfPropertyDeposit = ['1 Month', '2 Month'].obs;
  List<String> filteredListOfPropertyDeposit = ['1 Month', '2 Month'].obs;
  var selectedPropertyDeposit = "Property Deposit".obs;

  List<String> listOfPropertyCommission = ['1 Month', '1/2 Month'].obs;
  List<String> filteredListOfPropertyCommission = ['1 Month', '1/2 Month'].obs;
  var selectedPropertyCommission = "Property Commission".obs;

  List<String> listOfPropertyRentalPeriod =
      ['1-30 Days', '1-3 Months', '6 Months', '12 Months or more'].obs;
  List<String> filteredListOfPropertyRentalPeriod =
      ['1-30 Days', '1-3 Months', '6 Months', '12 Months or more'].obs;
  var selectedPropertyRentalPeriod = "Property Rental Period".obs;

  List<String> listOfPropertyContractDuration =
      <String>['Long Term', 'Short Term'].obs;
  List<String> filteredListOfPropertyContractDuration =
      <String>['Long Term', 'Short Term'].obs;
  var selectedPropertyContractDuration = "Property Contract Duration".obs;

  var acSplit = false.obs;
  var centralAc = false.obs;
  var acWindow = false.obs;
  var kitchenOpen = false.obs;
  var kitchenSeparate = false.obs;
  var parking = false.obs;
  var seaView = false.obs;
  var gardenView = false.obs;
  var maidRoom = false.obs;

  Future loginUser(BuildContext context, String email, String password,
      {bool showLoading = true}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential != null) {
        print(credential);
        print('Login Successfully');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future addProperty(BuildContext context, PropertyModel property) async {
    final DataRepository repository = DataRepository();

    await repository.addProperty(context, property);

    print('kill meeee');

    Get.back(result: true);
  }

  Future<void> updateProperty(
      BuildContext context, PropertyModel property) async {
    LoadingWidget(context).showProgressIndicator();
    try {
      FirebaseFirestore.instance
          .collection('properties')
          .doc(property.docId)
          .set(property.toJson())
          .then((value) {
        LoadingWidget(context).hideProgressIndicator();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Updated successfully'),
      ));
      Get.offAll(() => DashboardScreen(
            initIndex: 2,
          ));
    } catch (e) {
      LoadingWidget(context).hideProgressIndicator();
    }
  }

  Future registerUser(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+974${CacheManager().registerModel.phoneNumber}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }

        // Handle other errors
      },
      codeSent: (String verificationId, int? resendToken) async {
        CacheManager().verificationId = verificationId;
        Get.off(OTPScreen());
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    // try {
    //   final credential =
    //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    //
    //   if (credential != null) {
    //     final DataRepository repository = DataRepository();
    //     final newUser = RegisterRequestModel(
    //         email: email,
    //         phoneNumber: '0232323',
    //         location: 'Lahore',
    //         businessName: 'whatever',
    //         fullName: 'Wasif');
    //     repository.addUser(newUser);
    //     print('Registered Successfully');
    //   }
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     print('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     print('The account already exists for that email.');
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }
}
