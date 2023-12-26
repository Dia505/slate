import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  String Function(String?)? validator;
  TextEditingController? controller;
  bool ? obscureText;

  CommonTextField({super.key,
  this.validator,
  this.controller,
  this.obscureText = false});

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText!,
      style: TextStyle(color: Colors.white),
      validator: widget.validator,

      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.white, width: 2)
          ),

          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white, width: 2)
          )
      ),

      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
    );
  }
}
