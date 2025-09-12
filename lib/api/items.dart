import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laundry_jaya/api/endpoint/endpoint.dart';
import 'package:laundry_jaya/models/add_item_model.dart';
import 'package:laundry_jaya/models/delete_kategori_model.dart';
import 'package:laundry_jaya/models/item_model.dart';
import 'package:laundry_jaya/shared_preferences/shared_preferences.dart';

class ItemsAPI {
  static Future<AddItemModel> addItem({
    required String name,
    required int price,
    required int categoryId,
    required int serviceTypeId,
  }) async {
    final url = Uri.parse(Endpoint.items);
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {
        "name": name,
        "price": price.toString(),
        "category_id": categoryId.toString(),
        "service_type_id": serviceTypeId.toString(),
      },
    );

    print("Add Item Response: ${response.statusCode}");
    print("Add Item Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AddItemModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal menambahkan item");
    }
  }

  static Future<ItemModel> getItemByCategory(int categoryId) async {
    final url = Uri.parse("${Endpoint.items}?category_id=$categoryId");
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("URL: $url");
    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal mengambil data layanan");
    }
  }

  static Future<ItemModel> getAllItem() async {
    final url = Uri.parse(Endpoint.items);
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal mengambil data layanan");
    }
  }

  static Future<DeleteModel> deleteItem({required int id}) async {
    final url = Uri.parse("${Endpoint.items}/$id");
    final token = await PreferenceHandler.getToken();

    final response = await http.delete(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return DeleteModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to delete cart");
    }
  }
}
