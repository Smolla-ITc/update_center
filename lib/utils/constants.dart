import 'package:flutter/material.dart';

/// Dialogue type
enum DialogType {
  alertDialog,
  bottomSheet,
}

/// Used to determine the vertical offset
Widget sizeVer(double height) {
  return SizedBox(
    height: height,
  );
}

// Used to determine the horizontal offset
Widget sizeHor(double width) {
  return SizedBox(width: width);
}
