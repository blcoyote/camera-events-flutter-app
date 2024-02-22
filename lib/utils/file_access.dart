import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

var downloadDir = Directory("/storage/emulated/0/Download/");

Future<File> writeFile(Uint8List data, String name) async {
  // storage permission ask
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  // the downloads folder path

  String tempPath = downloadDir.path;
  var filePath = '$tempPath/$name';
  //

  // the data
  var bytes = ByteData.view(data.buffer);
  final buffer = bytes.buffer;

  // save the data in the path
  return File(filePath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

openVideo(String filename) async {
  await OpenFile.open('${downloadDir.path}/$filename', type: "video/mp4");
}

checkFileExists(String filename) {
  return File('${downloadDir.path}/$filename').existsSync();
}
