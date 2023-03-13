import 'dart:io';

import 'package:eskan/constants/app_colors.dart';
import 'package:eskan/firebase/login_data.dart';
import 'package:eskan/root/main/controller/main_controller.dart';
import 'package:eskan/root/main/model/property_model.dart';
import 'package:eskan/root/main/service/services.dart';
import 'package:eskan/widget/app_bar_widget/my_app_bar_widget.dart';
import 'package:eskan/widget/dropdown_search_widget/dropdown_search_widget.dart';
import 'package:eskan/widget/input_widget/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../cache/cache_manager.dart';
import '../../../widget/button_widget/register_button.dart';
import '../../../widget/design_util.dart';
import '../../../widget/dropdown_search_widget/custom_list_modal.dart';
import '../../../widget/input_widget/goat_input_widget.dart';
import '../../../widget/input_widget/green_input_widget.dart';

class AddPropertyScreen extends StatefulWidget {
  PropertyModel? propertyModel;

  AddPropertyScreen({this.propertyModel});
  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  MainController mainController =
      Get.put(MainController(mService: MainService()));
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController adTitleController = TextEditingController();
  TextEditingController adDescriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  File? image1;
  File? image2;
  File? image3;
  File? image4;
  File? image5;
  File? image6;
  bool buttonPressed = false;

  List<String> propertyImagesUrls = [];
  bool propertyAdded = false;
  ScrollController _scrollController = ScrollController();

  bool progressImage1 = false;
  bool progressImage2 = false;
  bool progressImage3 = false;
  bool progressImage4 = false;
  bool progressImage5 = false;
  bool progressImage6 = false;

  @override
  void initState() {
    super.initState();
    buttonPressed = false;
    if (widget.propertyModel != null) {
      List imag = widget.propertyModel!.propertyImages;
      imag.forEach((element) {
        propertyImagesUrls.add(element);
      });
      priceController.text = widget.propertyModel!.price;

      adTitleController.text = widget.propertyModel!.adTitle;
      adDescriptionController.text = widget.propertyModel!.adDescription;
      mainController.selectedPropertyType.value =
          widget.propertyModel!.apartmentType;
    }
    mainController.listOfQatarZones.sort();
    mainController.filteredListOfQatarZones.sort();
    if (widget.propertyModel != null) {
      mainController.selectedQatarZone.value =
          widget.propertyModel!.propertyLocation;
    } else {
      mainController.selectedQatarZone.value = 'Location';
    }
  }

