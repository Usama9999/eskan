import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  late String text;
  late Color color;
  late double fontSize;
  late FontWeight fontWeight;
  late TextAlign textAlign;
  late bool overflow;
  int? maxLines;
  bool underLine;

  TextWidget(
      {required this.text,
      this.color = Colors.black,
      this.textAlign = TextAlign.start,
      this.fontWeight = FontWeight.w500,
      this.overflow = false,
      this.maxLines,
      this.underLine = false,
      this.fontSize = 17});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      textAlign: textAlign,
      // ignore: deprecated_member_use
      overflow: overflow ? TextOverflow.ellipsis : null,
      maxLines: maxLines,
      minFontSize: 8,
      style: TextStyle(
        color: color,
        decoration: underLine ? TextDecoration.underline : null,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
