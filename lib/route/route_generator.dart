import 'package:flutter/material.dart';
import 'package:slate/login/login_screen.dart';
import 'package:slate/navigation/navigation.dart';
import 'package:slate/profile/edit_profile.dart';
import 'package:slate/splash/splash_screen.dart';
import 'package:slate/register/register_screen.dart';
import 'package:slate/profile/profile_screen.dart';

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
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case NavigationScreen.routeName:
        return MaterialPageRoute(builder: (_) => const NavigationScreen());

      case ProfileScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case EditProfile.routeName:
        return MaterialPageRoute(builder: (_) => const EditProfile());

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