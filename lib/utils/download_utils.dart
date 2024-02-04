import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

/// class responsible for managing loading states
class DownloadState {
  ValueNotifier<bool> isDownloading = ValueNotifier(false);
  ValueNotifier<bool> isVerifiedSha256 = ValueNotifier(false);
  ValueNotifier<double> progress = ValueNotifier(0.0); // 0.0 to 1.0
  ValueNotifier<String> progressText = ValueNotifier("0Mb/0Mb");
}

/// Format bytes for download
String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return "0Mb";
  const k = 1024;
  final dm = decimals < 0 ? 0 : decimals;
  final sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  int i = (log(bytes) / log(k)).floor();
  return '${(bytes / pow(k, i)).toStringAsFixed(dm)}${sizes[i]}';
}

/// Used to extract sha256 from a file and is done in a separate thread so that there are no conflicts
Future<String> computeSha256(File file) async {
  var fileBytes = await file.readAsBytes();
  var sha256Result = sha256.convert(fileBytes);
  return sha256Result.toString();
}
