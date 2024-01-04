import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mikrotik_api/services/authservice.dart';
import 'package:mikrotik_api/widgets/custom_button.dart';
import 'package:mikrotik_api/widgets/text_form_field_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            double formWidth = sizingInformation.isMobile ? 300.0 : 400.0;
            double verticalSpaceBetweenTextFields =
                sizingInformation.isMobile ? 10.0 : 10.0;
            double verticalSpaceBetweenTextFieldAndButton =
                sizingInformation.isMobile ? 20.0 : 20.0;

            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: formWidth,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      labelText: 'Email',
                      controller: _emailController,
                      errortext: 'email field is empty',
                      keybordtype: TextInputType.emailAddress,
                    ),
                    SizedBox(height: verticalSpaceBetweenTextFields),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        prefixText: '+971 ',
                        prefixStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      controller: _phoneNumberController,
                      onChanged: (value) {
                        if (value.startsWith('+971') && value.length > 9) {
                          setState(() {
                            _phoneNumberController.text =
                                '+971${value.substring(4, 13)}';
                            _phoneNumberController.selection =
                                const TextSelection.collapsed(offset: 7);
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 9) {
                          return 'Please enter a valid Phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: verticalSpaceBetweenTextFields),
                    CustomTextField(
                      labelText: 'User Name',
                      controller: _usernameController,
                      errortext: 'User Name field is empty',
                      keybordtype: TextInputType.text,
                    ),
                    SizedBox(height: verticalSpaceBetweenTextFields),
                    TextFormField(
                      obscureText: _isObscure,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
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
                        if (value == null ||
                            value.isEmpty ||
                            value.length <= 8) {
                          return 'Please enter a Strong Password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: verticalSpaceBetweenTextFieldAndButton),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Sign UP',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signUpUser(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              _usernameController.text.trim(),
                              _phoneNumberController.text.trim(),
                            );
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
    );
  }

  Future<void> signUpUser(
    String email,
    String password,
    String username,
    String phoneNumber,
  ) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'user_name': username,
          'phone_number': phoneNumber,
          'email': email,
          'start_date': DateTime.now(),
          'end_date': DateTime.now(),
        });

        //   print('User created: ${user.uid}');
        _authService.saveLoginStatus();
        Navigator.of(context).pushReplacementNamed('Navigate_to_Home_Screen');
      }
    } catch (e) {
      //  print('Error creating user: $e');
    }
  }
}
