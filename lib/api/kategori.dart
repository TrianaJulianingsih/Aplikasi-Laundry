import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:laundry_jaya/api/endpoint/endpoint.dart';
import 'package:laundry_jaya/models/delete_kategori_model.dart';
import 'package:laundry_jaya/models/get_kategori_model.dart';
import 'package:laundry_jaya/models/kategori_model.dart';
import 'package:laundry_jaya/models/update_kategori_model.dart';
import 'package:laundry_jaya/shared_preferences/shared_preferences.dart';

class KategoriAPI {
  static Future<String> addKategori({required String name, File? image}) async {
    final url = Uri.parse(Endpoint.kategori);
    final token = await PreferenceHandler.getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan, silakan login ulang");
    }

    String imageBase64 = "";
    if (image != null) {
      final bytes = await image.readAsBytes();
      imageBase64 = base64Encode(bytes);
    }

    final body = {"name": name, "image": imageBase64};

    final response = await http.post(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: body,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data['message'] ?? "success";
    } else {
      throw Exception(data['message'] ?? "Gagal menambahkan kategori");
    }
  }

  static Future<GetKategoriModel> getKategori() async {
    final url = Uri.parse(Endpoint.kategori);
    final token = await PreferenceHandler.getToken();
    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    // print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return GetKategoriModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      print(error);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  static Future<UpdateKategoriModel> updateCategory({
    required int id,
    required String name,
    File? image,
  }) async {
    final url = Uri.parse("${Endpoint.kategori}/$id");
    final token = await PreferenceHandler.getToken();
    String imageBase64 = "";
    if (image != null) {
      final bytes = await image.readAsBytes();
      imageBase64 = base64Encode(bytes);
    }

    print("Update Profile URL: $url");
    print("Update Profile Data: {name: $name}");

    final response = await http.put(
      url,
      body: {"name": name, "image": imageBase64},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("Update Profile Response: ${response.statusCode}");
    print("Update Profile Body: ${response.body}");

    if (response.statusCode == 200) {
      return UpdateKategoriModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(
        error["message"] ??
            "Update profile gagal. Status: ${response.statusCode}",
      );
    }
  }

  static Future<KategoriModel> postCategory({
    required String name,
    required File image,
  }) async {
    final url = Uri.parse(Endpoint.kategori);
    final token = await PreferenceHandler.getToken();
    final readImage = image.readAsBytesSync();
    final b64 = base64Encode(readImage);
    final response = await http.post(
      url,
      body: {"name": name, "image": b64},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print(image);
    print(readImage);
    print(b64);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return KategoriModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  // static Future<DeleteModel> hapusKategori({
  //   required String name,
  //   required int id,
  // }) async {
  //   final url = Uri.parse("${Endpoint.kategori}/$id");
  //   final token = await PreferenceHandler.getToken();
  //   final response = await http.delete(
  //     url,
  //     body: {"name": name},
  //     headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
  //   );
  //   if (response.statusCode == 200) {
  //     return DeleteModel.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Register gagal");
  //   }
  // }

  static Future<DeleteModel> deleteKategori({required int id}) async {
    final url = Uri.parse("${Endpoint.kategori}/$id");
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
