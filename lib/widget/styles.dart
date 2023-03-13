import 'package:flutter/material.dart';

TextStyle headingText({double size = 16, Color? color}) {
  return TextStyle(
      color: color ?? Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: (size));
}

TextStyle subHeadingText({double size = 14, Color? color}) {
  return TextStyle(
      color: color ?? Colors.black,
      fontSize: (size),
      fontWeight: FontWeight.w600);
}

TextStyle regularText({double size = 14, Color? color}) {
  return TextStyle(
    color: color ?? Colors.black,
    fontSize: (size),
    fontWeight: FontWeight.w500,
  );
}

TextStyle normalText({double size = 14, Color? color}) {
  return TextStyle(
    color: color ?? Colors.black,
    fontSize: (size),
    fontWeight: FontWeight.normal,
  );
}

TextStyle underLineText({double size = 14, Color? color}) {
  return TextStyle(
      // fontFamily: "montserrat",
      color: color ?? Colors.black,
      fontSize: (size),
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.underline);
}

TextStyle lightText({double size = 14, Color? color}) {
  return TextStyle(
    // fontFamily: "Roboto",
    color: Colors.black,
    fontSize: (size),
    fontWeight: FontWeight.normal,
  );
}
