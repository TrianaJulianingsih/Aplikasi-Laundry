// To parse this JSON data, do
//
//     final addItemModel = addItemModelFromJson(jsonString);

import 'dart:convert';

AddItemModel addItemModelFromJson(String str) => AddItemModel.fromJson(json.decode(str));

String addItemModelToJson(AddItemModel data) => json.encode(data.toJson());

class AddItemModel {
    String? message;
    Data? data;

    AddItemModel({
        this.message,
        this.data,
    });

    factory AddItemModel.fromJson(Map<String, dynamic> json) => AddItemModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    String? name;
    int? price;
    int? categoryId;
    int? serviceTypeId;
    DateTime? updatedAt;
    DateTime? createdAt;
    int? id;

    Data({
        this.name,
        this.price,
        this.categoryId,
        this.serviceTypeId,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        price: json["price"] is int ? json["price"] : int.tryParse(json["price"].toString()),
        categoryId: json["category_id"] is int ? json["category_id"] : int.tryParse(json["category_id"].toString()),
        serviceTypeId: json["service_type_id"] is int ? json["service_type_id"] : int.tryParse(json["service_type_id"].toString()),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "category_id": categoryId,
        "service_type_id": serviceTypeId,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
