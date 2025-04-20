import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File> getFilePath(String fileName) async {
  File file = File('');
  if (Platform.isIOS) {
    final dir = await getApplicationDocumentsDirectory();
    file = File('${dir.path}/$fileName');
  }

  if (Platform.isAndroid) {
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      const downloadsFolderPath = '/storage/emulated/0/Download/';
      Directory dir = Directory(downloadsFolderPath);
      file = File('${dir.path}/$fileName');
    }
  }
  return file;
}
