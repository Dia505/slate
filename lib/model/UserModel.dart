// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? email;
  String? fullname;
  String? password;
  String? username;
  String? bio;
  String? profileImage;

  UserModel(
      {this.email,
      this.fullname,
      this.bio,
      this.password,
      this.username,
      this.profileImage});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      email: json["email"],
      fullname: json["fullname"],
      password: json["password"],
      bio: json["bio"] ?? null,
      username: json["username"],
      profileImage: json["image"]);

  Map<String, dynamic> toJson() => {
        "email": email,
        "fullname": fullname,
        "password": password,
        "bio": bio,
        "username": username,
        "image": profileImage
      };

  factory UserModel.fromFirebaseSnapshot(
          DocumentSnapshot<Map<String, dynamic>> json) =>
      UserModel(
        fullname: json["fullname"],
        username: json["username"],
        bio: json["bio"],
        profileImage: json["image"],
        email: json["email"],
        password: json["password"],
      );
}
