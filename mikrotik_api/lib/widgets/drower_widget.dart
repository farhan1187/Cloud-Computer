import 'package:flutter/material.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black54,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User Details'),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('Navigate_to_User_details_Screen');
                // Add functionality for user details
              },
            ),
            ListTile(
              leading: const Icon(Icons.confirmation_number),
              title: const Text('Voucher Generator'),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('Navigate_to_Voucher_generator_Screen');
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Generated Voucher'),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('Navigate_to_Generated_Voucher_Screen');
              },
            ),
            ListTile(
              leading: const Icon(Icons.done),
              title: const Text('Active Voucher'),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('Navigate_to_Active_Voucher_Screen');
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Icon(Icons.router),
              title: const Text('Add Router'),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('Navigate_to_Add_Router_Screen');
              },
            ),
            ListTile(
              leading: const Icon(Icons.router_outlined),
              title: const Text('Router List'),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('Navigate_to_Router_List_Screen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
