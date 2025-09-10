import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laundry_jaya/api/endpoint/endpoint.dart';
import 'package:laundry_jaya/models/add_order_model.dart';
import 'package:laundry_jaya/models/change_status_model.dart';
import 'package:laundry_jaya/models/get_order_model.dart';
import 'package:laundry_jaya/shared_preferences/shared_preferences.dart';

class OrdersAPI {
  static Future<AddOrderModel> addOrder({
    required String layanan,
    required String status,
    // required int total,
    required List<Map<String, dynamic>> items,
  }) async {
    final url = Uri.parse(Endpoint.order);
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "layanan": layanan,
        "status": status,
        "items": items,
        // "total": total.toString()
      }),
    );

    print("Add Item Response: ${response.statusCode}");
    print("Add Item Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AddOrderModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal menambahkan item");
    }
  }

  static Future<GetOrderModel> getOrders() async {
    final url = Uri.parse(Endpoint.order);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return GetOrderModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal mengambil data order");
    }
  }

  static Future<ChangeStatusModel> changeStatus({
    required int statusId,
    required String status,
  }) async {
    try {
      final token = await PreferenceHandler.getToken();
      final url = Uri.parse(Endpoint.status(statusId));
      final body = {"status": status};
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return ChangeStatusModel.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(
          error["message"] ?? "Gagal konversi booking ke service",
        );
      }
    } catch (e) {
      throw Exception("Connection error: $e");
    }
  }
}
