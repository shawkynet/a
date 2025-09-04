import 'dart:convert';

class AreaModel {
    AreaModel({
        required this.id,
        required this.state_id,
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
            'state_id': state_id,
        };
    }

    static fromJson(data) {
        final name = jsonDecode(data?['name']??'')['en'];
        return AreaModel(
            id: (data?['id']??'').toString(),
            state_id: (data?['state_id']??'').toString(),
            name: name,
        );
    }

    final String id;
    final String name;
    final String state_id;
}
