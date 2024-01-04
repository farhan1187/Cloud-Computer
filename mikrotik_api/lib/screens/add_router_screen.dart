import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mikrotik_api/services/firebaseaddrouter.dart';
import 'package:mikrotik_api/widgets/custom_snacbar.dart';
import 'package:mikrotik_api/widgets/text_form_field_widget.dart'; // Import your custom text form field here
import 'package:responsive_builder/responsive_builder.dart';

class AddRouterScreen extends StatefulWidget {
  const AddRouterScreen({super.key});

  @override
  AddRouterScreenState createState() => AddRouterScreenState();
}

class AddRouterScreenState extends State<AddRouterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dnsController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _deviceNameController = TextEditingController();
  final _hotspotController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  void _clearTextFields() {
    _dnsController.clear();
    _portController.clear();
    _usernameController.clear();
    _passwordController.clear();
    _deviceNameController.clear();
    _hotspotController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Router'),
      ),
      body: SafeArea(
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
                          labelText: 'DNS',
                          controller: _dnsController,
                          errortext: 'DNS is empty',
                          keybordtype: TextInputType.text,
                        ),
                        SizedBox(height: verticalSpaceBetweenTextFields),
                        CustomTextField(
                          labelText: 'Port',
                          controller: _portController,
                          errortext: 'Port is empty',
                          keybordtype: TextInputType.number,
                        ),
                        SizedBox(height: verticalSpaceBetweenTextFields),
                        CustomTextField(
                          labelText: 'Username',
                          controller: _usernameController,
                          errortext: 'Username is empty',
                          keybordtype: TextInputType.text,
                        ),
                        SizedBox(height: verticalSpaceBetweenTextFields),
                        CustomTextField(
                          labelText: 'Password',
                          controller: _passwordController,
                          errortext: 'Password is empty',
                          keybordtype: TextInputType.text,
                        ),
                        SizedBox(height: verticalSpaceBetweenTextFields),
                        CustomTextField(
                          labelText: 'Hotspot',
                          controller: _hotspotController,
                          errortext: 'Hotspot Name is empty',
                          keybordtype: TextInputType.text,
                        ),
                        SizedBox(height: verticalSpaceBetweenTextFields),
                        CustomTextField(
                          labelText: 'Device Name',
                          controller: _deviceNameController,
                          errortext: 'Device Name is empty',
                          keybordtype: TextInputType.text,
                        ),
                        SizedBox(
                          height: verticalSpaceBetweenTextFieldAndButton,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                CustomSnackBar.showSnackBar(context,
                                    'Sucessfully Binded your device...');
                              });
                              if (_formKey.currentState!.validate()) {
                                String dns = _dnsController.text.trim();
                                int port = int.parse(_portController.text);
                                String username =
                                    _usernameController.text.trim();
                                String password =
                                    _passwordController.text.trim();
                                String deviceName =
                                    _deviceNameController.text.trim();
                                String hotspot = _hotspotController.text.trim();

                                Map<String, dynamic> routerDetails = {
                                  'dns': dns,
                                  'port': port,
                                  'username': username,
                                  'password': password,
                                  'deviceName': deviceName,
                                  'hotspot': hotspot,
                                };
                                Future.delayed(const Duration(seconds: 1), () {
                                  Navigator.pushReplacementNamed(
                                      context, 'Navigate_to_Home_Screen');
                                });
                                // Replace 'currentUserId' with the actual user ID
                                User? user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  String currentUserId = user.uid;
                                  _firebaseService.addOrUpdateRouterDetails(
                                      currentUserId, routerDetails);
                                } else {
                                  // print('No user signed in.');
                                }
                              }
                              _clearTextFields();
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Colors.blue // Text color set to white
                                ),
                            child: const Text('Save'),
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
