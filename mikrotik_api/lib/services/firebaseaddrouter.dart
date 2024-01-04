import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  Future<void> addOrUpdateRouterDetails(
      String userId, Map<String, dynamic> routerDetails) async {
    try {
      String dns = routerDetails['dns'];
      int port = routerDetails['port'];
      String hotspot = routerDetails['hotspot'];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('router_details')
          .where('dns', isEqualTo: dns)
          .where('port', isEqualTo: port)
          .where('hotspot', isEqualTo: hotspot)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Similar data exists, update it
        DocumentSnapshot document = querySnapshot.docs.first;
        await document.reference.update(routerDetails);

        // print('Router details updated successfully!');
      } else {
        // No similar data exists, add as a new router
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('router_details')
            .add(routerDetails);

        // print('Router details added successfully!');
      }
    } catch (e) {
      //  print('Error adding/updating router details: $e');
    }
  }
}
