import 'package:flutter/material.dart';

enum DialogType {
  alertDialog,
  bottomSheet,
}

Widget sizeVer(double height) {
  return SizedBox(
    height: height,
  );
}

Widget sizeHor(double width) {
  return SizedBox(width: width);
}
