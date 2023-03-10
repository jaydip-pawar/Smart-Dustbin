import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DustyProvider with ChangeNotifier {

  final db = FirebaseFirestore.instance;
  final storageRef  = FirebaseStorage.instance.ref();
  int status = 0;

  setStatus(int status) {
    this.status = status;
    notifyListeners();
  }

  Future<String> uploadImage(File imageFile) async {
    EasyLoading.show(status: "Image uploading...");
    late String downloadURL;
    final Reference imageRef = storageRef.child('images/${DateTime.now().millisecondsSinceEpoch}.png');

    try{
      await imageRef.putFile(imageFile);
      downloadURL = await imageRef.getDownloadURL();
    } catch (e) {
      EasyLoading.showError("Image upload failed");
    }
    EasyLoading.dismiss();
    return downloadURL;
  }


  registerComplaint(BuildContext context, File image, String title, String description) async {
    final url = await uploadImage(image);
    EasyLoading.show(status: "please wait...");
    final DocumentReference documentRef = db.collection('Complaints').doc();

    await documentRef.set({
      'title': title,
      'description': description,
      'image': url,
      'location': '',
    });
    EasyLoading.showSuccess("Complaint registered");
    Navigator.pop(context);
  }
}