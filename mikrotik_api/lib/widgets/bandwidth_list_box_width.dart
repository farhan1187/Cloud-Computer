import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MikroTikDataListBox extends StatefulWidget {
  final String dns;
  final int port;
  final String username;
  final String password;
  final Function(String) onDataSelected; // Function to pass rate-limit

  const MikroTikDataListBox({
    super.key,
    required this.dns,
    required this.port,
    required this.username,
    required this.password,
    required this.onDataSelected,
  });

  @override
  MikroTikDataListBoxState createState() => MikroTikDataListBoxState();
}

class MikroTikDataListBoxState extends State<MikroTikDataListBox> {
  String? selectedData;
  Map<String, String> dataMap = {}; // Map to store name and rate-limit

  @override
  void initState() {
    super.initState();
    fetchAndSetData();
  }

  @override
  void didUpdateWidget(MikroTikDataListBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dns != widget.dns ||
        oldWidget.port != widget.port ||
        oldWidget.username != widget.username ||
        oldWidget.password != widget.password) {
      setState(() {
        selectedData = null;
        dataMap.clear();
        // Clear selected data when DNS or port changes
      });
      fetchAndSetData();
    }
  }

  Future<void> fetchAndSetData() async {
    Map<String, String> data = await fetchDataFromMikroTik(
      widget.dns,
      widget.port,
      widget.username,
      widget.password,
    );
    setState(() {
      dataMap = data;
      if (dataMap.isNotEmpty) {
        selectedData = dataMap.keys.first;
      }
    });
  }

  Future<Map<String, String>> fetchDataFromMikroTik(
    String dns,
    int port,
    String username,
    String password,
  ) async {
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    var url =
        'http://$dns:$port/rest/ip/hotspot/user/profile'; // Replace with your MikroTik URL

    final uri = Uri.parse(url);

    final response = await http.get(uri, headers: {
      'Authorization': basicAuth,
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      Map<String, String> data = {};
      for (var item in jsonData) {
        String dataName = item['name'];

        data[dataName] = dataName;
      }
      return data;
    } else {
      //  print('Failed to fetch data: ${response.statusCode}');
      return {};
    }
  }

  String? _validateDevice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a device'; // Validation message
    }
    return null; // Return null when validation succeeds
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black54,
        ),
        child: DropdownButtonFormField<String>(
          value: selectedData,
          items: dataMap.keys.map((String data) {
            return DropdownMenuItem<String>(
              value: data,
              child: Text(
                data,
                style: const TextStyle(color: Colors.lightBlue),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedData = newValue;
            });
            if (newValue != null && dataMap.containsKey(newValue)) {
              String bandWidth = dataMap[newValue]!;
              widget.onDataSelected(
                  bandWidth); // Pass rate-limit to the callback function
            }
          },
          validator: _validateDevice,
          iconEnabledColor: Colors.green,
          decoration: const InputDecoration(
            labelText: 'Select Data',
            labelStyle: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
