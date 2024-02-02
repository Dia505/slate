import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slate/model/UserModel.dart';
import 'package:slate/navigation/navigation.dart';
import 'package:slate/register/components/header.dart';
import 'package:slate/register/register_screen.dart';
import 'package:slate/view_model/user_view_model.dart';
import 'package:slate/widget/common_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserViewModel>(
        builder: (context, user, child) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RegisterHeader(),
                Padding(
                  padding: const EdgeInsets.only(left: 45.0, top: 90.0),
                  child: Text(
                    "Email address",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(45.0, 8.0, 45.0, 40.0),
                  child: CommonTextField(
                    controller: _emailController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 45.0),
                  child: Text(
                    "Password",
                    style: TextStyle(fontSize: 22, color: Colors.white),
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
                  padding: const EdgeInsets.only(left: 45.0, top: 30.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        UserModel data = UserModel(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        // Call the loginUser method in the UserViewModel
                        await user.loginUser(data);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Login successful")),
                        );

                        Navigator.pushReplacementNamed(
                          context,
                          NavigationScreen.routeName,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Invalid credentials")),
                        );
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        Size(325.00, 60.0),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.black,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isLoading,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0, top: 115.0),
                      child: Text(
                        "Don't have an account?",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 114.0, left: 15.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              RegisterScreen.routeName,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
