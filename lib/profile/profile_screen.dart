import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slate/login/login_screen.dart';
import 'package:slate/model/UserModel.dart';
import 'package:slate/profile/edit_profile.dart';
import 'package:slate/view_model/user_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String routeName = "/profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final database = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserModel? _user;
  String ? userId;
  List<String> data = [
    "assets/images/dali in the ocean.jpg",
    "assets/images/dali in the ocean.jpg",
    "assets/images/dali in the ocean.jpg"
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
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
              padding: const EdgeInsets.only(left: 170.0),
              child: ElevatedButton(
                  onPressed: () async{
                    final preference = await SharedPreferences.getInstance();
                    preference.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('You have logged out'),
                      ),
                    );
                    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                  },
                  child: Text("Logout",
                      style:
                          GoogleFonts.jura(textStyle: TextStyle(fontSize: 12))),
                  style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all<Size>(Size(77.0, 0.0)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(color: Colors.white)))),
            ),
          ],
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
                              backgroundImage:
                                  AssetImage("assets/images/dali in the ocean.jpg"),
                              radius: 60,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 25.0, top: 40.0),
                            child: GestureDetector(
                                child: Text("Edit", style: GoogleFonts.jura(textStyle: TextStyle(color: Colors.white))),
                            onTap: () {
                              Navigator.pushNamed(context, EditProfile.routeName);
                            },),
                          )
                        ],
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
                  );
                })
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            height: 500,
            width: 0,
            child: GridView.builder(
                physics: const ScrollPhysics(),
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) => Container(
                      height: 115,
                      width: 75,
                      child: Image.asset(data[index]),
                    )),
          ),
        )
      ]),
    );
  }
}