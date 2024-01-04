import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
            top: 50.0,
            left: 10.0,
            right: 10.0,
            bottom: MediaQuery.of(context).size.height -
                100), // Adjust the duration as needed
        action: SnackBarAction(
          label: '',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
