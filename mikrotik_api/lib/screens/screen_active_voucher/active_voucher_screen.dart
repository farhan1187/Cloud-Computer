import 'package:flutter/material.dart';
import 'package:mikrotik_api/services/get_data/get_active_voucher.dart';
import 'package:mikrotik_api/screens/screen_active_voucher/list_active_voucher/user_list_active.dart';
import 'package:mikrotik_api/services/selectedatamodel.dart';
import 'package:provider/provider.dart';

class ScreenActiveVoucher extends StatefulWidget {
  const ScreenActiveVoucher({super.key});

  @override
  State<ScreenActiveVoucher> createState() => _GeneratedVoucherScreenState();
}

class _GeneratedVoucherScreenState extends State<ScreenActiveVoucher> {
  String selectedDns = '';
  int selectedPort = 0;
  String selectedUsername = '';
  String selectedPassword = '';
  String selectedHotspot = '';

  List<dynamic> originalUsers = [];
  List<dynamic> displayedUsers = [];
  List<bool> selectedUsers = [];
  int selectedItemsCount = 0;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Fetch selected router data from SelectedDataModel
    final selectedData = Provider.of<SelectedDataModel>(context, listen: false);
    selectedDns = selectedData.selectedDns;
    selectedPort = selectedData.selectedPort;
    selectedUsername = selectedData.selectedUsername;
    selectedPassword = selectedData.selectedPassword;
    selectedHotspot = selectedData.selectedHotspot;
    fetchDataFromMikroTik();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: filterSearchResults,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.black45,
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchDataFromMikroTik,
              child: displayedUsers.isEmpty
                  ? const Center(
                      child: Text('SELECT ROUTER'),
                    )
                  : UserList(
                      users: displayedUsers,
                      selectedUsers: selectedUsers,
                      onUserSelected: onUserSelected,
                      selectedItemsCount: selectedItemsCount,
                      dns: selectedDns,
                      port: selectedPort,
                      username: selectedUsername,
                      password: selectedPassword,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void onUserSelected(int index, bool value) {
    setState(() {
      selectedUsers[index] = value;
    });
  }

  Future<void> fetchDataFromMikroTik() async {
    List<dynamic> fetchedData = await get_active_voucher(
      selectedDns,
      selectedPort,
      selectedUsername,
      selectedPassword,
    );
    // print('Fetched Data: Sucessfully - active_voucher_screen');
    setState(() {
      originalUsers = fetchedData.reversed.toList();
      displayedUsers = List.from(originalUsers);
      selectedUsers = List.generate(originalUsers.length, (index) => false);
    });
  }

  void updateSelectedUsers() {
    setState(() {
      selectedUsers = List.generate(
        originalUsers.length,
        (index) => index < selectedItemsCount,
      );
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      selectedUsers = List.generate(originalUsers.length, (index) => false);

      if (query.isEmpty) {
        displayedUsers = List.from(originalUsers);
        return;
      }

      List<dynamic> searchList = originalUsers.where((user) {
        return user['user'].toLowerCase().contains(query.toLowerCase());
      }).toList();

      displayedUsers = searchList;
    });
  }
}
