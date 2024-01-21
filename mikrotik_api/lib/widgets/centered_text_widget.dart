import 'package:flutter/material.dart';

class CenteredTextWidget extends StatelessWidget {
  const CenteredTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black, // Set the background color to black
      body: Center(
        child: Image(
          image: AssetImage(
              'assets/images/cfiimg.jpg'), // Replace with your image path
          fit: BoxFit.cover, // Cover the entire screen
        ),
      ),
    );
  }
}
