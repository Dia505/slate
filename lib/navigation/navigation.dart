import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slate/model/UserModel.dart';
import 'package:slate/post/post_upload.dart';
import 'package:slate/profile/profile_screen.dart';
import 'package:slate/view_model/user_view_model.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});
  static const String routeName = "/navigation";

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final database = FirebaseFirestore.instance;
  UserModel? _user;
  String ? userId;
  PageController _controller = PageController(initialPage: 0);
  int currentIndex = 0;

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
      UserViewModel userViewModel = Provider.of<UserViewModel>(context, listen: false);
      UserModel? userData = await userViewModel.fetchUserDataById(userId!);

      if (userData != null) {
        setState(() {
          _user = userData;
        });
      }
    }
  }

  File ? file;
  String ? tempUrl;
  //ImageSource denotes camera or gallery
  void pickImage(ImageSource source) async{
    var selected = await ImagePicker().pickImage(source: source, imageQuality: 100);

    if(selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No image selected")));
    }
    else {
      setState(() {
        file = File(selected.path);
      });

      print("Image selected: ${file?.path}");

      Navigator.pushNamed(context, PostUploadScreen.routeName, arguments: file);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:
          Stack(
            children: [
              PageView(
                controller: _controller,
                onPageChanged: (int value){
                  setState(() {
                    currentIndex=value;
                  });
                },
                children: [
                  Container(color: Colors.red,),
                  Container(color: Colors.green,),
                  ProfileScreen()
                ],
              ),

              Positioned(
                left: 50,
                right: 50,
                bottom: 15,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Container(
                    width: 100,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                            color: Colors.white,
                            width: 2.0
                        )
                    ),

                    child: Column(
                      children: [
                        StreamBuilder<DocumentSnapshot> (
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
                              as Map<String, dynamic>);

                              return Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 45.0),
                                    child: Image.asset("assets/images/home.png",
                                      height: 30.0,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 35.0),
                                    child: Image.asset("assets/images/search.png",
                                      height: 25.0,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 33.0),
                                    child: InkWell(
                                        onTap: () {
                                          pickImage(ImageSource.gallery);
                                          Navigator.pushNamed(context, '/post');
                                        },
                                        child: Image.asset("assets/images/plus.png",
                                          height: 30.0)),
                                  ),

                                  Padding(
                                      padding: const EdgeInsets.only(left: 25.0, top: 5.0),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            currentIndex =3;
                                          });
                                          _controller.jumpToPage(currentIndex);
                                        },
                                        child: CircleAvatar(
                                            backgroundImage: _user?.profileImage != null
                                                ? NetworkImage(_user!.profileImage!)
                                                : AssetImage("assets/images/profile.png") as ImageProvider,
                                            radius: 16),
                                      )
                                  )
                                ],
                              );
                            })
                      ],
                    )
                  ),
                ),
              ),
            ]
          ),
    );
  }
}
