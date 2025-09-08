// To parse this JSON data, do
//
//     final itemModel = itemModelFromJson(jsonString);

import 'dart:convert';

ItemModel itemModelFromJson(String str) => ItemModel.fromJson(json.decode(str));

String itemModelToJson(ItemModel data) => json.encode(data.toJson());

class ItemModel {
    String? message;
    List<Datum>? data;

    ItemModel({
        this.message,
        this.data,
    });

    factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
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
    int? price;
    int? categoryId;
    int? serviceTypeId;
    DateTime? createdAt;
    DateTime? updatedAt;
    Category? category;
    ServiceType? serviceType;

    Datum({
        this.id,
        this.name,
        this.price,
        this.categoryId,
        this.serviceTypeId,
        this.createdAt,
        this.updatedAt,
        this.category,
        this.serviceType,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
        name: json["name"],
        price: json["price"] is int ? json["price"] : int.tryParse(json["price"].toString()),
        categoryId: json["category_id"] is int ? json["category_id"] : int.tryParse(json["category_id"].toString()),
        serviceTypeId: json["service_type_id"] is int ? json["service_type_id"] : int.tryParse(json["service_type_id"].toString()),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        category: json["category"] == null ? null : Category.fromJson(json["category"]),
        serviceType: json["service_type"] == null ? null : ServiceType.fromJson(json["service_type"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "category_id": categoryId,
        "service_type_id": serviceTypeId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "category": category?.toJson(),
        "service_type": serviceType?.toJson(),
    };
}

class Category {
    int? id;
    String? name;
    String? image;
    DateTime? createdAt;
    DateTime? updatedAt;

    Category({
        this.id,
        this.name,
        this.image,
        this.createdAt,
        this.updatedAt,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
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

class ServiceType {
    int? id;
    String? name;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? waktuPengerjaan;
    int? categoryId;

    ServiceType({
        this.id,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.waktuPengerjaan,
        this.categoryId,
    });

    factory ServiceType.fromJson(Map<String, dynamic> json) => ServiceType(
        id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
        name: json["name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        waktuPengerjaan: json["waktu_pengerjaan"] is int ? json["waktu_pengerjaan"] : int.tryParse(json["waktu_pengerjaan"].toString()),
        categoryId: json["category_id"] is int ? json["category_id"] : int.tryParse(json["category_id"].toString()),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "waktu_pengerjaan": waktuPengerjaan,
        "category_id": categoryId,
    };
}
