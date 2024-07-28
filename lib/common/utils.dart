import 'package:file_picker/file_picker.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static Future downloadFile(String url, String fileName) async {
    PermissionStatus isStorageAllowed = await Permission.manageExternalStorage.request();
    // if storage permission is granted
    if (isStorageAllowed.isGranted) {
      try {
        String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
        // if user doesn't cancel file picker
        if (selectedDirectory != null) {
          await FlutterDownloader.enqueue(
            url: url,
            savedDir: selectedDirectory,
            requiresStorageNotLow: true,
            saveInPublicStorage: true,
            fileName: fileName,
            showNotification: true,
            openFileFromNotification: false,
          );
        }
      } catch (e) {
        print(e.toString());
        // getX.Get.snackbar("Error", e.toString(), snackPosition: getX.SnackPosition.BOTTOM);
      }
    } else {
      openAppSettings();
    }
  }
}
