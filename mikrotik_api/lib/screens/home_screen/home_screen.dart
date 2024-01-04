import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mikrotik_api/services/get_data/get_arp_list.dart';
import 'package:mikrotik_api/services/get_data/get_device_info.dart';
import 'package:mikrotik_api/screens/home_screen/router_list_box/list_box_widget.dart';
import 'package:mikrotik_api/services/authservice.dart';
import 'package:mikrotik_api/widgets/cutom_icon_button.dart';
import 'package:mikrotik_api/widgets/drower_widget.dart';
import 'package:mikrotik_api/services/selectedatamodel.dart';
import 'package:provider/provider.dart'; // Import the SelectedDataModel

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  ScreenHomeState createState() => ScreenHomeState();
}

class ScreenHomeState extends State<ScreenHome> {
  String? selectedDeviceName;
  String? deviceFirmware;
  String? boardName;
  String? cpuLoad;
  late Timer _timer;
  int? selectedARPCount;

  void onLogOutPressed() {
    AuthService().logout();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final selectedData =
          Provider.of<SelectedDataModel>(context, listen: false);

      fetchDeviceInfo(
        selectedData.selectedDns,
        selectedData.selectedPort,
        selectedData.selectedUsername,
        selectedData.selectedPassword,
      ).then((data) {
        setState(() {
          cpuLoad = data['cpu-load'];
        });
      }).catchError((error) {
        //    print('Error fetching device info: $error');
        setState(() {
          deviceFirmware = 'Error fetching';
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedData = Provider.of<SelectedDataModel>(context);
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButtonWidget(
            icon: Icons.logout,
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed('Navigate_to_signIn_Screen');
              onLogOutPressed();
            },
          )
        ],
      ),
      drawer: const CustomDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            List_Box_Widget(
              onDeviceSelected: (
                deviceName,
                dns,
                port,
                username,
                password,
                hotspot,
              ) {
                selectedData.updateSelectedData(
                  dns: dns,
                  port: port,
                  username: username,
                  password: password,
                  hotspot: hotspot,
                );

                setState(() {
                  selectedDeviceName = deviceName;
                  deviceFirmware = '';
                  boardName = '';
                  cpuLoad = '';
                });
                startTimer();

                fetchDeviceInfo(dns, port, username, password).then(
                  (data) {
                    setState(() {
                      deviceFirmware = data['version'];
                      boardName = data['board-name'];
                      cpuLoad = data['cpu-load'];
                    });
                  },
                ).catchError((error) {
                  //  print('Error fetching device info: $error');
                  setState(() {
                    deviceFirmware = 'Error fetching ';
                  });
                });
                fetchARPListWithCount(dns, port, username, password)
                    .then((arpCount) {
                  setState(() {
                    // Update the state with the fetched ARP count
                    // For example, you might store it in a variable like selectedARPCount
                    selectedARPCount = arpCount;
                  });
                }).catchError((error) {
                  //  print('Error fetching ARP count: $error');
                  setState(() {
                    // Handle the error if ARP count fetching fails
                    selectedARPCount =
                        0; // Set default value or handle as needed
                  });
                });
              },
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: screenSize.width > 600 ? 2 : 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              shrinkWrap: true,
              children: [
                // First grid box
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedDeviceName ?? "Device Name",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Board-Name : ${boardName ?? ""}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Firmware : ${deviceFirmware ?? ""}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Second grid box
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      'CPU Load : ${(cpuLoad ?? 0).toString()} %',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 43, 43, 43),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ARP List : ${selectedARPCount ?? ""}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
