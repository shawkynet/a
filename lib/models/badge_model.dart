import 'dart:convert';

class BadgeModel {
    BadgeModel({
        required this.color,
        required this.name
    });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
        };
    }

    static fromJson(data) {
        return BadgeModel(
            color: data?['color']??'',
            name: data?['name']??'',
        );
    }

    String name;
    String color;
}
