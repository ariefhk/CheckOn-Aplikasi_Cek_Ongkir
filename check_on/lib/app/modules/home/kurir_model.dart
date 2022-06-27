// To parse this JSON data, do
//
//     final kurir = kurirFromJson(jsonString);

import 'dart:convert';

Kurir kurirFromJson(String str) => Kurir.fromJson(json.decode(str));

String kurirToJson(Kurir data) => json.encode(data.toJson());

class Kurir {
  Kurir({
    this.code,
    this.name,
    this.costs,
  });

  String? code;
  String? name;
  List<KurirCost>? costs;

  factory Kurir.fromJson(Map<String, dynamic> json) => Kurir(
        code: json["code"],
        name: json["name"],
        costs: List<KurirCost>.from(
            json["costs"].map((x) => KurirCost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "costs": List<dynamic>.from(costs!.map((x) => x.toJson())),
      };
  static List<Kurir> fromJsonList(List list) {
    if (list == null) return List<Kurir>.empty();
    return list.map((item) => Kurir.fromJson(item)).toList();
  }
}

class KurirCost {
  KurirCost({
    this.service,
    this.description,
    this.cost,
  });

  String? service;
  String? description;
  List<CostCost>? cost;

  factory KurirCost.fromJson(Map<String, dynamic> json) => KurirCost(
        service: json["service"],
        description: json["description"],
        cost:
            List<CostCost>.from(json["cost"].map((x) => CostCost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service": service,
        "description": description,
        "cost": List<dynamic>.from(cost!.map((x) => x.toJson())),
      };
}

class CostCost {
  CostCost({
    this.value,
    this.etd,
    this.note,
  });

  int? value;
  String? etd;
  String? note;

  factory CostCost.fromJson(Map<String, dynamic> json) => CostCost(
        value: json["value"],
        etd: json["etd"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "etd": etd,
        "note": note,
      };
}
