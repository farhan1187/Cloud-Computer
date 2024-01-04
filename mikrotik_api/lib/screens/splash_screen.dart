import 'package:flutter/material.dart';
import 'package:mikrotik_api/services/authservice.dart';
import 'package:mikrotik_api/services/chek_subscription_status.dart';
import 'package:mikrotik_api/widgets/centered_text_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool showCenteredText =
      true; // Flag to control the visibility of CenteredTextWidget

  @override
  void initState() {
    super.initState();
    // Check login status when the SplashScreen is initialized
    AuthService().isLoggedIn().then((isLoggedIn) {
      if (mounted) {
        setState(() {
          showCenteredText = false; // Hide CenteredTextWidget
        });

        if (isLoggedIn) {
          SubscriptionService.checkSubscriptionStatus(context);
        } else {
          Navigator.of(context)
              .pushReplacementNamed('Navigate_to_signIn_Screen');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: CenteredTextWidget());
  }
}
