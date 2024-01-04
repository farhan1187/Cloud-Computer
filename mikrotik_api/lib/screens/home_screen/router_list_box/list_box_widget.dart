import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mikrotik_api/screens/home_screen/router_list_box/router_dropdown_widget.dart';

// ignore: camel_case_types
class List_Box_Widget extends StatefulWidget {
  final Function(
    String deviceName,
    String dns,
    int port,
    String username,
    String password,
    String hotspot,
  )? onDeviceSelected;

  const List_Box_Widget({super.key, this.onDeviceSelected});

  @override
  ListBoxWidgetState createState() => ListBoxWidgetState();
}

class ListBoxWidgetState extends State<List_Box_Widget> {
  String? selectedDevice;
  List<String> deviceList = [];

  @override
  void initState() {
    super.initState();
    fetchDeviceListForCurrentUser();
  }

  Future<void> fetchDeviceListForCurrentUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('router_details')
            .get();

        setState(() {
          deviceList = userSnapshot.docs
              .map((doc) => doc['deviceName'] as String)
              .toList();
        });
      }
    } catch (e) {
      //   print('Error fetching device list: $e');
    }
  }

  Future<void> fetchDeviceDetails(String deviceName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot routerSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('router_details')
            .where('deviceName', isEqualTo: deviceName)
            .get();

        if (routerSnapshot.docs.isNotEmpty) {
          DocumentSnapshot deviceSnapshot = routerSnapshot.docs.first;
          Map<String, dynamic>? deviceData =
              deviceSnapshot.data() as Map<String, dynamic>?;

          if (deviceData != null) {
            String dns = deviceData['dns'] ?? '';
            int port = deviceData['port'] ?? '';
            String username = deviceData['username'] ?? '';
            String password = deviceData['password'] ?? '';
            String hotspot = deviceData['hotspot'] ?? '';

            widget.onDeviceSelected?.call(
              deviceName,
              dns,
              port,
              username,
              password,
              hotspot,
            );
          } else {
            //  print('Device data is null');
          }
        } else {
          //  print('No device found with deviceName: $deviceName');
        }
      }
    } catch (e) {
      //  print('Error fetching device details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RouterDropdownWidget(
      deviceList: deviceList,
      selectedDevice: selectedDevice,
      onChanged: (String? newValue) {
        setState(() {
          selectedDevice = newValue;
        });
        if (newValue != null) {
          fetchDeviceDetails(newValue);
        }
      },
    );
  }
}
