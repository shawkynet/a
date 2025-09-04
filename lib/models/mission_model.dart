import 'dart:convert';

class MissionModel {
  MissionModel({
    required this.client_id,
    required this.address,
    required this.to_branch_id,
    required this.status_id,
    required this.type,
    required this.updated_at,
    required this.created_at,
    required this.id,
    required this.code,
  });

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'client_id': client_id,
      'address': address,
      'to_branch_id': to_branch_id,
      'status_id': status_id,
      'type': type,
      'updated_at': updated_at,
      'created_at': created_at,
      'id': id,
      'code': code,
    };
  }

  static fromJson(data) {
    return MissionModel(
      client_id: data?['client_id'] ?? ''.toString(),
      address: data?['address'] ?? ''.toString(),
      to_branch_id: data?['to_branch_id'] ?? ''.toString(),
      status_id: data?['status_id'] ?? ''.toString(),
      type: data?['type'] ?? ''.toString(),
      updated_at: data?['updated_at'] ?? ''.toString(),
      created_at: data?['created_at'] ?? ''.toString(),
      id: data?['id'] ?? ''.toString(),
      code: data?['code'] ?? ''.toString(),
    );
  }


  final String client_id;
  final String address;
  final String to_branch_id;
  final String status_id;
  final String type;
  final String updated_at;
  final String created_at;
  final String id;
  final String code;
}
