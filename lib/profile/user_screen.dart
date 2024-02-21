import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slate/model/PostModel.dart';
import 'package:slate/model/UserModel.dart';
import 'package:slate/post/post_view.dart';
import 'package:slate/view_model/post_view_model.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});
  static const String routeName = "/user";

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final database = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserModel? _user;
  String ? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 10.0),
                  child: Image.asset(
                    "assets/images/slate logo.png",
                    height: 35,
                  ),
                ),
                Text(
                  "SLATE",
                  style: GoogleFonts.jura(
                    textStyle:
                    TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 200.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "assets/images/back.png",
                      height: 30.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                  stream: database
                      .collection("User")
                      .doc(userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.data() == null) {
                      // Handle the case when the document doesn't exist or data is null
                      return const Text(
                        "User data not available",
                        style: TextStyle(color: Colors.white),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    final user = UserModel.fromJson(snapshot.data!.data()!
                    as Map<String, dynamic>); // Map<String, dynamic>

                    return Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0, left: 145.0),
                              child: CircleAvatar(
                                backgroundImage: _user?.profileImage != null
                                    ? NetworkImage(_user!.profileImage!)
                                    : AssetImage("assets/images/profile.png") as ImageProvider,
                                radius: 60,
                              ),
                            ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(user.fullname ?? "",
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 24))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(user.username ?? "",
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 18))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                              width: 250,
                              child: Text(user.about ?? "",
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                  textAlign: TextAlign.center)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            height: 2,
                            width: 350,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text("Work",
                              style: GoogleFonts.jura(
                                  textStyle: TextStyle(
                                      color: Colors.white, fontSize: 22))),
                        )
                      ],
                    )
                    ]);
                  })
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              height: 500,
              width: 0,
              child: Consumer<PostViewModel>(
                builder: (context, postViewModel, _) {
                  if (postViewModel.userPosts.isEmpty) {
                    return const Center(
                      child: Text(
                        "No posts available",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  // Display user posts in GridView.builder
                  return GridView.builder(
                    physics: const ScrollPhysics(),
                    itemCount: postViewModel.userPosts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      PostModel post = postViewModel.userPosts[index];

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 120,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, PostViewScreen.routeName, arguments: post);
                                  },
                                  child: Image.network(post.postImage ?? "")),

                            ),

                            SizedBox(height: 3),

                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Container(
                                width: 70,
                                child: Text(
                                  post.title ?? "",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          )
        ])
    );
  }
}
