import 'dart:convert';

class StateModel {
    StateModel({
        required this.id,
        required this.country_code,
        required this.country_id,
        required this.name,
    });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'id': id,
            'name': name,
            'country_id': country_id,
            'country_code': country_code,
        };
    }

    static fromJson(data) {
        return StateModel(
            id: (data?['id']??'').toString(),
            country_code: (data?['country_code']??''),
            name: (data?['name']??''),
            country_id: (data?['country_id']??'').toString(),
        );
    }

    final String id;
    final String name;
    final String country_code;
    final String country_id;
}
