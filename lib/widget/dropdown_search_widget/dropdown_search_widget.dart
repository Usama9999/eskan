import 'package:eskan/widget/dropdown_search_widget/type_widget.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../design_util.dart';
import '../input_widget/search_widget.dart';
import '../input_widget/text_widget.dart';

class DropDownSearchWidget extends StatefulWidget {
  String selectedValue;
  String label;
  IconData? prefixIconData;
  List normalList = [];
  List filteredList = [];
  Function? onChangeState;
  int selectedId;
  Color color;
  IconData suffixIcon;
  bool error;
  bool showSelectedValue;
  FormFieldValidator<String>? validator;

  DropDownSearchWidget(
      {required this.selectedValue,
      this.prefixIconData,
      this.label = '',
      required this.normalList,
      this.onChangeState,
      this.error = false,
      this.showSelectedValue = true,
      this.validator,
      this.suffixIcon = Icons.arrow_drop_down,
      this.color = widgetsBackgroundColorLight,
      required this.selectedId,
      required this.filteredList});

  @override
  State<DropDownSearchWidget> createState() => _DropDownSearchWidgetState();
}

class _DropDownSearchWidgetState extends State<DropDownSearchWidget> {
  bool showDropDown = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            print("normalList Length: ${widget.normalList.length}");
            print("filteredList Length: ${widget.filteredList.length}");
            setState(() {
              showDropDown = !showDropDown;
            });
          },
          child: TypeWidget(
            typeName:
                widget.showSelectedValue ? widget.selectedValue : widget.label,
            color: widget.color,
            error: widget.error,
            iconData: widget.suffixIcon,
            prefixIconData: widget.prefixIconData,
          ),
        ),
        Visibility(
          visible: showDropDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: SearchWidget(
                  onChanged: (value) {
                    print(value);
                    print(widget.normalList.length);
                    if (value.isEmpty) {
                      widget.filteredList = widget.normalList;
                    } else {
                      widget.filteredList = widget.normalList
                          .where((element) => element
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                      print("list: ${widget.filteredList.length}");
                    }
                    setState(() {});
                  },
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200, minHeight: 35.0),
                child: ListView.builder(
                    itemCount: widget.filteredList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.selectedValue =
                                widget.filteredList[index].toString();
                            //widget.selectedId = widget.filteredList[index].id!;
                            showDropDown = false;
                            widget.filteredList = widget.normalList;
                            widget.onChangeState!(
                                widget.selectedValue, widget.selectedId);
                          });
                        },
                        child: Card(
                          child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: UiUtils.getDeviceBasedPadding(
                                      20, 10, 20, 5),
                                  child: TextWidget(
                                    text: widget.filteredList[index],
                                    fontSize: 13,
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                // if (index < widget.filteredList.length - 1)
                                //   Divider(
                                //     height: 2,
                                //     color: Colors.grey.shade600,
                                //   ),
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
      ],
    );
  }
}
