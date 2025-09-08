// To parse this JSON data, do
//
//     final getOrderModel = getOrderModelFromJson(jsonString);

import 'dart:convert';

GetOrderModel getOrderModelFromJson(String str) => GetOrderModel.fromJson(json.decode(str));

String getOrderModelToJson(GetOrderModel data) => json.encode(data.toJson());

class GetOrderModel {
    String? message;
    List<Datum>? data;

    GetOrderModel({
        this.message,
        this.data,
    });

    factory GetOrderModel.fromJson(Map<String, dynamic> json) => GetOrderModel(
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
    int? customerId;
    String? layanan;
    dynamic serviceTypeId;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? total;
    List<Item>? items;

    Datum({
        this.id,
        this.customerId,
        this.layanan,
        this.serviceTypeId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.total,
        this.items,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        customerId: json["customer_id"] is int ? json["customer_id"] : int.tryParse(json["customer_id"].toString()),
        layanan: json["layanan"],
        serviceTypeId: json["service_type_id"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        total: json["total"],
        items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "layanan": layanan,
        "service_type_id": serviceTypeId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "total": total,
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class Item {
    int? id;
    int? laundryOrderId;
    int? serviceItemId;
    int? quantity;
    int? subtotal;
    DateTime? createdAt;
    DateTime? updatedAt;
    ServiceItem? serviceItem;

    Item({
        this.id,
        this.laundryOrderId,
        this.serviceItemId,
        this.quantity,
        this.subtotal,
        this.createdAt,
        this.updatedAt,
        this.serviceItem,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        laundryOrderId: json["laundry_order_id"] is int ? json["laundry_order_id"] : int.tryParse(json["laundry_order_id"].toString()),
        serviceItemId: json["service_item_id"] is int ? json["service_item_id"] : int.tryParse(json["service_item_id"].toString()),
        quantity: json["quantity"] is int ? json["quantity"] : int.tryParse(json["quantity"].toString()),
        subtotal: json["subtotal"] is int ? json["subtotal"] : int.tryParse(json["subtotal"].toString()),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        serviceItem: json["service_item"] == null ? null : ServiceItem.fromJson(json["service_item"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "laundry_order_id": laundryOrderId,
        "service_item_id": serviceItemId,
        "quantity": quantity,
        "subtotal": subtotal,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "service_item": serviceItem?.toJson(),
    };
}

class ServiceItem {
    int? id;
    String? name;
    int? price;
    int? categoryId;
    int? serviceTypeId;
    DateTime? createdAt;
    DateTime? updatedAt;

    ServiceItem({
        this.id,
        this.name,
        this.price,
        this.categoryId,
        this.serviceTypeId,
        this.createdAt,
        this.updatedAt,
    });

    factory ServiceItem.fromJson(Map<String, dynamic> json) => ServiceItem(
        id: json["id"],
        name: json["name"],
        price: json["price"] is int ? json["price"] : int.tryParse(json["price"].toString()),
        categoryId: json["category_id"] is int ? json["category_id"] : int.tryParse(json["category_id"].toString()),
        serviceTypeId: json["service_type_id"] is int ? json["service_type_id"] : int.tryParse(json["service_type_id"].toString()),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "category_id": categoryId,
        "service_type_id": serviceTypeId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
