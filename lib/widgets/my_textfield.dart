import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool isReadOnly;
  final bool obscureText;
  //final double width;
  //final int length;

  const MyTextField({
    super.key,
    this.controller,
    this.hintText,
    this.isReadOnly = false,
    this.obscureText = false,
    //this.width = 200,
    //this.length = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: TextField(
        readOnly: isReadOnly,
        //controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          //label: const Text("Email"),
          hintText: hintText,
          //constraints: BoxConstraints(maxWidth: width),
        ),
        //maxLength: length,
        obscureText: obscureText,
      ),
    );
  }
}
