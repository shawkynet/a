import 'dart:convert';

class PaymentMethodModel {
    PaymentMethodModel(
            {
                required this.id,
      required this.type,
      required this.value,
      required this.key,
      required this.lang,
      required this.name,
      required this.created_at,
      required this.updated_at,});

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'id': id,
            'type': type,
            'value': value,
            'key': key,
            'lang': lang,
            'name': name,
            'created_at': created_at,
            'updated_at': updated_at,
        };
    }

    static fromJson(data) {
        return PaymentMethodModel(
            id: (data?['id']??'').toString(),
            type: data?['type']??'',
            value: data?['value']??'',
            key: data?['key']??'',
            lang: data?['lang']??'',
            name: data?['name']??'',
            created_at: data?['created_at']??'',
            updated_at: data?['updated_at']??'',
        );
    }

    final String id;
    final String type;
    final String value;
    final String key;
    final String lang;
    final String name;
    final String created_at;
    final String updated_at;
}