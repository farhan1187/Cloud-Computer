import 'package:flutter/material.dart';
import 'package:mikrotik_api/services/delete_data/delete_voucher.dart';

class UserList extends StatelessWidget {
  final List<dynamic> users;
  final List<bool> selectedUsers;
  final Function(int, bool) onUserSelected;
  final int selectedItemsCount;

  final String dns;
  final int port;
  final String username;
  final String password;

  const UserList({
    super.key,
    required this.users,
    required this.selectedUsers,
    required this.onUserSelected,
    required this.selectedItemsCount,
    required this.dns,
    required this.port,
    required this.username,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        var user = users[index];
        return Dismissible(
          key: Key(user['.id'].toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: const Color.fromARGB(255, 215, 14, 0),
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ),
          confirmDismiss: (DismissDirection direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Confirm Delete",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  content: const Text(
                    "Are you sure you want to delete this item?",
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              _deleteUser(context, index);
            }
          },
          child: ListTile(
            title: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.lightBlue, // Default text color
                ),
                children: <TextSpan>[
                  const TextSpan(
                    text: 'voucher: ',
                    style: TextStyle(
                      color: Colors.white, // 'voucher:' text color
                    ),
                  ),
                  TextSpan(
                    text: '${user['user']}',
                    style: const TextStyle(
                      color: Colors.lightBlue, // '${user['user']}' text color
                    ),
                  ),
                ],
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mac-Address: ${user['mac-address']}'),
                Text('Days left: ${user['session-time-left']}'),
                Text('comment: ${user['comment']}'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteUser(BuildContext context, int index) {
    delete_Voucher(
      users[index]['.id'],
      dns,
      port,
      username,
      password,
      'active',
    ).then((bool success) {
      users.removeAt(index);
    });
  }
}
