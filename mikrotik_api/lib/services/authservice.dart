import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> saveLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    // You can also save other user-related data if needed
    // await prefs.setString('userId', 'user-id');
    // await prefs.setString('userName', 'user-name');
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    // Clear other user-related data if needed
    // await prefs.remove('userId');
  }
}
