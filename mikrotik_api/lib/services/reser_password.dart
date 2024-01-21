import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordReset {
  static void resetPassword(BuildContext context, String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password Reset'),
          content:
              const Text('A password reset link has been sent to your email.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
