import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slate/login/login_screen.dart';
import 'package:slate/model/UserModel.dart';
import 'package:slate/register/components/header.dart';
import 'package:slate/view_model/user_view_model.dart';
import 'package:slate/widget/common_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key});
  static const String routeName = "/register";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final database = FirebaseFirestore.instance;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  late UserViewModel _userViewModel;

  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserViewModel>(
        builder: (context, user, child) {
          return Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegisterHeader(),
                  Padding(
                    padding: const EdgeInsets.only(left: 45.0),
                    child: Text(
                      "Full name",
                      style: GoogleFonts.jura(
                          textStyle:
                          TextStyle(fontSize: 22, color: Colors.white)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(45.0, 8.0, 45.0, 20.0),
                    child: CommonTextField(
                      controller: _fullNameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45.0),
                    child: Text(
                      "Username",
                      style: GoogleFonts.jura(
                          textStyle:
                          TextStyle(fontSize: 22, color: Colors.white)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(45.0, 8.0, 45.0, 20.0),
                    child: CommonTextField(
                      controller: _userNameController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45.0),
                    child: Text(
                      "Email address",
                      style: GoogleFonts.jura(
                          textStyle:
                          TextStyle(fontSize: 22, color: Colors.white)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(45.0, 8.0, 45.0, 20.0),
                    child: CommonTextField(
                      controller: _emailController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45.0),
                    child: Text(
                      "Password",
                      style: GoogleFonts.jura(
                          textStyle:
                          TextStyle(fontSize: 22, color: Colors.white)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(45.0, 8.0, 45.0, 30.0),
                    child: CommonTextField(
                      obscureText: true,
                      controller: _passwordController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45.0, top: 0.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        UserModel data = UserModel(
                          email: _emailController.text,
                          fullname: _fullNameController.text,
                          password: _passwordController.text,
                          username: _userNameController.text,
                        );

                        user.saveData(data);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Account successfully created'),
                          ),
                        );
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      },
                      child: Text("Sign up",
                          style: GoogleFonts.jura(
                              textStyle: TextStyle(fontSize: 20))),
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all<Size>(
                            Size(325.00, 60.0)),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(color: Colors.white)),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 100.0, top: 20.0),
                        child: Text(
                            "Already have an account?",
                            style: GoogleFonts.jura(
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 19.0, left: 15.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            child: Text("Login",
                                style: GoogleFonts.jura(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        decoration:
                                        TextDecoration.underline))),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, LoginScreen.routeName);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
