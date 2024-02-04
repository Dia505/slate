import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slate/model/UserModel.dart';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  String postImage;
  String title;
  String ? description;
  String userId;

  PostModel({
    required this.postImage,
    required this.title,
    this.description,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    postImage: json["postImage"],
    title: json["title"],
    description: json["description"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "postImage": postImage,
    "title": title,
    "description": description,
    "userId": userId,
  };

  factory PostModel.fromFirebaseSnapshot(DocumentSnapshot<Map<String, dynamic>> json) => PostModel(
    postImage: json["postImage"],
    title: json["title"],
    description: json["description"],
    userId: json["userId"],
  );
}