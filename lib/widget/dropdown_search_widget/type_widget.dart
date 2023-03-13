import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../constants/app_colors.dart';
import '../design_util.dart';
import '../input_widget/text_widget.dart';

class TypeWidget extends StatelessWidget {
  String typeName;
  Color color;
  Color borderColor;
  IconData iconData;
  IconData? prefixIconData;
  double iconSize;
  GlobalKey? key;
  bool error;

  TypeWidget(
      {required this.typeName,
      this.color = jobDropDownColor,
      this.prefixIconData,
      this.iconSize = 17,
      this.key,
      this.error = false,
      this.borderColor = Colors.white,
      this.iconData = AntDesign.down});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      padding: UiUtils.getDeviceBasedPadding(0, 11, 5, 11),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: error ? Colors.red : AppColors.primary1, width: 2)),
      child: Row(
        children: [
          Visibility(
            child: Icon(
              prefixIconData,
              color: Colors.grey.shade500,
            ),
            visible: prefixIconData != null ? true : false,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextWidget(
              text: typeName,
              fontSize: 14,
              maxLines: 1,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Icon(
            iconData,
            size: iconSize,
            color: Colors.grey.shade500,
          )
        ],
      ),
    );
  }
}
