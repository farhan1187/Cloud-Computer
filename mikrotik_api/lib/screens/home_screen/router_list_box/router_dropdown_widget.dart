import 'package:flutter/material.dart';

class RouterDropdownWidget extends StatelessWidget {
  final List<String> deviceList;
  final String? selectedDevice;
  final ValueChanged<String?>? onChanged;

  const RouterDropdownWidget({
    super.key,
    required this.deviceList,
    required this.selectedDevice,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black54,
      ),
      child: DropdownButtonFormField<String>(
        value: selectedDevice,
        items: deviceList.map((String device) {
          return DropdownMenuItem<String>(
            value: device,
            child: Row(
              children: [
                const Icon(Icons.cloud_outlined), // Router icon
                const SizedBox(width: 15),
                Text(
                  device,
                  style: const TextStyle(color: Colors.lightBlue),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
        iconEnabledColor: Colors.green,
        decoration: const InputDecoration(
          labelText: 'Select Device',
          labelStyle: TextStyle(
            color: Color.fromARGB(
              255,
              255,
              255,
              255,
            ), // Change label text color when focused
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ), // Remove underline
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ), // Set focused underline color to white
          ),
        ),
      ),
    );
  }
}
