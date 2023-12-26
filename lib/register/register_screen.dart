import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slate/login/login_screen.dart';
import 'package:slate/widget/common_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = "/register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final database = FirebaseDatabase.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                    padding: const EdgeInsets.only(left: 135.0, bottom: 0.0),
                    child: Text("SLATE", style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 48, color: Colors.white))),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 45.0),
                    child: Text("Full name", style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 22, color: Colors.white))),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(45.0, 8.0, 45.0, 20.0),
                    child: CommonTextField(
                      controller: _fullNameController,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 45.0),
                    child: Text("Username", style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 22, color: Colors.white))),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(45.0, 8.0, 45.0, 20.0),
                    child: CommonTextField(
                      controller: _userNameController,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 45.0),
                    child: Text("Email address", style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 22, color: Colors.white))),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(45.0, 8.0, 45.0, 20.0),
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
                      validator: (value){
                        if(value!.length < 6){
                          return "Password should be at least 6 characters long";
                        }
                        return "";
                      },
                      obscureText: true,
                      controller: _passwordController,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 45.0,top: 0.0),
                    child: isLoading == true
                      ? Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator())
                    : ElevatedButton(onPressed: () async{
                      if(formKey.currentState!.validate()) {
                        var data = {
                          "fullName": _fullNameController.text,
                          "userName": _userNameController.text,
                          "email": _emailController.text,
                          "password": _passwordController.text
                        };

                        await database.ref().child("User").push().set(data).then((value) {
                          print("success");
                          ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Registration successful")));

                          _fullNameController.clear();
                          _userNameController.clear();
                          _emailController.clear();
                          _passwordController.clear();
                          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                        }).onError((error, stackTrace) {
                          print(error.toString());
                        });

                        // setState(() {
                        //   isLoading = true;
                        // });
                        // try {
                        //   final user = await auth.createUserWithEmailAndPassword(
                        //       email: _emailController.text,
                        //       password: _passwordController.text);
                        //   if(user.user != null) {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(content: Text("Registration successful")));
                        //     Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                        //     setState(() {
                        //       isLoading = false;
                        //     });
                        //   }
                        // } on Exception catch (e) {
                        //   setState(() {
                        //     isLoading = false;
                        //   });
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(content: Text(e.toString())));
                        //   // TODO
                        // }
                      }
                    },

                        child: Text("Sign up", style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 20))),

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
                        padding: const EdgeInsets.only(left: 100.0, top: 20.0),
                        child: Text("Already have an account?",
                            style: GoogleFonts.jura(textStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 19.0, left: 15.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            child: Text("Login",
                              style: GoogleFonts.jura(textStyle: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold, decoration: TextDecoration.underline))),
                            onTap: () {
                              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                            },),
                        ),
                      ),
                    ],
                  ),
                ]
            ),
          ),
        )
    );
  }
}
