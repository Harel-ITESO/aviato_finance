import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File> getFilePath(String fileName) async {
  if (Platform.isIOS) {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  } else if (Platform.isAndroid) {
    final dir = await getExternalStorageDirectory(); // Asegura que el directorio existe
    final path = '${dir?.path}/$fileName';
    final file = File(path);
    return file;
  }
  throw UnsupportedError('Unsupported platform');
}