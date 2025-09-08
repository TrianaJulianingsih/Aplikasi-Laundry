// To parse this JSON data, do
//
//     final getLayananModel = getLayananModelFromJson(jsonString);

import 'dart:convert';

GetLayananModel getLayananModelFromJson(String str) => GetLayananModel.fromJson(json.decode(str));

String getLayananModelToJson(GetLayananModel data) => json.encode(data.toJson());

class GetLayananModel {
    String? message;
    List<Datum>? data;

    GetLayananModel({
        this.message,
        this.data,
    });

    factory GetLayananModel.fromJson(Map<String, dynamic> json) => GetLayananModel(
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? name;
    int? waktuPengerjaan;
    Category? category;

    Datum({
        this.id,
        this.name,
        this.waktuPengerjaan,
        this.category,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
        name: json["name"],
        waktuPengerjaan: json["waktu_pengerjaan"] is int ? json["waktu_pengerjaan"] : int.tryParse(json["waktu_pengerjaan"].toString()),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "waktu_pengerjaan": waktuPengerjaan,
        "category": category?.toJson(),
    };
}

class Category {
    int? id;
    String? name;
    String? imageUrl;

    Category({
        this.id,
        this.name,
        this.imageUrl,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_url": imageUrl,
    };
}
