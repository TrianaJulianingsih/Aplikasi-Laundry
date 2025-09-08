import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:laundry_jaya/api/endpoint/endpoint.dart';
import 'package:laundry_jaya/models/get_user_model.dart';
import 'package:laundry_jaya/models/register_model.dart';
import 'package:laundry_jaya/models/update_profile.dart';
import 'package:laundry_jaya/shared_preferences/shared_preferences.dart';

class AuthenticationAPI {
  static Future<GetProfile> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final url = Uri.parse(Endpoint.register);
    final response = await http.post(
      url,
      body: {"name": name, "email": email, "password": password},
      headers: {"Accept": "application/json"},
    );

    print("Register Response: ${response.body}");

    if (response.statusCode == 200) {
      return GetProfile.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  static Future<GetProfile> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Endpoint.login);
    final response = await http.post(
      url,
      body: {"email": email, "password": password},
      headers: {"Accept": "application/json"},
    );

    print("Login Response: ${response.body}");

    if (response.statusCode == 200) {
      return GetProfile.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Login gagal");
    }
  }

  static Future<UpdateProfileModel> updateProfile({
    required String name,
    required String email,
  }) async {
    final url = Uri.parse(Endpoint.updateProfile);
    final token = await PreferenceHandler.getToken();

    print("Update Profile URL: $url");
    print("Update Profile Data: {name: $name, email: $email}");

    final response = await http.put(
      url,
      body: {"name": name, "email": email},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("Update Profile Response: ${response.statusCode}");
    print("Update Profile Body: ${response.body}");

    if (response.statusCode == 200) {
      return UpdateProfileModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(
        error["message"] ??
            "Update profile gagal. Status: ${response.statusCode}",
      );
    }
  }

  static Future<GetUserModel> getProfile() async {
    final url = Uri.parse(Endpoint.profile);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("Profile Status: ${response.statusCode}");

    if (response.statusCode == 200) {
      return GetUserModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      print(error);
      throw Exception(error["message"] ?? "Gagal mengambil profil");
    }
  }

  static Future<void> logout() async {
    final url = Uri.parse(Endpoint.logout);
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      PreferenceHandler.removeAll();
    } else {
      throw Exception("Logout gagal");
    }
  }
}
