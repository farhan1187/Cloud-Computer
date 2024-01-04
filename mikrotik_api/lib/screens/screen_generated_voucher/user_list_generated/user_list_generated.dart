import 'package:flutter/material.dart';
import 'package:mikrotik_api/services/delete_data/delete_voucher.dart';

class UserList extends StatefulWidget {
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
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        var user = widget.users[index];
        bool isUptimeEqualLimitUptime = user['limit-uptime'] == user['uptime'];
        return Dismissible(
          key: Key(user['.id']
              .toString()), // Replace 'id' with your unique identifier in user data
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: const Color.fromARGB(255, 215, 14, 0),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          confirmDismiss: (DismissDirection direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Confirm Delete",
                    style: TextStyle(color: Colors.white),
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
                    text: '${user['name']}',
                    style: TextStyle(
                        color: isUptimeEqualLimitUptime
                            ? Colors.red
                            : Colors.blue),
                  ),
                ],
              ),
            ),

            // Customize ListTile based on your requirements
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('comment: ${widget.users[index]['comment']}'),
                Text('days: ${widget.users[index]['limit-uptime']}'),
              ],
            ),
            // For example: onTap to handle user selection
            onTap: () {
              bool newValue = !widget.selectedUsers[index];
              widget.onUserSelected(index, newValue);
            },
            // Add trailing icons or other widgets based on selected state
            trailing: widget.selectedUsers[index]
                ? const Icon(Icons.check_circle)
                : const Icon(Icons.circle),
          ),
        );
      },
    );
  }

  void _deleteUser(BuildContext context, int index) {
    delete_Voucher(
      widget.users[index]['.id'],
      widget.dns,
      widget.port,
      widget.username,
      widget.password,
      'user',
    ).then((bool success) {
      setState(() {
        widget.users.removeAt(index);
        widget.selectedUsers.removeAt(index);
      });
    });
  }
}
