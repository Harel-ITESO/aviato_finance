import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File> getFilePath(String fileName) async {
  File file = File('');

  if (Platform.isIOS) {
    final dir = await getApplicationDocumentsDirectory();
    file = File('${dir.path}/$fileName');
  } else if (Platform.isAndroid) {
    // Pedir permisos
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }

    if (status.isGranted) {
      final dir = await getExternalStorageDirectory();
      if (dir != null) {
        file = File('${dir.path}/$fileName');
      }
    }
  }

  return file;
}