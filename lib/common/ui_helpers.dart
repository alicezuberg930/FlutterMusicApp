import 'package:flutter/material.dart';
import 'package:flutter_music_app/common/constants.dart';

class UIHelpers {
  static showSnackBar({Color color = Colors.red, required String message}) {
    Constants.rootScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 14)),
        backgroundColor: color,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: "OK",
          onPressed: () => {},
          textColor: Colors.white,
        ),
      ),
    );
    // ScaffoldMessenger.of(context).showSnackBar();
  }
}
