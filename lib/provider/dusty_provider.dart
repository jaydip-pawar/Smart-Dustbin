import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DustyProvider with ChangeNotifier {

  final db = FirebaseFirestore.instance;
  int status = 0;

  setStatus(int status) {
    this.status = status;
    notifyListeners();
  }
}