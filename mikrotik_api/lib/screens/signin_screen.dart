import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mikrotik_api/services/authservice.dart';
import 'package:mikrotik_api/services/chek_subscription_status.dart';
import 'package:mikrotik_api/widgets/custom_button.dart';
import 'package:mikrotik_api/widgets/text_form_field_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ScreenSignIn extends StatefulWidget {
  const ScreenSignIn({super.key});

  @override
  State<ScreenSignIn> createState() => _ScreenSignInState();
}

class _ScreenSignInState extends State<ScreenSignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

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
                double verticalSpaceBetweenTextFields =
                    sizingInformation.isMobile ? 10.0 : 10.0;
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
                        SizedBox(height: verticalSpaceBetweenTextFields),
                        TextFormField(
                          obscureText: _isObscure,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 255, 255,
                                  255), // Change label text color when focused
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .white), // Set focused underline color to white
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password field is empty';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: verticalSpaceBetweenTextFieldAndButton,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Sign In',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                onSignInPressed(context);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: verticalSpaceBetweenTextFields),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed('Navigate_to_SignUp_Screen');
                          },
                          child: const Text(
                            'Don\'t have an account? Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                            ),
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
