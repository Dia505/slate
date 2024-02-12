import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slate/model/PostModel.dart';
import 'package:slate/model/UserModel.dart';
import 'package:slate/view_model/post_view_model.dart';
import 'package:slate/view_model/user_view_model.dart';

class PostViewScreen extends StatefulWidget {
  PostModel post;
  PostViewScreen({Key? key, required this.post}) : super(key: key);

  static const String routeName = "/PostViewScreen";

  @override
  State<PostViewScreen> createState() => _PostViewScreenState();
}

class _PostViewScreenState extends State<PostViewScreen> {
  late UserViewModel userViewModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userViewModel = Provider.of<UserViewModel>(context,listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<PostViewModel, UserViewModel>(
        builder: (context, postViewModel, userViewModel, _) {


          return FutureBuilder<UserModel?>(
            future: userViewModel.fetchUserDataById(widget.post.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              final userData = snapshot.data!;
              final String profileImageUrl = userData.profileImage ?? "";
              final String username = userData.username ?? "";

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: Image.network(widget.post.postImage, height: 320),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 80, top: 20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(profileImageUrl),
                              radius: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 13),
                              child: Text(username,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start ,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15, right: 0),
                            child: Text(widget.post.title,
                                style:
                                TextStyle(color: Colors.white, fontSize: 24)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 13, left: 50),
                            child: Container(
                              width: 300,
                              child: Text(
                                widget.post.description ?? "n/a",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
