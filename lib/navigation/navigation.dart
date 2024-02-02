import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slate/profile/profile_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});
  static const String routeName = "/navigation";

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  PageController _controller = PageController(initialPage: 0);
  int currentIndex = 0;

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
      saveToStorage();
    }
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  saveToStorage() async {
    String filename = file!.path.split('/').last;
    var photo = await storage
        .ref()
        .child("user")
        .child(filename)
        .putFile(File(file!.path));
    String url = await photo.ref.getDownloadURL();
    setState(() {
      tempUrl = url;
    });
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
                  Container(color: Colors.yellowAccent,),
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
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
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
                              },
                              child: Image.asset("assets/images/plus.png")),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  currentIndex =3;
                                });
                                _controller.jumpToPage(currentIndex);
                              },
                              child: CircleAvatar(backgroundImage: AssetImage("assets/images/dali in the ocean.jpg",),
                                  radius: 17),
                            )
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]
          ),
    );
  }
}
