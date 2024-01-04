import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mikrotik_api/screens/add_router_screen.dart';
import 'package:mikrotik_api/screens/home_screen/home_screen.dart';
import 'package:mikrotik_api/screens/list_of_routers_screen.dart';
import 'package:mikrotik_api/screens/screen_active_voucher/active_voucher_screen.dart';
import 'package:mikrotik_api/screens/screen_generated_voucher/generated_voucher_screen.dart';
import 'package:mikrotik_api/screens/screen_voucher_generator/voucher_generator_screen.dart';
import 'package:mikrotik_api/screens/sign_up_screen.dart';
import 'package:mikrotik_api/screens/signin_screen.dart';
import 'package:mikrotik_api/screens/splash_screen.dart';
import 'package:mikrotik_api/screens/subscibtion_screen.dart';
import 'package:mikrotik_api/screens/user_details_screen.dart';
import 'package:mikrotik_api/services/selectedatamodel.dart';
import 'package:provider/provider.dart'; // Ensure this import is present
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => SelectedDataModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mikrotik_Api',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      home: const SplashScreen(),
      routes: {
        'Navigate_to_signIn_Screen': (context) => const ScreenSignIn(),
        'Navigate_to_Home_Screen': (context) => const ScreenHome(),
        'Navigate_to_Voucher_generator_Screen': (context) =>
            const ScreenVoucherGenerator(),
        'Navigate_to_Generated_Voucher_Screen': (context) =>
            const GeneratedVoucherScreen(),
        'Navigate_to_Active_Voucher_Screen': (context) =>
            const ScreenActiveVoucher(),
        'Navigate_to_User_details_Screen': (context) =>
            const ScreenUserDetails(),
        'Navigate_to_Add_Router_Screen': (context) => const AddRouterScreen(),
        'Navigate_to_Router_List_Screen': (context) => const RouterListScreen(),
        'Navigate_to_Subscription_Screen': (context) =>
            const subscibtion_screen(),
        'Navigate_to_SignUp_Screen': (context) => const SignUp(),
      },
    );
  }
}
