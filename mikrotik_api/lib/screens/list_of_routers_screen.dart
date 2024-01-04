import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mikrotik_api/widgets/custom_button.dart';
import 'package:mikrotik_api/widgets/custom_snacbar.dart';

class Router {
  final String deviceName;
  final String dns;
  final int port;
  final String username;
  final String password;
  final String hotspot;

  Router({
    required this.deviceName,
    required this.dns,
    required this.port,
    required this.username,
    required this.password,
    required this.hotspot,
  });
}

class RouterListScreen extends StatefulWidget {
  const RouterListScreen({super.key});

  @override
  RouterListScreenState createState() => RouterListScreenState();
}

class RouterListScreenState extends State<RouterListScreen> {
  List<Router> routers = []; // Initialize as an empty list

  @override
  void initState() {
    super.initState();
    fetchRoutersFromFirebase(); // Fetch router details from Firebase
  }

  Future<void> fetchRoutersFromFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('router_details')
            .get();

        setState(() {
          routers = querySnapshot.docs.map((doc) {
            return Router(
              deviceName: doc['deviceName'],
              dns: doc['dns'],
              port: doc['port'],
              username: doc['username'],
              password: doc['password'],
              hotspot: doc['hotspot'],
            );
          }).toList();
        });
      }
    } catch (e) {
      //  print("Error fetching data: $e");
    }
  }

  void removeRouterFromList(Router routerToDelete) {
    setState(() {
      routers.removeWhere(
          (router) => router.deviceName == routerToDelete.deviceName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Router List'),
      ),
      body: routers.isNotEmpty
          ? ListView.builder(
              itemCount: routers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(routers[index].deviceName),
                  trailing: IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () {
                      // Pass the selected router to the details screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                              router: routers[index],
                              onDelete: removeRouterFromList),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class DetailsScreen extends StatefulWidget {
  final Router router;
  final Function(Router) onDelete;

  const DetailsScreen(
      {super.key, required this.router, required this.onDelete});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Future<void> deleteRouter(BuildContext context, Router routerToDelete) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('router_details')
            .where('deviceName', isEqualTo: routerToDelete.deviceName)
            .get()
            .then(
          (querySnapshot) {
            for (var doc in querySnapshot.docs) {
              doc.reference.delete();
            }
          },
        );

        // Trigger the parent's method to remove the router from the list
        widget.onDelete(routerToDelete);

        // Navigate back to the HomeScreen after deletion
        Navigator.of(context).pushReplacementNamed('Navigate_to_Home_Screen');
      }
    } catch (e) {
      // print("Error deleting router: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.router.deviceName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Device Name: ${widget.router.deviceName}'),
                    Text('DNS: ${widget.router.dns}'),
                    Text('Port: ${widget.router.port.toString()}'),
                    Text('Username: ${widget.router.username}'),
                    Text('Password: ${widget.router.password}'),
                    Text('Hotspot: ${widget.router.hotspot}'),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Unbind',
                    onPressed: () {
                      setState(() {
                        CustomSnackBar.showSnackBar(
                            context, 'Sucessfully UnBinded your device...');
                      });
                      deleteRouter(context, widget.router);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
