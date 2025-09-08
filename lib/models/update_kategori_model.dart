// To parse this JSON data, do
//
//     final updateKategoriModel = updateKategoriModelFromJson(jsonString);

import 'dart:convert';

UpdateKategoriModel updateKategoriModelFromJson(String str) => UpdateKategoriModel.fromJson(json.decode(str));

String updateKategoriModelToJson(UpdateKategoriModel data) => json.encode(data.toJson());

class UpdateKategoriModel {
    String? message;
    Data? data;

    UpdateKategoriModel({
        this.message,
        this.data,
    });

    factory UpdateKategoriModel.fromJson(Map<String, dynamic> json) => UpdateKategoriModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? name;
    String? image;
    DateTime? createdAt;
    DateTime? updatedAt;

    Data({
        this.id,
        this.name,
        this.image,
        this.createdAt,
        this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
