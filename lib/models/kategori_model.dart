// To parse this JSON data, do
//
//     final kategoriModel = kategoriModelFromJson(jsonString);

import 'dart:convert';

KategoriModel kategoriModelFromJson(String str) =>
    KategoriModel.fromJson(json.decode(str));

String kategoriModelToJson(KategoriModel data) => json.encode(data.toJson());

class KategoriModel {
  String? message;
  List<Data>? data;

  KategoriModel({this.message, this.data});

  factory KategoriModel.fromJson(Map<String, dynamic> json) => KategoriModel(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Data {
  String? name;
  String? image;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({this.name, this.image, this.updatedAt, this.createdAt, this.id});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    image: json["image"],
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "image": image,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
