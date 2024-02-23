import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slate/model/PostModel.dart';
import 'package:slate/model/UserModel.dart';
import 'package:slate/post/post_view.dart';
import 'package:slate/view_model/post_view_model.dart';
import 'package:slate/view_model/user_view_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static const String routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PostViewModel>(context, listen: false).fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer2<PostViewModel, UserViewModel>(
        builder: (context, postViewModel, userViewModel, _) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 10.0),
                  child: Image.asset(
                    "assets/images/slate logo.png",
                    height: 35,
                  ),
                ),
                Text("SLATE",
                    style: GoogleFonts.jura(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 24))),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  width: double.infinity,
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
                    return GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 10,
                      children: List.generate(postViewModel.userPosts.length,
                          (index) {
                        PostModel post = postViewModel.userPosts[index];
                        String postUserId = post.userId;

                        return FutureBuilder<UserModel?>(
                          future: userViewModel.fetchUserDataById(postUserId),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            UserModel? userData = snapshot.data;
                            if (userData == null) {
                              return Text('User data not found');
                            }


                            String profileImageUrl =
                                userData.profileImage ?? "";
                            String username = userData.username ?? "";

                            return Column(
                              children: [
                                Container(
                                  height: 180,
                                  width: 180,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, PostViewScreen.routeName,
                                            arguments: post);
                                      },
                                      child: Image.network(
                                          post.postImage ?? "")),
                                ),
                                SizedBox(height: 3),
                                Padding(
                                  padding: const EdgeInsets.only(),
                                  child: Container(
                                    width: 150,
                                    child: Column(
                                      children: [
                                        Text(
                                          post.title ?? "",
                                          style:
                                              TextStyle(color: Colors.white),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    profileImageUrl),
                                                radius: 10,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 5.0),
                                                child: Text(username,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12)),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                    );
                  })))
        ],
      );
    }));
  }
}
