import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> signIn(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? storedPassword = prefs.getString(email);
    if (storedPassword != null && storedPassword == password) {
      prefs.setBool('isLoggedIn', true);
      prefs.setString('email', email);
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(email) == null) {
      prefs.setString(email, password);
      return true;
    }
    return false;
  }

  Future<bool> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('email');
    return true;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
