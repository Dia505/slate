import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slate/model/UserModel.dart';
import 'package:slate/repository/user_repo.dart';

class UserViewModel with ChangeNotifier {
  final UserRepo _userRepo = UserRepo();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}