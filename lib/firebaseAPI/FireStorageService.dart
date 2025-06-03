import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


class Firestorageservice {

  /// Method for upload an Image to the database
  
  Future<String?> uploadImageToFirebase(File imageFile, {required String customName}) async {
    try {
      final fileName = '$customName.jpg';
      final storageRef = FirebaseStorage.instance.ref().child('products/$fileName');

      final uploadTask = await storageRef.putFile(imageFile);
      final downloadUrl = await storageRef.getDownloadURL();

      print('Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

}