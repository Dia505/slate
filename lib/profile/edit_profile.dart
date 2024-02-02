import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slate/model/UserModel.dart';
import 'package:slate/widget/common_text_field.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});
  static const String routeName = "/editProfile";

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final database = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserModel? _user;
  String? userId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

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
      // Fetch additional user data from Firestore using UserModel
      DocumentSnapshot userSnapshot =
          await database.collection("User").doc(userId).get();

      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        setState(() {
          _user = UserModel.fromJson(userData);

          _nameController.text = _user?.fullname ?? "";
          _userNameController.text = _user?.username ?? "";
          _bioController.text = _user?.about ?? "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 10.0, top: 50.0),
                child: Image.asset(
                  "assets/images/slate logo.png",
                  height: 35,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text("SLATE",
                    style: GoogleFonts.jura(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 24))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 55.0, left: 220.0),
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.p(context, ProfileScreen.routeName);
                    },
                    child: Image.asset(
                      "assets/images/cross.png",
                      height: 30.0,
                    )),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: CircleAvatar(
              backgroundImage:
                  AssetImage("assets/images/dali in the ocean.jpg"),
              radius: 60,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
                onPressed: () {},
                child: Text("Edit",
                    style:
                        GoogleFonts.jura(textStyle: TextStyle(fontSize: 14))),
                style: ButtonStyle(
                    fixedSize:
                        MaterialStateProperty.all<Size>(Size(49.0, 24.0)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.white)))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 300.0),
            child: Text("Name",
                style: GoogleFonts.jura(
                    textStyle: TextStyle(color: Colors.white, fontSize: 20))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CommonTextField(
              controller: _nameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 300.0),
            child: Text("Username",
                style: GoogleFonts.jura(
                    textStyle: TextStyle(color: Colors.white, fontSize: 20))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CommonTextField(
              controller: _userNameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 300.0),
            child: Text("About",
                style: GoogleFonts.jura(
                    textStyle: TextStyle(color: Colors.white, fontSize: 20))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CommonTextField(
                controller: _bioController
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
                onPressed: () {
                  var data = {
                    "fullname": _nameController.text,
                    "username": _userNameController.text,
                    "bio": _bioController.text
                  };
                  database.collection("User").doc(userId).update(data);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Your profile has been edited'),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text("Confirm changes",
                    style: GoogleFonts.jura(
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold))),
                style: ButtonStyle(
                    fixedSize:
                        MaterialStateProperty.all<Size>(Size(160.0, 45.0)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.white)))),
          ),
        ],
      ),
    ));
  }
}
