import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../constants/app_colors.dart';
import '../design_util.dart';
import '../input_widget/search_widget.dart';
import '../input_widget/text_widget.dart';

// ignore: must_be_immutable
class MyCustomDropdown extends StatefulWidget {
  String selectedValue;
  IconData? prefixIconData;
  List normalList = [];
  List filteredList = [];
  Function? onChangeState;
  int selectedId;
  Color color;
  IconData suffixIcon;

  MyCustomDropdown(
      {Key? key,
      required this.selectedValue,
      this.prefixIconData,
      required this.normalList,
      this.onChangeState,
      this.suffixIcon = Icons.arrow_drop_down,
      this.color = widgetsBackgroundColorLight,
      required this.selectedId,
      required this.filteredList})
      : super(key: key);

  @override
  State<MyCustomDropdown> createState() => MyCustomDropdownState();
}

class MyCustomDropdownState extends State<MyCustomDropdown> {
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

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    return entry = OverlayEntry(
      builder: (context) {
        print('overlayy');
        final mediaQuery = MediaQuery.of(context);
        final double scaleFactor = mediaQuery.textScaleFactor;
        final double screenHeight = mediaQuery.size.height;
        final RenderBox renderBox = dropDownContainerKey.currentContext!
            .findRenderObject()! as RenderBox;
        final height = renderBox.size.height;
        final width = renderBox.size.width;
        final bool addBoundary =
            window.physicalSize.width * 1.5 > window.physicalSize.height;

        var offset = renderBox.localToGlobal(Offset.zero);
        if (addBoundary) {
          final double widthAfter = window.physicalSize.height * 9 / 16;
          final double widthDiff = (window.physicalSize.width - widthAfter) /
              mediaQuery.devicePixelRatio;
          offset = Offset(offset.dx - widthDiff / 2, offset.dy);
        }
        var remainingSpace =
            screenHeight - height - offset.dy - 4 * scaleFactor;

        remainingSpace = min(remainingSpace, 255);
        return Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                print('sad');
                entry!.remove();
                isOpen = false;
              },
              child: Container(),
            ),
            Positioned(
              top: offset.dy + height,
              left: offset.dx,
              width: width,
              child: Card(
                margin: EdgeInsets.all(0),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SearchWidget(
                          onChanged: (value) {
                            print(value);
                            if (value.isEmpty) {
                              widget.filteredList = widget.normalList;
                              print("list: ${widget.filteredList.length}");
                            } else {
                              widget.filteredList = widget.normalList
                                  .where((element) => element.name!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                              if (widget.filteredList.isEmpty) {
                                print("showNoResults here");
                              }
                            }

                            setState(() {});
                          },
                        ),
                      ),
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(maxHeight: 200, minHeight: 35.0),
                        child: ListView.builder(
                            itemCount: widget.filteredList.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              print('again');
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.selectedValue = widget
                                        .filteredList[index].name!
                                        .toString();
                                    widget.selectedId =
                                        widget.filteredList[index].id!;
                                    showDropDown = false;
                                    widget.filteredList.clear();
                                    widget.filteredList
                                        .addAll(widget.normalList);
                                    widget.onChangeState!(widget.selectedValue,
                                        widget.selectedId);
                                    toogleOverlay();
                                  });
                                },
                                child: Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: UiUtils.getDeviceBasedPadding(
                                            20, 10, 20, 5),
                                        child: TextWidget(
                                          text: widget
                                                  .filteredList[index]?.name ??
                                              widget.filteredList[index].label!,
                                          fontSize: 13,
                                          maxLines: 1,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      if (index <
                                          widget.filteredList.length - 1)
                                        Divider(
                                          height: 2,
                                          color: Colors.grey.shade600,
                                        ),
                                    ],
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
          ],
        );
      },
    );
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
      Overlay.of(context)!.insert(entry!);
    });
  }

  @override
  void initState() {
    super.initState();
    print('initState ');
    _createOverlayEntry();
    focusNode.addListener(() {
      if (!focusNode.hasFocus && entry != null && isOpen) {
        hideOverlay();
      }
    });
  }

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
        print("normalList Length: ${widget.normalList.length}");
        print("filteredList Length: ${widget.filteredList.length}");
        toogleOverlay();
      },
      child: Container(
        key: dropDownContainerKey,
        padding: UiUtils.getDeviceBasedPadding(0, 11, 5, 11),
        decoration: BoxDecoration(
          color: AppColors.appPrimaryColor,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            SizedBox(
              child: TextWidget(
                text: widget.selectedValue,
                fontSize: 14,
                color: Colors.white,
                maxLines: 1,
              ),
            ),
            Spacer(),
            Icon(
              AntDesign.down,
              size: 17,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
