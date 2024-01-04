import 'package:flutter/material.dart';

class SelectedDataModel extends ChangeNotifier {
  String selectedDns = '';
  int selectedPort = 0;
  String selectedUsername = '';
  String selectedPassword = '';
  String selectedHotspot = '';
  // Add other necessary fields

  // Add a method to check if the data is fully selected
  bool get isDataSelected =>
      selectedDns.isNotEmpty &&
      selectedPort != 0 &&
      selectedUsername.isNotEmpty &&
      selectedPassword.isNotEmpty &&
      selectedHotspot.isNotEmpty;

  // Method to update the selected data
  void updateSelectedData({
    required String dns,
    required int port,
    required String username,
    required String password,
    required String hotspot,
    // Add other necessary parameters
  }) {
    selectedDns = dns;
    selectedPort = port;
    selectedUsername = username;
    selectedPassword = password;
    selectedHotspot = hotspot;
    // Update other necessary fields

    notifyListeners(); // Notify listeners about the change
  }
}
