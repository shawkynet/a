import 'dart:convert';

class AddressModel {
  AddressModel(
      {
        this.address_name,
        required this.country_code,
      required this.country_id,
      required this.country_name,
      required this.country_currency,
      required this.country_phonecode,
      required this.state_name,
      required this.state_id,
      required this.area_name,
      required this.area_id});

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'address_name': address_name,
      'country_code': country_code,
      'country_id': country_id,
      'country_name': country_name,
      'country_currency': country_currency,
      'country_phonecode': country_phonecode,
      'state_name': state_name,
      'state_id': state_id,
      'area_name': area_name,
      'area_id': area_id,
    };
  }

  static fromJson(data) {
    return AddressModel(
      address_name: (data?['address_name']??'').toString(),
      country_code: (data?['country_code']??'').toString(),
      country_id: (data?['country_id']??'').toString(),
      country_name: (data?['country_name']??'').toString(),
      country_currency: (data?['country_currency']??'').toString(),
      country_phonecode: (data?['country_phonecode']??'').toString(),
      state_name: (data?['state_name']??'').toString(),
      state_id: (data?['state_id']??'').toString(),
      area_name: (data?['area_name']??'').toString(),
      area_id: (data?['area_id']??'').toString(),
    );
  }

  final String? address_name;
  final String country_code;
  final String country_id;
  final String country_name;
  final String country_currency;
  final String country_phonecode;
  final String state_name;
  final String state_id;
  final String area_name;
  final String area_id;
}
