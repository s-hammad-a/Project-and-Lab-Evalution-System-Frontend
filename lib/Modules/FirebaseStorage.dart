import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageManager
{
  Future<String?> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    String? location;
    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      String fileName = result.files.first.name;

      // Upload file
      TaskSnapshot snapshot =  await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);
      location = await snapshot.ref.getDownloadURL();
    }
    //returns the download url
    return location;
  }
}