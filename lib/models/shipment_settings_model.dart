import 'dart:convert';

class ShipmentSettingsModel {
  ShipmentSettingsModel({
    required this.id,
    required this.key,
    required this.value,
    required this.created_at,
    required this.updated_at,
  });

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'id': id,
      'key': key,
      'value': value,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  static fromJson(data) {
    return ShipmentSettingsModel(
      id: (data?['id']??'').toString(),
      key: (data?['key']??''),
      value: (data?['value']??''),
      created_at: (data?['created_at']??''),
      updated_at: (data?['updated_at']??''),
    );
  }

  final String id;
  final String key;
  final String value;
  final String created_at;
  final String updated_at;
}
/*
  {
        "id": 9,
        "key": "is_date_required",
        "value": "0",
        "created_at": null,
        "updated_at": "2021-06-27 12:19:59"
    },
*/
