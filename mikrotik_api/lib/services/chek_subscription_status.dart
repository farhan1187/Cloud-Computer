import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubscriptionService {
  static Future<void> checkSubscriptionStatus(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      final userId = currentUser.uid;
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      final snapshot = await userDoc.get();

      if (snapshot.exists) {
        final startDate = (snapshot['start_date'] as Timestamp).toDate();
        final endDate = (snapshot['end_date'] as Timestamp).toDate();

        final currentDate = DateTime.now();
        //    print(startDate);
        //    print(endDate);
        //    print(currentDate);

        if (currentDate.isAfter(startDate) && currentDate.isBefore(endDate)) {
          Navigator.of(context).pushReplacementNamed('Navigate_to_Home_Screen');
        } else {
          Navigator.of(context)
              .pushReplacementNamed('Navigate_to_Subscription_Screen');
        }
      } else {
        Navigator.of(context).pushReplacementNamed('Navigate_to_SignIn_Screen');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('Navigate_to_SignIn_Screen');
    }
  }
}
