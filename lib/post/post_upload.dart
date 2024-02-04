import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slate/model/PostModel.dart';
import 'package:slate/model/UserModel.dart';
import 'package:slate/navigation/navigation.dart';
import 'package:slate/profile/profile_screen.dart';
import 'package:slate/service/firebase_service.dart';
import 'package:slate/view_model/post_view_model.dart';
import 'package:slate/widget/common_text_field.dart';

class PostUploadScreen extends StatefulWidget {
  final File? imageFile;
  const PostUploadScreen({Key? key, required this.imageFile}) : super(key: key);
  static const String routeName = "/post";

  @override
  State<PostUploadScreen> createState() => _PostUploadScreenState();
}

class _PostUploadScreenState extends State<PostUploadScreen> {
  UserModel? _user;
  String? userId;
  PostModel? _post;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final preference = await SharedPreferences.getInstance();
    setState(() {
      userId = preference.getString("userId");
    });

    if (userId != null) {
      DocumentSnapshot userSnapshot =
      await FirebaseService.db.collection("User").doc(userId).get();

      Map<String, dynamic>? userData =
      userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        setState(() {
          _user = UserModel.fromJson(userData);

          _titleController.text = _post?.title ?? "";
          _descriptionController.text = _post?.description ?? "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final File? imageFile = widget.imageFile;

    return Scaffold(
      body: ListView(
        children: [
          Row(
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
                      textStyle: TextStyle(color: Colors.white, fontSize: 24))),

              Padding(
                padding: const EdgeInsets.only(left: 200.0),
                child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, NavigationScreen.routeName);
                      // Navigator.p(context, ProfileScreen.routeName);
                    },
                    child: Image.asset(
                      "assets/images/back.png",
                      height: 30.0,
                    )),
              )
            ],
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
                child: Text("New post",
                    style: GoogleFonts.jura(
                        textStyle: TextStyle(color: Colors.white, fontSize: 24))),
              ),

              if (imageFile != null)
                Image.file(imageFile, height: 320,)
              else
                Text('No image selected', style: TextStyle(color: Colors.white)),

              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 270.0),
                child: Text("Title",
                    style: GoogleFonts.jura(
                        textStyle: TextStyle(color: Colors.white, fontSize: 20))),
              ),

              Container(
                width: 300,
                child: TextFormField(
                  controller: _titleController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Tell everyone what your work is about",
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),

                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    )
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 200.0),
                child: Text("Description",
                    style: GoogleFonts.jura(
                        textStyle: TextStyle(color: Colors.white, fontSize: 20))),
              ),

              Container(
                width: 300,
                child: TextFormField(
                  controller: _descriptionController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Add a detailed description",
                      hintStyle: TextStyle(color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),

                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      )
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 80.0, left: 200.0),
                child: ElevatedButton(
                    onPressed: () async{
                      await Provider.of<PostViewModel>(context, listen: false).uploadPost(
                          _titleController.text,
                          _descriptionController.text,
                          imageFile!
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Successfully posted'),
                        ),
                      );
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                    child: Text("Post",
                        style:
                        GoogleFonts.jura(textStyle: TextStyle(fontSize: 16))),
                    style: ButtonStyle(
                        fixedSize:
                        MaterialStateProperty.all<Size>(Size(100.0, 0.0)),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(color: Colors.white)))
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
