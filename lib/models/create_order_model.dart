import 'dart:convert';

import 'new_order/address_new_order.dart';

class CreateOrderModel {
  CreateOrderModel(
      {required  this.shipment_type,
      required  this.shipment_branch_id,
      required  this.shipment_shipping_date,
      required  this.shipment_client_phone,
      required  this.shipment_client_address,
      required  this.shipment_reciver_name,
      required  this.shipment_client_lat,
      required  this.shipment_client_lng,
      required  this.shipment_client_street_address_map,
      required  this.shipment_client_url,
      required  this.delivery_time,
      required  this.collection_time,
      required  this.order_id,
      required  this.shipment_reciver_street_address_map,
      required  this.shipment_reciver_lat,
      required  this.shipment_reciver_lng,
      required  this.shipment_reciver_url,
      required  this.shipment_reciver_phone,
      required  this.shipment_reciver_address,
      required  this.amount_to_be_collected,
      required  this.shipment_from_country_id,
      required  this.shipment_to_country_id,
      required  this.shipment_to_area_id,
      required  this.shipment_from_area_id,
      required  this.shipment_from_state_id,
      required  this.shipment_to_state_id,
      required  this.shipment_payment_type,
      required  this.shipment_payment_method_id,
      required  this.packages});

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  Map<String, dynamic> toJson() {
      Map<String,dynamic> shipmentPackages={};
      print('shipment_client_phone');
      print(shipment_client_phone);
      for (var index = 0; index <packages.length; index++) {
        shipmentPackages.addAll({
            if(packages.length>index) 'Package[$index][description]': packages[index].description??'',
            if(packages.length>index && packages[index].packageModel?.id!=null) 'Package[$index][package_id]': packages[index].packageModel?.id??'',
            if(packages.length>index) 'Package[$index][qty]': packages[index].quantity,
            if(packages.length>index) 'Package[$index][weight]': packages[index].weight,
            if(packages.length>index) 'Package[$index][length]': packages[index].length,
            if(packages.length>index) 'Package[$index][width]': packages[index].width,
            if(packages.length>index) 'Package[$index][height]': packages[index].height,
        });
      }
      shipmentPackages.addAll({
          if(shipment_type!=null) 'Shipment[type]': shipment_type??'',
          if(shipment_branch_id!=null) 'Shipment[branch_id]': shipment_branch_id??'',
          if(shipment_shipping_date!=null) 'Shipment[shipping_date]': shipment_shipping_date??'',
          if(shipment_client_phone!=null) 'Shipment[client_phone]': shipment_client_phone??'',
          if(delivery_time!=null) 'Shipment[delivery_time]': delivery_time??'',
          if(shipment_client_address!=null) 'Shipment[client_address]': shipment_client_address??'',
          if(shipment_reciver_name!=null) 'Shipment[reciver_name]': shipment_reciver_name??'',
          if(shipment_reciver_phone!=null) 'Shipment[reciver_phone]': shipment_reciver_phone??'',
          if(shipment_reciver_address!=null) 'Shipment[reciver_address]': shipment_reciver_address??'',
          if(amount_to_be_collected!=null) 'Shipment[amount_to_be_collected]': amount_to_be_collected??'',
          if(shipment_from_country_id!=null) 'Shipment[from_country_id]': shipment_from_country_id??'',
          if(shipment_to_country_id!=null) 'Shipment[to_country_id]': shipment_to_country_id??'',
          if(shipment_from_area_id!=null) 'Shipment[from_area_id]': shipment_from_area_id??'',
          if(shipment_to_area_id!=null) 'Shipment[to_area_id]': shipment_to_area_id??'',
          if(collection_time!=null) 'Shipment[collection_time]': collection_time??'',
          if(order_id!=null) 'Shipment[order_id]': order_id??'',
          if(shipment_from_state_id!=null) 'Shipment[from_state_id]': shipment_from_state_id??'',
          if(shipment_to_state_id!=null) 'Shipment[to_state_id]': shipment_to_state_id??'',
          if(shipment_payment_type!=null) 'Shipment[payment_type]': shipment_payment_type??'',
          if(shipment_payment_method_id!=null) 'Shipment[payment_method_id]': shipment_payment_method_id??'',
          if(shipment_reciver_street_address_map!=null) 'Shipment[reciver_street_address_map]': shipment_reciver_street_address_map??'',
          if(shipment_reciver_lat!=null) 'Shipment[reciver_lat]': shipment_reciver_lat??'',
          if(shipment_reciver_lng!=null) 'Shipment[reciver_lng]': shipment_reciver_lng??'',
          if(shipment_reciver_url!=null) 'Shipment[reciver_url]': shipment_reciver_url??'',
          if(shipment_reciver_street_address_map!=null) 'Shipment[client_street_address_map]': shipment_reciver_street_address_map??'',
          if(shipment_reciver_lat!=null) 'Shipment[client_lat]': shipment_reciver_lat??'',
          if(shipment_reciver_lng!=null) 'Shipment[client_lng]': shipment_reciver_lng??'',
          if(shipment_reciver_url!=null) 'Shipment[client_url]': shipment_reciver_url??'',
      });
    return shipmentPackages;
  }

  // static fromJson(user) {
  //   return CreateOrderModel();
  // }

  final String? shipment_type;
  final String? shipment_branch_id;
  final String? shipment_shipping_date;
  final String? shipment_client_phone;
  final String? shipment_client_address;
  final String? delivery_time;
  final String? shipment_reciver_name;
  final String? shipment_reciver_phone;
  final String? shipment_reciver_address;
  final String? shipment_from_country_id;
  final String? shipment_to_country_id;
  final String? shipment_from_state_id;
  final String? shipment_to_area_id;
  final String? shipment_from_area_id;
  final String? shipment_to_state_id;
  final String? amount_to_be_collected;
  final String? shipment_reciver_street_address_map;
  final String? shipment_reciver_lat;
  final String? shipment_reciver_lng;
  final String? shipment_reciver_url;
  final String? shipment_client_street_address_map;
  final String? shipment_client_lat;
  final String? shipment_client_lng;
  final String? shipment_client_url;
  final String? shipment_payment_type;
  final String? shipment_payment_method_id;
  final String? collection_time;
  final String? order_id;
  final List<AddressOrderModel> packages;
}
