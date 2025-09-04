import 'dart:convert';

class AddressResponseModel {
  AddressResponseModel(
          {
            required this.id,
            required this.client_id,
            required this.address,
            required this.country_id,
            required this.state_id,
            required this.area_id,
            required this.client_street_address_map,
            required this.client_lat,
            required this.client_lng,
            required this.client_url,
            required this.created_at,
            required this.updated_at});

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  toJson() {
    return {
      'id': id,
      'client_id': client_id,
      'address': address,
      'country_id': country_id,
      'state_id': state_id,
      'area_id': area_id,
      'client_street_address_map': client_street_address_map,
      'client_lat': client_lat,
      'client_lng': client_lng,
      'client_url': client_url,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  static fromJson(data) {
    return AddressResponseModel(
      id: (data?['id']??'').toString(),
      client_id: (data?['client_id']??'').toString(),
      address: (data?['address']??'').toString(),
      country_id: (data?['country_id']??'').toString(),
      state_id: (data?['state_id']??'').toString(),
      area_id: (data?['area_id']??'').toString(),
      client_street_address_map: (data?['client_street_address_map']??'').toString(),
      client_lat: (data?['client_lat']??'').toString(),
      client_lng: (data?['client_lng']??'').toString(),
      client_url: (data?['client_url']??'').toString(),
      created_at: (data?['created_at']??'').toString(),
      updated_at: (data?['updated_at']??'').toString(),
    );
  }

  final String id;
  final String client_id;
  final String address;
  final String country_id;
  final String state_id;
  final String area_id;
  final String client_street_address_map;
  final String client_lat;
  final String client_lng;
  final String client_url;
  final String created_at;
  final String updated_at;
}
