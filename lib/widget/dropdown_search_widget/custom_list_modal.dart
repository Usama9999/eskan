import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../design_util.dart';
import '../input_widget/text_widget.dart';
import '../radio_widget/black_custom_radio.dart';

// ignore: must_be_immutable
class CustomListModal extends StatefulWidget {
  String selectedValue;
  IconData? prefixIconData;
  List normalList = [];
  List filteredList = [];
  Function? onChangeState;
  int selectedId;
  String label;
  Color color;
  BuildContext? screenContext;
  IconData suffixIcon;
  bool minimizeWidth;
  String selectedOption;
  int dataType;
  bool error;

  CustomListModal(
      {Key? key,
      required this.selectedValue,
      this.prefixIconData,
      this.label = '',
      required this.normalList,
      this.onChangeState,
      this.dataType = 0,
      this.screenContext,
      this.error = false,
      this.selectedOption = '',
      this.minimizeWidth = false,
      this.suffixIcon = Icons.arrow_drop_down,
      this.color = widgetsBackgroundColorLight,
      required this.selectedId,
      required this.filteredList})
      : super(key: key);

  @override
  State<CustomListModal> createState() => CustomListModalState();
}

class CustomListModalState extends State<CustomListModal> {
  bool isOpen = false;
  final focusNode = FocusNode();
  final controller = TextEditingController();
  final dropDownContainerKey = GlobalKey();
  String query = '';
  OverlayEntry? entry;
  bool showDropDown = false;

  @override
  void setState(fn) {
    print('setting state');
    if (mounted) {
      try {
        super.setState(fn);
      } catch (ex) {
        print(ex);
      }
    }
  }

  void toogleOverlay() {
    if (!isOpen) {
      showOverlay();
    } else {
      hideOverlay();
    }
  }

  void hideOverlay() {
    try {
      entry?.remove();
      isOpen = false;
    } catch (ex) {
      print(ex);
    }
    setState(() {});
  }

  void showOverlay() {
    setState(() {
      isOpen = true;
      Overlay.of(context).insert(entry!);
    });
  }

  @override
  void initState() {
    super.initState();
    print('initState ');
    focusNode.addListener(() {
      if (!focusNode.hasFocus && entry != null && isOpen) {
        hideOverlay();
      }
    });
    selectedOption = widget.selectedOption;
  }

  String selectedOption = '';

  @override
  void dispose() {
    hideOverlay();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    return GestureDetector(
      onTap: () {
        print("WTF");
        if (widget.filteredList.isNotEmpty) {
          showDialog(
              useRootNavigator: true,
              context: context,
              useSafeArea: true,
              barrierDismissible: true,
              barrierColor: Colors.transparent,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setDialogState) {
                  return Dialog(
                    elevation: 0,
                    insetPadding: EdgeInsets.all(0),
                    backgroundColor: Colors.black54,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: UiUtils.getDeviceBasedPadding(30, 0, 30, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  boxShadow: UiUtils.getBoxShadow(
                                      offset: 10,
                                      blurRadius: 16,
                                      color: Colors.black12),
                                ),
                                child: Padding(
                                  padding: UiUtils.getDeviceBasedPadding(
                                      20, 30, 20, 10),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          itemCount: widget.filteredList.length,
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          physics: ScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            print('again');
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  widget.selectedValue = widget
                                                      .filteredList[index]
                                                      .toString();
                                                });

                                                setDialogState(() {
                                                  widget.selectedOption = widget
                                                      .filteredList[index]
                                                      .toString();

                                                  widget.onChangeState!(
                                                      widget.filteredList[index]
                                                          .toString(),
                                                      widget.selectedId);
                                                });

                                                Get.back();
                                                //Navigator.pop(context);
                                              },
                                              child: Container(
                                                color: Colors.white,
                                                width: double.infinity,
                                                height: 50,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        BlackCustomRadio(
                                                          radioValue: widget
                                                              .filteredList[
                                                                  index]
                                                              .toString(),
                                                          selectedRadioValue:
                                                              widget
                                                                  .selectedOption
                                                                  .toString(),
                                                        ),
                                                        Padding(
                                                          padding: UiUtils
                                                              .getDeviceBasedPadding(
                                                                  20,
                                                                  10,
                                                                  20,
                                                                  5),
                                                          child: TextWidget(
                                                            text: widget
                                                                    .filteredList[
                                                                index],
                                                            fontSize: 13,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    if (index <
                                                        widget.filteredList
                                                                .length -
                                                            1)
                                                      Divider(
                                                        height: 2,
                                                        color: Colors
                                                            .grey.shade600,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
              });
        }
      },
      child: Container(
        key: dropDownContainerKey,
        padding: UiUtils.getDeviceBasedPadding(0, 13, 6, 13),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: widget.error ? Colors.red : AppColors.primary1, width: 2),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: widget.minimizeWidth ? 120 : 250,
              child: TextWidget(
                text: widget.label,
                fontSize: 14,
                maxLines: 1,
              ),
            ),
            Spacer(),
            Icon(
              AntDesign.down,
              size: 15,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }
}
