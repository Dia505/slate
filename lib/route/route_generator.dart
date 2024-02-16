import 'dart:io';

import 'package:flutter/material.dart';
import 'package:slate/login/login_screen.dart';
import 'package:slate/model/PostModel.dart';
import 'package:slate/navigation/navigation.dart';
import 'package:slate/post/post_upload.dart';
import 'package:slate/post/post_view.dart';
import 'package:slate/profile/edit_profile.dart';
import 'package:slate/splash/splash_screen.dart';
import 'package:slate/register/register_screen.dart';
import 'package:slate/profile/profile_screen.dart';
import 'package:slate/home/home_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    //settings has two properties: name, argument
    final arg = settings.arguments;

    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case RegisterScreen.routeName:
        return MaterialPageRoute(builder: (_) =>  const RegisterScreen());

      case NavigationScreen.routeName:
        return MaterialPageRoute(builder: (_) => const NavigationScreen());

      case ProfileScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case EditProfile.routeName:
        return MaterialPageRoute(builder: (_) => const EditProfile());

      case PostUploadScreen.routeName:
        final File? imageFile = settings.arguments as File?;
        return MaterialPageRoute(builder: (_) => PostUploadScreen(imageFile: imageFile));

      case PostViewScreen.routeName:
        var post = settings.arguments as PostModel;
        return MaterialPageRoute(builder: (_) => PostViewScreen(post: post,));

      case HomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      default:
        _onPageNotFound();
    }
  }

  static Route<dynamic> _onPageNotFound() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(body: Text("Page not found")),
    );
  }
}