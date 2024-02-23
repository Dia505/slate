import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
          email: data.email ?? "", password: data.password ?? "");
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
    }
    on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      return null;
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection("User").doc(userId).get();
      return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    }
    catch (e) {
      print("Error fetching user data by ID: $e");
      return null;
    }
  }

  Future<Reference> uploadProfileImage(String userId, File file) async {
    try {
      TaskSnapshot snapshot = await FirebaseService.storageRef
          .child("user")
          .child(userId)
          .putFile(file);

      return snapshot.ref;
    } catch (e) {
      print("Error uploading profile image in repository: $e");
      throw e;
    }
  }

  Future<void> saveProfileImage(String userId, String imageUrl) async {
    try {
      await userRef.doc(userId).update({'image': imageUrl});
    }
    catch (e) {
      print("Error updating profile image: $e");
      throw e;
    }
  }

  Future<UserModel?> getUserByUsername(String username) async {
    try {
      // Query the 'User' collection for documents where the 'username' field matches the provided username
      QuerySnapshot<UserModel> querySnapshot = await userRef
          .where('username', isEqualTo: username)
          .limit(1) // Limit the query to 1 document (assuming username is unique)
          .get();

      // Check if any document was found
      if (querySnapshot.docs.isNotEmpty) {
        // Convert the first document in the query result to a UserModel object
        UserModel user = querySnapshot.docs.first.data();
        return user;
      }
      else {
        // No document found with the provided username
        return null;
      }
    } catch (e) {
      print("Error fetching user data by username: $e");
      return null;
    }
  }
}
