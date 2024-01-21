import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mikrotik_api/services/authservice.dart';
import 'package:mikrotik_api/services/chek_subscription_status.dart';
import 'package:mikrotik_api/services/reser_password.dart';
import 'package:mikrotik_api/widgets/custom_button.dart';
import 'package:mikrotik_api/widgets/text_form_field_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class resetPasswordSceeen extends StatefulWidget {
  const resetPasswordSceeen({super.key});

  @override
  State<resetPasswordSceeen> createState() => _ScreenResetPasswordState();
}

class _ScreenResetPasswordState extends State<resetPasswordSceeen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void saveLoginStatus() {
    AuthService().saveLoginStatus();
  }

  void onSignInPressed(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Successful login, navigate to home screen
        SubscriptionService.checkSubscriptionStatus(context);
        saveLoginStatus();
      }
    } on FirebaseAuthException catch (e) {
      //  print('Error: $e');
      String errorMessage = 'an error occured';

      if (e.code == 'invalid-credential') {
        errorMessage = 'email or password incorrect.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      }

      // Displaying a Snackbar with the error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              top: 50.0,
              left: 10.0,
              right: 10.0,
              bottom: MediaQuery.of(context).size.height - 100),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                double formWidth = sizingInformation.isMobile ? 300.0 : 400.0;

                double verticalSpaceBetweenTextFieldAndButton =
                    sizingInformation.isMobile ? 20.0 : 20.0;

                return SizedBox(
                  width: formWidth,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextField(
                          labelText: 'Email',
                          controller: _emailController,
                          errortext: 'email field is empty',
                          keybordtype: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: verticalSpaceBetweenTextFieldAndButton,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Reset Password',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                PasswordReset.resetPassword(
                                    context, _emailController.text);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
