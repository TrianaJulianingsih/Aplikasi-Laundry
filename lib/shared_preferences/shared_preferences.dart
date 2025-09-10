import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String tokenKey = "token";
  static const String userRoleKey = "user_role";
  static const String userIdKey = "user_id";
  static const String userEmailKey = "user_email";
  static const String userNameKey = "user_name";
  static const String loginKey = "login";

  static void saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static void saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userRoleKey, role);
    print("Role saved: $role");
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString(userRoleKey);
    print("Retrieved role: $role");
    return role;
  }

  static void saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userIdKey, userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userIdKey);
  }

  static void saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userEmailKey, email);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  static void saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userNameKey, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  static void removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(userRoleKey);
    await prefs.remove(userIdKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(userNameKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey) != null;
  }

  static Future<bool?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey);
  }
}
