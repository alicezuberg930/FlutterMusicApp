import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_music_app/common/constants.dart';
import 'package:flutter_music_app/common/ui_helpers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Utils {
  static Future<void> downloadFile(String url, String fileName) async {
    PermissionStatus isStorageAllowed = await Permission.manageExternalStorage.request();
    // if storage permission is granted
    if (isStorageAllowed.isGranted) {
      try {
        String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
        // if user doesn't cancel file picker
        if (selectedDirectory != null) {
          String? taskId = await FlutterDownloader.enqueue(
            url: url,
            savedDir: selectedDirectory,
            requiresStorageNotLow: true,
            saveInPublicStorage: true,
            fileName: fileName,
            showNotification: true,
            openFileFromNotification: false,
          );
          UIHelpers.showSnackBar(color: Colors.green, message: taskId!);
        }
      } catch (e) {
        UIHelpers.showSnackBar(message: e.toString());
      }
    } else {
      openAppSettings();
    }
  }

  static String formatDuration(Duration? duration) {
    if (duration == null) {
      return "00:00";
    } else {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
      return "$minutes:$seconds";
    }
  }

  static String getHash256(String str) {
    var bytes = utf8.encode(str); // Convert the input string to bytes
    var digest = sha256.convert(bytes); // Compute the SHA-256 hash
    return digest.toString(); // Convert the digest to a hexadecimal string
  }

  static String getHmac512(String str, String key) {
    var keyBytes = utf8.encode(key); // Convert the key to bytes
    var hmac = Hmac(sha512, keyBytes); // Create an HMAC using SHA-512
    var messageBytes = utf8.encode(str); // Convert the input string to bytes
    var digest = hmac.convert(messageBytes); // Compute the HMAC digest
    return digest.toString(); // Convert the digest to a hexadecimal string
  }

  static String hashParamHome(String path) {
    return getHmac512(
      path + getHash256("count=30ctime=${Constants.ctime}page=1version=${Constants.zingMP3Version}"),
      Constants.secretKey,
    );
  }

  static String hashParamNoId(String path) {
    return getHmac512(
      path + getHash256("ctime=${Constants.ctime}version=${Constants.zingMP3Version}"),
      Constants.secretKey,
    );
  }

  static String hashParamWithId(String path, String id) {
    return getHmac512(
      path + getHash256("ctime=${Constants.ctime}id=${id}version=${Constants.zingMP3Version}"),
      Constants.secretKey,
    );
  }
}
