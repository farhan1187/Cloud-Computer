import 'package:flutter/material.dart';
import 'package:mikrotik_api/services/get_data/get_generated_voucher.dart';
import 'package:mikrotik_api/screens/screen_generated_voucher/selected_voucher/selected_voucher_screen.dart';
import 'package:mikrotik_api/screens/screen_generated_voucher/user_list_generated/user_list_generated.dart';
import 'package:mikrotik_api/services/selectedatamodel.dart';
import 'package:mikrotik_api/widgets/popup_menu_button.dart';
import 'package:mikrotik_api/widgets/search_widget.dart';
import 'package:provider/provider.dart';

class GeneratedVoucherScreen extends StatefulWidget {
  const GeneratedVoucherScreen({super.key});

  @override
  State<GeneratedVoucherScreen> createState() => _GeneratedVoucherScreenState();
}

class _GeneratedVoucherScreenState extends State<GeneratedVoucherScreen> {
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
        title: SearchWidget(
          searchController: searchController,
          onTextChanged: filterSearchResults,
        ),
        actions: [
          CustomPopupMenuButton(
            initialValue: selectedItemsCount,
            onSelected: (int value) {
              setState(() {
                selectedItemsCount = value;
                selectedUsers =
                    List.generate(originalUsers.length, (index) => false);
                updateSelectedUsers();
              });
            },
          ),
        ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          printSelectedData();
        },
        backgroundColor: Colors.grey[800],
        child: const Icon(
          Icons.print,
          color: Colors.white,
        ),
      ),
    );
  }

  void onUserSelected(int index, bool value) {
    setState(() {
      selectedUsers[index] = value;
    });
  }

  void printSelectedData() {
    List<dynamic> selectedData = [];
    for (int i = 0; i < selectedUsers.length; i++) {
      if (selectedUsers[i]) {
        selectedData.add(displayedUsers[i]);
      }
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) =>
            SelectedVouchersPrintView(selectedVouchers: selectedData),
      ),
    );
  }

  Future<void> fetchDataFromMikroTik() async {
    try {
      // Fetch data from MikroTik API using the provided credentials
      List<dynamic> fetchedData = await get_generated_voucher(
        selectedDns,
        selectedPort,
        selectedUsername,
        selectedPassword,
      );
      //  print('Fetched Data: Sucessfully - generated_voucher_screen');

      // Update the UI with the fetched data
      setState(() {
        originalUsers = fetchedData.reversed.toList();
        displayedUsers = List.from(originalUsers);
        selectedUsers = List.generate(originalUsers.length, (index) => false);
      });
    } catch (error) {
      // Handle errors if data fetching fails
      // print('Error fetching data: $error');
      // Show error message or handle it accordingly
    }
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
        return user['name'].toLowerCase().contains(query.toLowerCase());
      }).toList();

      displayedUsers = searchList;
    });
  }
}
