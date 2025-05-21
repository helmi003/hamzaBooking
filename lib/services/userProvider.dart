import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hamzabooking/models/user.dart';

class UserProvider with ChangeNotifier {
  final CollectionReference userCollection = FirebaseFirestore.instance
      .collection("users");
  UserModel user = UserModel(
     "",
     "",
     "",
     "",
     "",
     Rolemodel.user,
  );

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      final userData = json.decode(prefs.getString('user').toString());
      user = UserModel.fromJson(userData);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  setUser(UserModel user1) {
    user = user1;
    notifyListeners();
  }

  userData(String uid) async {
    return userCollection.doc(uid).get();
  }
}
