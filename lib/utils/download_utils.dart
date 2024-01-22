import 'dart:math';

import 'package:flutter/material.dart';

class DownloadState {
  ValueNotifier<bool> isDownloading = ValueNotifier(false);
  ValueNotifier<double> progress = ValueNotifier(0.0); // 0.0 to 1.0
  ValueNotifier<String> progressText = ValueNotifier("0Mb/0Mb");
}

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0Mb";
  const k = 1024;
  final dm = decimals < 0 ? 0 : decimals;
  final sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  int i = (log(bytes) / log(k)).floor();
  return '${(bytes / pow(k, i)).toStringAsFixed(dm)}${sizes[i]}';
}
