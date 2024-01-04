import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final String errortext;
  final TextInputType keybordtype;
  final ValueChanged<String>? onChanged; // Added onChanged callback

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    required this.errortext,
    required this.keybordtype,
    this.onChanged, // Initialize onChanged parameter
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keybordtype,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color.fromARGB(
              255, 255, 255, 255), // Change label text color when focused
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.white), // Set focused underline color to white
        ),
      ),
      style: const TextStyle(color: Colors.white),
      controller: controller,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return (errortext);
        }
        return null;
      },
      onChanged: onChanged, // Assign onChanged callback to TextFormField
    );
  }
}
