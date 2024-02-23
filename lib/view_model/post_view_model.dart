import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:slate/model/PostModel.dart';
import 'package:slate/repository/post_repo.dart';
import 'package:slate/service/firebase_service.dart';

class PostViewModel with ChangeNotifier {
  final PostRepo _postRepo = PostRepo();
  List<PostModel> _userPosts = [];
  PostModel? _currentPost;

  List<PostModel> get userPosts => _userPosts;

  PostModel? get currentPost => _currentPost;

  Future<void> uploadPost(String title, String description, File imageFile) async {
    try {
      User? user = FirebaseService.firebaseAuth.currentUser;

      if (user != null) {
        PostModel post = PostModel(
          title: title,
          description: description,
          userId: user.uid,
          postImage: '',
        );

        await _postRepo.uploadPost(post, imageFile);

        notifyListeners();
      }
      else {
        print("User is not logged in");
      }
    }
    catch (e) {
      print("Error uploading post in PostViewModel: $e");
      throw e;
    }
  }

  Future<void> fetchUserPosts() async {
    try {
      User? user = FirebaseService.firebaseAuth.currentUser;

      if (user != null) {
        _userPosts = await _postRepo.fetchPostsByUserId(user.uid);
        print(_userPosts.length);
        print("//////");
        print("User Posts: $_userPosts");
        notifyListeners();
      }
      else {
        print("User is not logged in");
      }
    } catch (e) {
      print("Error fetching user posts in PostViewModel: $e");
      throw e;
    }
  }

  Future<void> fetchPostById(String postId) async {
    try {
      _currentPost = await _postRepo.fetchPostById(postId);
      notifyListeners();
    } catch (e) {
      print("Error fetching post: $e");
      throw e;
    }
  }

  Future<void> fetchAllPosts() async {
    try {
      User? user = FirebaseService.firebaseAuth.currentUser;
      _userPosts = await _postRepo.fetchAllPosts(user!.uid);
      print(_userPosts.length);
      print("//////");
      notifyListeners();
    }
    catch (e) {
      print("Error fetching posts: $e");
      throw e;
    }
  }
}