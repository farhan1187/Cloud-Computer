import 'package:flutter/material.dart';

// CustomButton widget class
class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  // Constructor to accept text and onPressed function
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue, // Text color set to white
      ), // Use the provided onPressed function
      child: Text(text), // Show the provided text on the button
    );
  }
}
