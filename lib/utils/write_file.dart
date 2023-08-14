import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';

Future<File> writeFile(Uint8List data, String name) async {
  // storage permission ask
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  // the downloads folder path
  var downloadDir = Directory("/storage/emulated/0/Download/");
  String tempPath = downloadDir.path;
  var filePath = '$tempPath/$name';
  //

  // the data
  var bytes = ByteData.view(data.buffer);
  final buffer = bytes.buffer;

  // save the data in the path
  return File(filePath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
