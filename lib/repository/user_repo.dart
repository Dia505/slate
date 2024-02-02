import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slate/model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slate/service/firebase_service.dart';

class UserRepo {
  CollectionReference<UserModel> userRef =
  FirebaseService.db.collection("User").withConverter<UserModel>(
    fromFirestore: (snapshot, _) {
      return UserModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );

  Future<dynamic> saveData(UserModel data) async {
    try {
      UserCredential userCredential = await FirebaseService.firebaseAuth
          .createUserWithEmailAndPassword(
          email: data.email, password: data.password);
      // data.userId = userCredential.user!.uid;
      await userRef.doc(userCredential.user!.uid).set(data);
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Future<UserModel> getUserDetail(String id, String? token) async {
  //   try {
  //
  //     final response = await userRef.doc(id).get();
  //     var user = response.data()!;
  //     await userRef.doc(user.userId).set(user);
  //     return user;
  //   } catch (err) {
  //     rethrow;
  //   }
  // }

  Future<String?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      return null;
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      print("Logged in user: " + userId);
      final snapshot = await FirebaseFirestore.instance.collection("User").doc(userId).get();
      return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    } catch (e) {
      print("Error fetching user data by ID: $e");
      return null;
    }
  }
}
