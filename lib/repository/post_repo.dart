import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slate/model/PostModel.dart';
import 'package:slate/service/firebase_service.dart';

class PostRepo {
  CollectionReference<PostModel> postRef =
  FirebaseService.db.collection("Post").withConverter<PostModel>(
    fromFirestore: (snapshot, _) {
      return PostModel.fromFirebaseSnapshot(snapshot);
    },
    toFirestore: (model, _) => model.toJson(),
  );

  Future<String?> uploadImage(File imageFile) async {
    try {
      String filename = imageFile.path.split('/').last;
      var photo = await FirebaseService.storageRef.child("Post").child(filename).putFile(imageFile);
      return await photo.ref.getDownloadURL();
    }
    catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> uploadPost(PostModel post, File imageFile) async {
    try {
      String? imageUrl = await uploadImage(imageFile);

      if (imageUrl != null) {
        post.postImage = imageUrl;

        await postRef.add(post);
      }
      else {
        print("Error uploading post: Image URL is null");
      }
    }
    catch (e) {
      print("Error uploading post: $e");
      throw e;
    }
  }

  Future<List<PostModel>> fetchPostsByUserId(String userId) async {
    try {
      print("Fetching posts for userId: $userId");
      QuerySnapshot<PostModel> snapshot = await postRef
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      print("Fetched ${snapshot.size} posts");

      List<PostModel> posts = snapshot.docs.map((doc) => doc.data()!).toList();
      print("Posts: $posts");

      return posts;
    } catch (e) {
      print("Error getting user posts: $e");
      throw e;
    }
  }

  Future<PostModel?> fetchPostById(String postId) async {
    try {
      DocumentSnapshot<PostModel> snapshot =
      await postRef.doc(postId).get();

      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching post by ID: $e");
      throw e;
    }
  }

  Future<List<PostModel>> fetchAllPosts(String loggedInUserId) async {
    try {
      print("Fetching all posts");
      QuerySnapshot<PostModel> snapshot = await postRef.get();

      List<PostModel> posts = snapshot.docs
          .map((doc) => doc.data()!)
          .where((post) => post.userId != loggedInUserId) // Filter out posts of the logged-in user
          .toList();

      print("Fetched ${posts.length} posts");

      return posts;
    } catch (e) {
      print("Error getting all posts: $e");
      throw e;
    }
  }
}
