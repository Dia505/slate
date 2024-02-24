import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:slate/model/PostModel.dart';
import 'package:slate/repository/post_repo.dart';
import 'package:slate/service/firebase_service.dart';

class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class MockStorageReference extends Mock implements Reference {}

class MockTaskSnapshot extends Mock implements TaskSnapshot {}

class MockUploadTask extends Mock implements UploadTask {}

class MockDocumentReference extends Mock implements DocumentReference<PostModel> {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  late PostRepo postRepo;
  late MockCollectionReference mockPostRef;
  late MockStorageReference mockStorageRef;

  setUp(() {
    FirebaseService.db = FirebaseFirestore.instance;
    FirebaseService.storageRef = FirebaseStorage.instance.ref();

    postRepo = PostRepo();

    mockPostRef = MockCollectionReference();
    mockStorageRef = MockStorageReference();

    when(FirebaseService.db.collection('Post')).thenReturn(mockPostRef);
    when(FirebaseService.storageRef.child(any as String)).thenReturn(mockStorageRef);
  });

  test('Upload Post', () async {
    final mockPost = PostModel(title: 'Test Title', userId: 'TestUserId', postImage: "testPost");
    final mockFile = MockFile();
    final mockTaskSnapshot = MockTaskSnapshot();
    final mockUploadTask = MockUploadTask();

    when(postRepo.uploadImage(any as File)).thenAnswer((_) => Future.value('mockImageUrl'));
    when(mockPostRef.add(mockPost as Map<String, dynamic>)).thenAnswer((_) => Future.value(mockDocumentReference as FutureOr<DocumentReference<Map<String, dynamic>>>?));
    when(mockStorageRef.getDownloadURL()).thenAnswer((_) => Future.value('mockDownloadUrl'));

    await postRepo.uploadPost(mockPost, mockFile);

    expect(mockPost.postImage, 'mockImageUrl');
    verify(mockPostRef.add(mockPost as Map<String, dynamic>)).called(1);
  });
}

class MockFile extends Mock implements File {}

final mockDocumentReference = MockDocumentReference();
