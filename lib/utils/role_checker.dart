// utils/role_checker.dart
import 'package:flutter/material.dart';
import 'package:laundry_jaya/shared_preferences/shared_preferences.dart';

class RoleChecker {
  static Future<bool> isOwner() async {
    final role = await PreferenceHandler.getUserRole();
    return role == "owner";
  }

  static Future<bool> isCustomer() async {
    final role = await PreferenceHandler.getUserRole();
    return role == "customer";
  }

  static Future<void> requireOwner(BuildContext context) async {
    final isOwner = await RoleChecker.isOwner();
    if (!isOwner) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hanya pemilik laundry yang dapat mengakses fitur ini"))
      );
      Navigator.pop(context);
      throw Exception("Access denied: Owner role required");
    }
  }

  static Future<String> getRoleString() async {
    final role = await PreferenceHandler.getUserRole();
    return role ?? "customer";
  }

  static Future<String> getRoleDisplayName() async {
    final role = await PreferenceHandler.getUserRole();
    return role == "owner" ? "Pemilik Laundry" : "Pelanggan";
  }
}