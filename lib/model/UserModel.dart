// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String email;
  String ? fullname;
  String ? about;
  String password;
  String ? username;
  String ? profileImage;


  UserModel({
    required this.email,
    this.about,
    this.fullname,
    required this.password,
    this.username,
    this.profileImage
  });


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json["email"],
    fullname: json["fullname"],
    password: json["password"],
    about: json["bio"] ?? null,
    username: json["username"],
      profileImage: json["image"]
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "fullname": fullname,
    "about": about ?? null,
    "password": password,
    "username": username,
    "image": profileImage
  };

  factory UserModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> json) => UserModel(
    fullname: json["name"],
    username: json["username"],
    about: json["about"],
    profileImage: json["image"],
    email: json["email"],
    password: json["password"],
  );
}
