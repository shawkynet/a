import 'dart:convert';

class CountryModel {
    CountryModel({
        required this.id,
        required this.currency,
        required this.phonecode,
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
            'phonecode': phonecode,
            'currency': currency,
        };
    }
    static fromJson(data) {
        return CountryModel(
            id: (data?['id']??'').toString(),
            name: (data?['name']??'').toString(),
            phonecode: (data?['phonecode']??'').toString(),
            currency: (data?['currency']??'').toString(),
        );
    }

    final String id;
    final String name;
    final String currency;
    final String phonecode;
}