  @override
  Widget build(BuildContext context) {
    MainController mainController =
        Get.put(MainController(mService: MainService()));
    double width = MediaQuery.of(context).size.width;
    print(mainController.filteredListOfPropertyTypes.length);
    return Scaffold(
      appBar: MyAppBarWidget(appBarTitle: 'Add A Property', addBackArrow: true),
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: GetBuilder<MainController>(
            builder: (logic) {
              return Obx(
                () => Form(
                  key: _formKey,
                  child: Padding(
                    padding: UiUtils.getDeviceBasedPadding(20, 20, 20, 0),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropDownSearchWidget(
                            filteredList:
                                mainController.filteredListOfPropertyTypes,
                            color: jobDropDownColor,
                            selectedId: 0,
                            suffixIcon: AntDesign.down,
                            label: 'Property Type',
                            normalList: mainController.listOfPropertyTypes,
                            selectedValue:
                                mainController.selectedPropertyType.value,
                            onChangeState: (value, id) {
                              mainController.selectedPropertyType.value =
                                  value.toString();
                              mainController.propertyTypeError.value = false;
                              mainController.update();
                            },
                            error: mainController.propertyTypeError.value,
                          ),
                          Visibility(
                            visible: mainController.propertyTypeError.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'Select a property type',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomListModal(
                            label: 'Property Bedrooms',
                            filteredList:
                                mainController.filteredListOfPropertyBedrooms,
                            color: jobDropDownColor,
                            selectedId: 0,
                            dataType: 4,
                            error: mainController.propertyBedroomError.value,
                            selectedOption:
                                mainController.selectedPropertyBedrooms.value,
                            suffixIcon: AntDesign.down,
                            normalList: mainController.listOfPropertyBedrooms,
                            selectedValue:
                                mainController.selectedPropertyBedrooms.value,
                            onChangeState: (value, id) {
                              mainController.selectedPropertyBedrooms.value =
                                  value;
                            },
                          ),
                          Visibility(
                            visible: mainController.propertyBedroomError.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'Select a property bedroom',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomListModal(
                            label: 'Property Bathrooms',
                            filteredList:
                                mainController.filteredListOfPropertyBathrooms,
                            color: jobDropDownColor,
                            selectedId: 0,
                            dataType: 4,
                            error: mainController.propertyBathroomError.value,
                            selectedOption:
                                mainController.selectedPropertyBathrooms.value,
                            suffixIcon: AntDesign.down,
                            normalList: mainController.listOfPropertyBathrooms,
                            selectedValue:
                                mainController.selectedPropertyBathrooms.value,
                            onChangeState: (value, id) {
                              print("value: $value");

                              mainController.selectedPropertyBathrooms.value =
                                  value.toString();
                            },
                          ),
                          Visibility(
                            visible: mainController.propertyBathroomError.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'Select a property bathroom',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomListModal(
                            label: 'Property Furnish',
                            filteredList:
                                mainController.filteredListOfPropertyFurnish,
                            color: jobDropDownColor,
                            selectedId: 0,
                            dataType: 4,
                            error: mainController.propertyFurnishError.value,
                            selectedOption:
                                mainController.selectedPropertyFurnish.value,
                            suffixIcon: AntDesign.down,
                            normalList: mainController.listOfPropertyFurnish,
                            selectedValue:
                                mainController.selectedPropertyBathrooms.value,
                            onChangeState: (value, id) {
                              mainController.selectedPropertyFurnish.value =
                                  value.toString();
                            },
                          ),
                          Visibility(
                            visible: mainController.propertyFurnishError.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'Select a property furnish',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextWidget(text: 'Amenities'),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: GetBuilder<MainController>(
                                    assignId: false,
                                    builder: (logic) {
                                      return Checkbox(
                                          value: mainController.acSplit.value,
                                          onChanged: (val) {
                                            mainController.acSplit.value =
                                                !mainController.acSplit.value;
                                            mainController.update();
                                          },
                                          activeColor: AppColors.primary1);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TextWidget(
                                  text: 'AC Split',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: GetBuilder<MainController>(
                                    assignId: false,
                                    builder: (logic) {
                                      return Checkbox(
                                          value: mainController.acWindow.value,
                                          onChanged: (val) {
                                            mainController.acWindow.value =
                                                !mainController.acWindow.value;
                                            mainController.update();
                                          },
                                          activeColor: AppColors.primary1);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TextWidget(
                                  text: 'AC Window',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: GetBuilder<MainController>(
                                    assignId: false,
                                    builder: (logic) {
                                      return Checkbox(
                                          value: mainController.centralAc.value,
                                          onChanged: (val) {
                                            mainController.centralAc.value =
                                                !mainController.centralAc.value;
                                            mainController.update();
                                          },
                                          activeColor: AppColors.primary1);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TextWidget(
                                  text: 'Central AC',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: GetBuilder<MainController>(
                                    assignId: false,
                                    builder: (logic) {
                                      return Checkbox(
                                          value:
                                              mainController.kitchenOpen.value,
                                          onChanged: (val) {
                                            mainController.kitchenOpen.value =
                                                !mainController
                                                    .kitchenOpen.value;
                                            mainController.update();
                                          },
                                          activeColor: AppColors.primary1);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TextWidget(
                                  text: 'Kitchen Open',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: GetBuilder<MainController>(
                                    assignId: false,
                                    builder: (logic) {
                                      return Checkbox(
                                          value: mainController
                                              .kitchenSeparate.value,
                                          onChanged: (val) {
                                            mainController
                                                    .kitchenSeparate.value =
                                                !mainController
                                                    .kitchenSeparate.value;
                                            mainController.update();
                                          },
                                          activeColor: AppColors.primary1);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TextWidget(
                                  text: 'Kitchen Separate',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: GetBuilder<MainController>(
                                    assignId: false,
                                    builder: (logic) {
                                      return Checkbox(
                                          value: mainController.parking.value,
                                          onChanged: (val) {
                                            mainController.parking.value =
                                                !mainController.parking.value;
                                            mainController.update();
                                          },
                                          activeColor: AppColors.primary1);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TextWidget(
                                  text: 'Parking',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: GetBuilder<MainController>(
                                    assignId: false,
                                    builder: (logic) {
                                      return Checkbox(
                                          value: mainController.seaView.value,
                                          onChanged: (val) {
                                            mainController.seaView.value =
                                                !mainController.seaView.value;
                                            mainController.update();
                                          },
                                          activeColor: AppColors.primary1);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TextWidget(
                                  text: 'Sea View',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 20),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: GetBuilder<MainController>(
                                    assignId: false,
                                    builder: (logic) {
                                      return Checkbox(
                                          value:
                                              mainController.gardenView.value,
                                          onChanged: (val) {
                                            mainController.gardenView.value =
                                                !mainController
                                                    .gardenView.value;
                                            mainController.update();
                                          },
                                          activeColor: AppColors.primary1);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TextWidget(
                                  text: 'Garden View',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: UiUtils.getDeviceBasedPadding(0, 0, 0, 30),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: GetBuilder<MainController>(
                                    assignId: false,
                                    builder: (logic) {
                                      return Checkbox(
                                          value: mainController.maidRoom.value,
                                          onChanged: (val) {
                                            mainController.maidRoom.value =
                                                !mainController.maidRoom.value;
                                            mainController.update();
                                          },
                                          activeColor: AppColors.primary1);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TextWidget(
                                  text: 'Maid Room',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ],
                            ),
                          ),
                          TextWidget(text: 'Property Features'),
                          SizedBox(
                            height: 30,
                          ),
                          CustomListModal(
                            label: 'Property Deposit',
                            filteredList:
                                mainController.filteredListOfPropertyDeposit,
                            color: jobDropDownColor,
                            selectedId: 0,
                            dataType: 4,
                            error: mainController.propertyDepositError.value,
                            selectedOption:
                                mainController.selectedPropertyDeposit.value,
                            suffixIcon: AntDesign.down,
                            normalList: mainController.listOfPropertyDeposit,
                            selectedValue:
                                mainController.selectedPropertyBathrooms.value,
                            onChangeState: (value, id) {
                              mainController.selectedPropertyDeposit.value =
                                  value;
                            },
                          ),
                          Visibility(
                            visible: mainController.propertyDepositError.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'Select a property deposit',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomListModal(
                            label: 'Property Commission',
                            filteredList:
                                mainController.filteredListOfPropertyCommission,
                            color: jobDropDownColor,
                            selectedId: 0,
                            dataType: 4,
                            error: mainController.propertyCommissionError.value,
                            selectedOption:
                                mainController.selectedPropertyCommission.value,
                            suffixIcon: AntDesign.down,
                            normalList: mainController.listOfPropertyCommission,
                            selectedValue:
                                mainController.selectedPropertyBathrooms.value,
                            onChangeState: (value, id) {
                              mainController.selectedPropertyCommission.value =
                                  value;
                            },
                          ),
                          Visibility(
                            visible:
                                mainController.propertyCommissionError.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'Select a property commission',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomListModal(
                            label: 'Property Rental Period',
                            filteredList: mainController
                                .filteredListOfPropertyRentalPeriod,
                            color: jobDropDownColor,
                            selectedId: 0,
                            dataType: 4,
                            error:
                                mainController.propertyRentalPeriodError.value,
                            selectedOption: mainController
                                .selectedPropertyRentalPeriod.value,
                            suffixIcon: AntDesign.down,
                            normalList:
                                mainController.listOfPropertyRentalPeriod,
                            selectedValue:
                                mainController.selectedPropertyBathrooms.value,
                            onChangeState: (value, id) {
                              mainController
                                  .selectedPropertyRentalPeriod.value = value;
                            },
                          ),
                          Visibility(
                            visible:
                                mainController.propertyRentalPeriodError.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'Select a property rental period',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomListModal(
                            label: 'Property Contract Duration',
                            filteredList: mainController
                                .filteredListOfPropertyContractDuration,
                            color: jobDropDownColor,
                            selectedId: 0,
                            dataType: 4,
                            error: mainController
                                .propertyContractDurationError.value,
                            selectedOption: mainController
                                .selectedPropertyContractDuration.value,
                            suffixIcon: AntDesign.down,
                            normalList:
                                mainController.listOfPropertyContractDuration,
                            selectedValue:
                                mainController.selectedPropertyBathrooms.value,
                            onChangeState: (value, id) {
                              mainController.selectedPropertyContractDuration
                                  .value = value;
                            },
                          ),
                          Visibility(
                            visible: mainController
                                .propertyContractDurationError.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'Select a property contract duration',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GoatInputWidget(
                            hint: 'Price',
                            price: true,
                            onChanged: (value) {
                              if (buttonPressed && value.isEmpty) {
                                mainController.propertyPriceError.value = true;
                                mainController.update();
                              }
                              if (buttonPressed && value.isNotEmpty) {
                                mainController.propertyPriceError.value = false;
                                mainController.update();
                              }
                              if (buttonPressed &&
                                  value.isNotEmpty &&
                                  int.parse(value) <= 0) {
                                mainController.propertyMinimumPriceError.value =
                                    true;
                                mainController.update();
                              }
                              if (buttonPressed &&
                                  value.isNotEmpty &&
                                  int.parse(value) > 0) {
                                print("propertyMinimumPriceError");
                                mainController.propertyMinimumPriceError.value =
                                    false;
                                mainController.update();
                              }
                            },
                            error: mainController.propertyPriceError.value ||
                                mainController.propertyMinimumPriceError.value,
                            keyboardType: TextInputType.number,
                            controller: priceController,
                          ),
                          Visibility(
                            visible: mainController.propertyPriceError.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'Add a property price',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !mainController.propertyPriceError.value &&
                                mainController.propertyMinimumPriceError.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text:
                                      'Property price should be greater than 0',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DropDownSearchWidget(
                            error: mainController.propertyLocationError.value,
                            filteredList:
                                mainController.filteredListOfQatarZones,
                            color: jobDropDownColor,
                            selectedId: 0,
                            suffixIcon: AntDesign.down,
                            normalList: mainController.listOfQatarZones,
                            selectedValue:
                                mainController.selectedQatarZone.value,
                            onChangeState: (value, id) {
                              mainController.selectedQatarZone.value =
                                  value.toString();
                              mainController.propertyLocationError.value =
                                  false;
                              // mainController.propertyRentalPeriodError.value =
                              // false;
                              mainController.update();
                            },
                          ),
                          Visibility(
                            visible: mainController.propertyLocationError.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'Add a property location',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GoatInputWidget(
                            hint: 'Ad Title',
                            onChanged: (value) {
                              if (buttonPressed && value.isEmpty) {
                                mainController.propertyAdTitleError.value =
                                    true;
                                mainController.update();
                              }
                              if (buttonPressed && value.isNotEmpty) {
                                mainController.propertyAdTitleError.value =
                                    false;
                                mainController.update();
                              }
                            },
                            controller: adTitleController,
                            error: mainController.propertyAdTitleError.value,
                          ),
                          Visibility(
                            visible: mainController.propertyAdTitleError.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'Add a property Ad Title',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GreenInputWidget(
                            hint: 'Ad Description',
                            controller: adDescriptionController,
                            maxLines: 13,
                            onChanged: (value) {
                              if (buttonPressed && value.isEmpty) {
                                mainController
                                    .propertyAdDescriptionError.value = true;
                                mainController.update();
                              }
                              if (buttonPressed && value.isNotEmpty) {
                                mainController
                                    .propertyAdDescriptionError.value = false;
                                mainController.update();
                              }
                            },
                            error:
                                mainController.propertyAdDescriptionError.value,
                          ),
                          Visibility(
                            visible:
                                mainController.propertyAdDescriptionError.value,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'Add a property Ad Description',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextWidget(text: 'Property Images'),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              height: 100,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: propertyImagesUrls.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 0) {
                                      return InkWell(
                                        onTap: () {
                                          showPicker(context, 1);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          alignment: Alignment.center,
                                          child: Text('Add Image+'),
                                        ),
                                      );
                                    }
                                    return Container(
                                      margin: EdgeInsets.only(right: 10),
                                      height: 100,
                                      width: 100,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            child: Image.network(
                                              propertyImagesUrls[index - 1],
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                              top: 0,
                                              right: 0,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    propertyImagesUrls
                                                        .removeAt(index - 1);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: Icon(
                                                    Icons.close_rounded,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                    );
                                  })),
                          Visibility(
                            visible:
                                buttonPressed && propertyImagesUrls.length < 3,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextWidget(
                                  text: 'Please add minimum 3 images',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          ButtonWidget(
                            buttonText: widget.propertyModel != null
                                ? 'Update'
                                : 'Add Property',
                            onPressed: () async {
                              bool error = false;
                              buttonPressed = true;

                              if (mainController.selectedPropertyType.value ==
                                  'Property Type') {
                                error = true;
                                mainController.propertyTypeError.value = true;
                              } else {
                                mainController.propertyTypeError.value = false;
                              }
                              if (mainController
                                      .selectedPropertyBedrooms.value ==
                                  'Property Bedrooms') {
                                error = true;
                                mainController.propertyBedroomError.value =
                                    true;
                              } else {
                                mainController.propertyBedroomError.value =
                                    false;
                              }
                              if (mainController
                                      .selectedPropertyBathrooms.value ==
                                  'Property Bathrooms') {
                                error = true;
                                mainController.propertyBathroomError.value =
                                    true;
                              } else {
                                mainController.propertyBathroomError.value =
                                    false;
                              }
                              if (mainController
                                      .selectedPropertyFurnish.value ==
                                  'Property Furnish') {
                                error = true;
                                mainController.propertyFurnishError.value =
                                    true;
                              } else {
                                mainController.propertyFurnishError.value =
                                    false;
                              }
                              if (mainController
                                      .selectedPropertyDeposit.value ==
                                  'Property Deposit') {
                                error = true;
                                mainController.propertyDepositError.value =
                                    true;
                              } else {
                                mainController.propertyDepositError.value =
                                    false;
                              }
                              if (mainController
                                      .selectedPropertyCommission.value ==
                                  'Property Commission') {
                                error = true;
                                mainController.propertyCommissionError.value =
                                    true;
                              } else {
                                mainController.propertyCommissionError.value =
                                    false;
                              }
                              if (mainController
                                      .selectedPropertyRentalPeriod.value ==
                                  'Property Rental Period') {
                                error = true;
                                mainController.propertyRentalPeriodError.value =
                                    true;
                              } else {
                                mainController.propertyRentalPeriodError.value =
                                    false;
                              }
                              if (mainController
                                      .selectedPropertyContractDuration.value ==
                                  'Property Contract Duration') {
                                error = true;
                                mainController
                                    .propertyContractDurationError.value = true;
                              } else {
                                mainController.propertyContractDurationError
                                    .value = false;
                              }
                              if (priceController.text == '') {
                                error = true;
                                mainController.propertyPriceError.value = true;
                              } else {
                                mainController.propertyPriceError.value = false;
                              }
                              if (priceController.text.isNotEmpty &&
                                  int.parse(priceController.text) <= 0) {
                                error = true;
                                mainController.propertyMinimumPriceError.value =
                                    true;
                              } else {
                                mainController.propertyMinimumPriceError.value =
                                    false;
                              }
                              if (mainController.selectedQatarZone.value ==
                                  'Location') {
                                error = true;
                                mainController.propertyLocationError.value =
                                    true;
                              } else {
                                mainController.propertyLocationError.value =
                                    false;
                              }
                              if (adTitleController.text == '') {
                                error = true;
                                mainController.propertyAdTitleError.value =
                                    true;
                              } else {
                                mainController.propertyAdTitleError.value =
                                    false;
                              }

                              if (adDescriptionController.text == '') {
                                error = true;
                                mainController
                                    .propertyAdDescriptionError.value = true;
                              } else {
                                mainController
                                    .propertyAdDescriptionError.value = false;
                              }

                              // propertyImagesUrls.add(
                              //     'https://i.pinimg.com/originals/ca/b9/7f/cab97fad1ae18490cb0b0c3aace95983.jpg');
                              //
                              //
                              if (propertyImagesUrls.length < 3) {
                                error = true;
                              } else {}

                              if (error) return;
                              final property = PropertyModel(
                                  userId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  adEnabled: widget.propertyModel != null
                                      ? widget.propertyModel!.adEnabled
                                      : true,
                                  viewCount: widget.propertyModel != null
                                      ? widget.propertyModel!.viewCount
                                      : 0,
                                  email: Get.find<UserDetail>().email,
                                  postedBy: Get.find<UserDetail>().name,
                                  phoneNumber:
                                      Get.find<UserDetail>().phoneNumber,
                                  location: Get.find<UserDetail>().location,
                                  apartmentType:
                                      mainController.selectedPropertyType.value,
                                  propertyBedrooms: mainController
                                      .selectedPropertyBathrooms.value,
                                  propertyBathrooms: mainController
                                      .selectedPropertyBedrooms.value,
                                  propertyFurnish: mainController
                                      .selectedPropertyFurnish.value,
                                  immunities: Immunities(
                                      centralAc: mainController.centralAc.value,
                                      acSplit: mainController.acSplit.value,
                                      acWindow: mainController.acWindow.value,
                                      gardenView:
                                          mainController.gardenView.value,
                                      kitchenOpen:
                                          mainController.kitchenOpen.value,
                                      kitchenSeparate:
                                          mainController.kitchenSeparate.value,
                                      maidRoom: mainController.maidRoom.value,
                                      parking: mainController.parking.value,
                                      seaView: mainController.seaView.value),
                                  depositDropDown: mainController
                                      .selectedPropertyDeposit.value,
                                  rank: widget.propertyModel != null
                                      ? widget.propertyModel!.rank
                                      : 1,
                                  commission:
                                      mainController.selectedPropertyCommission.value,
                                  rentalPeriod: mainController.selectedPropertyRentalPeriod.value,
                                  price: priceController.text,
                                  propertyLocation: mainController.selectedQatarZone.value,
                                  adTitle: adTitleController.text,
                                  adDescription: adDescriptionController.text,
                                  contractDuration: mainController.selectedPropertyContractDuration.value,
                                  propertyImages: propertyImagesUrls,
                                  approved: widget.propertyModel != null ? widget.propertyModel!.approved : false,
                                  comment: '',
                                  docId: '',
                                  favorite: false,
                                  id: 0);
                              propertyAdded = true;
                              if (widget.propertyModel == null) {
                                await mainController.addProperty(
                                    context, property);
                              } else {
                                property.docId = widget.propertyModel!.docId;
                                await mainController.updateProperty(
                                    context, property);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _imgFromCamera(int imageNumber) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      uploadImage(File(photo.path));
    }
  }

  _imgFromGallery(int imageNumber) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      uploadImage(File(photo.path));
    }
  }

  uploadImage(File file) async {
    final metadata = SettableMetadata(contentType: "image/jpeg");

    final storageRef = FirebaseStorage.instance.ref();

// Upload file and metadata to the path 'images/mountains.jpg'
    final uploadTask = storageRef
        .child(
            'images/${CacheManager().userEmail}/property1/image${propertyImagesUrls.length}.jpg')
        .putFile(file, metadata);

    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          print("Upload is $progress% complete.");

          break;
        case TaskState.paused:
          print("Upload is paused.");
          break;
        case TaskState.canceled:
          print("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          String url = await storageRef
              .child(
                  'images/${CacheManager().userEmail}/property1/image${propertyImagesUrls.length}.jpg')
              .getDownloadURL();
          print('url: $url');
          propertyImagesUrls.add(url);
          setState(() {});
          mainController.update();
          // Handle successful uploads on complete
          // ...
          break;
      }
    });
  }

  Future? showPicker(context, int imageNumber) {
    Get.bottomSheet(Container(
      color: Colors.white,
      child: Wrap(
        children: <Widget>[
          ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Photo Library'),
              onTap: () {
                _imgFromGallery(imageNumber);
                Get.back();
              }),
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text('Camera'),
            onTap: () {
              _imgFromCamera(imageNumber);
              Get.back();
            },
          ),
        ],
      ),
    ));
    return null;
  }
}
