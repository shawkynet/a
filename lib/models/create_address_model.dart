import 'dart:convert';

class CreateAddressModel {
  CreateAddressModel({
    required this.client_id,
    required this.address,
    required this.country,
    required this.state,
    required this.area,
    required this.client_street_address_map,
    required this.client_lat,
    required this.client_lng,
    required this.client_url,
  });

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'client_id': client_id,
      'address': address,
      'country': country,
      'state': state,
      'area': area,
      'client_street_address_map': client_street_address_map,
      'client_lat': client_lat,
      'client_lng': client_lng,
      'client_url': client_url,
    };
  }

  static fromJson(data) {
    return CreateAddressModel(
      client_id: (data?['client_id']??'').toString(),
      address: (data?['address']??'').toString(),
      country: (data?['country']??'').toString(),
      state: (data?['state']??'').toString(),
      area: (data?['area']??'').toString(),
      client_street_address_map: (data?['client_street_address_map']??'').toString(),
      client_lat: (data?['client_lat']??'').toString(),
      client_lng: (data?['client_lng']??'').toString(),
      client_url: (data?['client_url']??'').toString(),
    );
  }

  final String client_id;
  final String address;
  final String country;
  final String state;
  final String area;
  final String client_street_address_map;
  final String client_lat;
  final String client_lng;
  final String client_url;
}
