// To parse this JSON data, do
//
//     final changeStatusModel = changeStatusModelFromJson(jsonString);

import 'dart:convert';

ChangeStatusModel changeStatusModelFromJson(String str) =>
    ChangeStatusModel.fromJson(json.decode(str));

String changeStatusModelToJson(ChangeStatusModel data) =>
    json.encode(data.toJson());

class ChangeStatusModel {
  String? message;
  Data? data;

  ChangeStatusModel({this.message, this.data});

  factory ChangeStatusModel.fromJson(Map<String, dynamic> json) =>
      ChangeStatusModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? id;
  int? customerId;
  String? layanan;
  int? serviceTypeId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  ServiceType? serviceType;

  Data({
    this.id,
    this.customerId,
    this.layanan,
    this.serviceTypeId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.serviceType,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
    customerId: json["customer_id"] is int
        ? json["customer_id"]
        : int.tryParse(json["customer_id"].toString()),
    layanan: json["layanan"],
    serviceTypeId: json["service_type_id"] is int
        ? json["service_type_id"]
        : int.tryParse(json["service_type_id"].toString()),
    status: json["status"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    serviceType: json["service_type"] == null
        ? null
        : ServiceType.fromJson(json["service_type"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_id": customerId,
    "layanan": layanan,
    "service_type_id": serviceTypeId,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "service_type": serviceType?.toJson(),
  };
}

class ServiceType {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  ServiceType({this.id, this.name, this.createdAt, this.updatedAt});

  factory ServiceType.fromJson(Map<String, dynamic> json) => ServiceType(
    id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()),
    name: json["name"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
