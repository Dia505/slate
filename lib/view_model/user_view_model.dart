import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slate/model/UserModel.dart';
import 'package:slate/repository/user_repo.dart';

class UserViewModel with ChangeNotifier {
  final UserRepo _userRepo = UserRepo();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserModel> _searchResults = [];
  List<UserModel> get searchResults => _searchResults;

  // Define the isLoading property
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> saveData(UserModel data) async {
    final response = await _userRepo.saveData(data);
  }

  List<QueryDocumentSnapshot<UserModel>> _data = [];

  List<QueryDocumentSnapshot<UserModel>> get data => _data;

  // Future<void> fetchData() async {
  //
  //   try {
  //     final response = await _userRepo.getData();
  //     _data = response;
  //   }
  //   on Exception catch (e) {
  //     print(e.toString());
  //   }
  //
  //   notifyListeners();
  // }

  Future<String?> loginUser(UserModel data) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      String? userId = await UserRepo().loginUser(data.email, data.password);
      if (userId != null) {
        preferences.setString("userId",userId);
        notifyListeners();
      }
      return userId;
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  Future<UserModel?> fetchUserDataById(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
      await _firestore.collection("User").doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = (userSnapshot.data() as Map<String, dynamic>?) ?? {};
        return UserModel.fromJson(userData);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<void> uploadProfileImage(String userId, File file) async {
    try {
      Reference photoRef = await _userRepo.uploadProfileImage(userId, file);

      String url = await photoRef.getDownloadURL();

      // Save the profile image URL to the database
      await _userRepo.saveProfileImage(userId, url);

      notifyListeners();
    } catch (e) {
      print("Error uploading profile image in view model: $e");
      throw e;
    }
  }

  Future<UserModel?> fetchUserDataByUsername(String username) async {
    try {
      // Call the function from the repository to fetch user data by username
      UserModel? userData = await _userRepo.getUserByUsername(username);
      return userData;
    } catch (e) {
      print("Error fetching user data by username in view model: $e");
      return null;
    }
  }
}