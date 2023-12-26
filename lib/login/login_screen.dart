import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slate/navigation/navigation.dart';
import 'package:slate/register/register_screen.dart';
import 'package:slate/widget/common_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //final initializes sth only once
  //TextEditingController has to be created for every text field
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 155.0, top: 100.0, bottom: 20.0),
                  child: Image.asset("assets/images/slate logo.png",
                    height: 110,
                    width: 110,),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 135.0, bottom: 80.0),
                  child: Text("SLATE", style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 48, color: Colors.white))),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 45.0),
                  child: Text("Email address", style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 22, color: Colors.white))),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(45.0, 8.0, 45.0, 40.0),
                  child: CommonTextField(
                    controller: _emailController,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 45.0),
                  child: Text("Password", style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 22, color: Colors.white))),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(45.0, 8.0, 45.0, 30.0),
                  child: CommonTextField(
                    obscureText: true,
                    controller: _passwordController,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 45.0,top: 30.0),
                  child: ElevatedButton(onPressed: () async{
                    try {
                      final user = await auth.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text);
                      if(user.user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login successful")));

                        Navigator.pushReplacementNamed(context, NavigationScreen.routeName);
                      }
                    } on Exception catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())));
                      // TODO
                    }
                  },

                      child: Text("Login", style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 20))),

                      style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                              Size(325.00, 60.0)
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)
                              )
                          ),
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(color: Colors.white)
                          )
                      )
                  ),
                ),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0, top: 115.0),
                      child: Text("Don't have an account?",
                      style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 114.0, left: 15.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                            child: Text("Sign up",
                                style: GoogleFonts.jura(textStyle: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline))),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
                        },),
                      ),
                    ),
                  ],
                ),
              ]
          ),
        )
    );
  }
}
