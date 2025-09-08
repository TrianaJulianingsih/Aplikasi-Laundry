// api/layanan.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laundry_jaya/api/endpoint/endpoint.dart';
import 'package:laundry_jaya/models/get_layanan_model.dart';
import 'package:laundry_jaya/shared_preferences/shared_preferences.dart';

class LayananAPI {
  // static Future<LayananModel> addLayanan({
  //   required String name,
  //   required int waktuPengerjaan,
  //   required int categoryId,
  //   required int id,
  // }) async {
  //   final url = Uri.parse(Endpoint.layanan);
  //   final token = await PreferenceHandler.getToken();

  //   final response = await http.post(
  //     url,
  //     headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
  //     body: {
  //       "name": name,
  //       "waktu_pengerjaan": waktuPengerjaan.toString(),
  //       "category_id": categoryId.toString(),
  //       "id": id.toString(),
  //     },
  //   );

  //   print("Add Item Response: ${response.statusCode}");
  //   print("Add Item Body: ${response.body}");

  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     return LayananModel.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Gagal menambahkan item");
  //   }
  // }

  static Future<GetLayananModel> getLayananByCategory(int categoryId) async {
    final url = Uri.parse("${Endpoint.layanan}?category_id=$categoryId");
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("Get Layanan by Category Response: ${response.statusCode}");
    print("Get Layanan by Category Body: ${response.body}");

    if (response.statusCode == 200) {
      return GetLayananModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal mengambil data layanan");
    }
  }
}