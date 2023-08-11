import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<File?> filePicker() async {
  File? file;
  var result = await FilePicker.platform.pickFiles(
    withData: true,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'png'],
  );
  if (result != null) {
    file = File(result.files.single.path!);
  }
  return file;
}
