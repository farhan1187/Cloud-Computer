import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mikrotik_api/widgets/custom_button.dart';

class ScreenUserDetails extends StatefulWidget {
  const ScreenUserDetails({super.key});

  @override
  ScreenUserDetailsState createState() => ScreenUserDetailsState();
}

class ScreenUserDetailsState extends State<ScreenUserDetails> {
  late User? _user;

  late String _email = '';
  late String _phoneNumber = '';
  late String _userName = '';
  late DateTime _expieryDate = DateTime(2024, 01, 01);

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      setState(() {
        _email = userSnapshot['email'];
        _phoneNumber = userSnapshot['phone_number'];
        _userName = userSnapshot['user_name'];
        _expieryDate = userSnapshot['end_date'].toDate().toLocal();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20.0),
            _buildDetailItem('User Name:', _userName),
            _buildDetailItem('Ph Number:', _phoneNumber),
            _buildDetailItem('Email:', _email),
            _buildDetailItem('Subsciption Expiry Date:',
                DateFormat.yMMMd().format(_expieryDate)),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Reset Password',
                onPressed: () {
                  // Implement reset password functionality
                  // This button can trigger a reset password action
                  _resetPassword(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetPassword(BuildContext context) {
    // Implement your password reset logic here
    // For example, using FirebaseAuth:
    FirebaseAuth.instance.sendPasswordResetEmail(email: _email);

    // Show a dialog or message indicating that the password reset link has been sent.
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
