import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slate/login/login_screen.dart';
import 'package:slate/navigation/navigation.dart';
import 'package:slate/post/post_upload.dart';
import 'package:slate/post/post_view.dart';
import 'package:slate/profile/profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slate/profile/user_screen.dart';
import 'package:slate/register/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  //static used for direct access
  //routeName used for identification
  static const String routeName = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //init state defines what to display when running for the first time
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //scaffold holds all widgets
    return Scaffold(
      body: Container(
        //child contains 1 widget, children can contain more
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(140.0, 150.0, 45.0, 40.0),
              child: Image.asset("assets/images/slate logo.png",
                  height: 140, width: 140),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80.0, bottom: 60.0),
              child: Text("SLATE",
                  style: GoogleFonts.jura(
                      textStyle: TextStyle(color: Colors.white, fontSize: 64))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 90.0, bottom: 20.0),
              child: Text("Explore",
                  style: GoogleFonts.jura(
                      textStyle: TextStyle(color: Colors.white, fontSize: 32))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 85.0),
              child: Icon(Icons.circle, color: Colors.white),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 90.0, bottom: 20.0, top: 20.0),
              child: Text("Share",
                  style: GoogleFonts.jura(
                      textStyle: TextStyle(color: Colors.white, fontSize: 32))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 85.0),
              child: Icon(Icons.circle, color: Colors.white),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 90.0, bottom: 60.0, top: 20.0),
              child: Text("Inspire",
                  style: GoogleFonts.jura(
                      textStyle: TextStyle(color: Colors.white, fontSize: 32))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: ElevatedButton(
                  onPressed: () async {
                    final preference = await SharedPreferences.getInstance();

                    if (preference.getString("userId") == null) {
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    }
                    else {
                      Navigator.pushReplacementNamed(
                          context, NavigationScreen.routeName);
                    }
                  },
                  child: Text("Get Started",
                      style:
                          GoogleFonts.jura(textStyle: TextStyle(fontSize: 20))),
                  style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all<Size>(Size(264.00, 55.0)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(color: Colors.white)))),
            )
          ],
        ),
      ),
    );
  }
}
