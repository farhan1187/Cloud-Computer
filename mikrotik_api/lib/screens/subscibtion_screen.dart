import 'package:flutter/material.dart';
import 'package:mikrotik_api/services/authservice.dart';
import 'package:mikrotik_api/widgets/cutom_icon_button.dart';

// ignore: camel_case_types
class subscibtion_screen extends StatelessWidget {
  const subscibtion_screen({super.key});

  void onLogOutPressed() {
    AuthService().logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButtonWidget(
            icon: Icons.logout,
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed('Navigate_to_signIn_Screen');
              onLogOutPressed();
            },
          )
        ],
      ),
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding:
                EdgeInsets.all(20.0), // Adjust the value to your preference

            child: Text(
              "You don't have a valid subscription plan. Kindly contact us to active your subscription plan. Thank you for your cooperation.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
