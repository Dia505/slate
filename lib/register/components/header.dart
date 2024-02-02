import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 155.0, top: 100.0, bottom: 20.0),
          child: Image.asset(
            "assets/images/slate logo.png",
            height: 110,
            width: 110,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 135.0, bottom: 0.0),
          child: Text("SLATE",
              style: GoogleFonts.jura(
                  textStyle: TextStyle(
                      fontSize: 48, color: Colors.white))),
        ),
      ],
    );
  }
}
