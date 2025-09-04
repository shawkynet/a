import 'dart:convert';

class DeliveryTimeModel {
  DeliveryTimeModel( {required this.id ,required this.name, required this.hours, required this.created_at, required this.updated_at});

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'hours': hours,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  static fromJson(data) {
    final name = jsonDecode(data?['name']??'')['en'];

    return DeliveryTimeModel(
      id: (data?['id']??'').toString(),
      name: name.toString(),
      hours: (data?['hours']??'').toString(),
      created_at: (data?['created_at']??'').toString(),
      updated_at: (data?['updated_at']??'').toString(),
    );
  }


  final String id;
  final String name;

  final String hours;
  final String created_at;
  final String updated_at;
}
