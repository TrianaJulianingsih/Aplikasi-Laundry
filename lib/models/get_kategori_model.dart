// To parse this JSON data, do
//
//     final getKategoriModel = getKategoriModelFromJson(jsonString);

import 'dart:convert';

GetKategoriModel getKategoriModelFromJson(String str) => GetKategoriModel.fromJson(json.decode(str));

String getKategoriModelToJson(GetKategoriModel data) => json.encode(data.toJson());

class GetKategoriModel {
    String? message;
    List<GetImage>? data;

    GetKategoriModel({
        this.message,
        this.data,
    });

    factory GetKategoriModel.fromJson(Map<String, dynamic> json) => GetKategoriModel(
        message: json["message"],
        data: json["data"] == null ? [] : List<GetImage>.from(json["data"]!.map((x) => GetImage.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class GetImage {
    int? id;
    String? name;
    String? imageUrl;

    GetImage({
        this.id,
        this.name,
        this.imageUrl,
    });

    factory GetImage.fromJson(Map<String, dynamic> json) => GetImage(
        id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
        name: json["name"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_url": imageUrl,
    };
}
