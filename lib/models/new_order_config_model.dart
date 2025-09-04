import 'dart:convert';

import 'address_response_model.dart';
import 'delivery_times_model.dart';
import 'package_model.dart';
import 'payment_method_model.dart';
import 'shipment_settings_model.dart';
import 'user/user_model.dart';

class NewOrderConfigModel {
  final List<ShipmentSettingsModel> shipmentSettings;
  final List<AddressResponseModel> addresses;
  final List<UserModel> branches;
  final List<PackageModel> packages;
  final List<DeliveryTimeModel> deliveryTimes;
  final List<PaymentMethodModel> paymentTypes;

  NewOrderConfigModel({
    required  this.shipmentSettings,
    required  this.addresses,
    required  this.branches,
    required  this.packages,
    required  this.deliveryTimes,
    required  this.paymentTypes,
  });

  factory NewOrderConfigModel.fromJson(Map<String, dynamic> json) => NewOrderConfigModel(
        shipmentSettings: (json['shipment_setting'] as List).map((e) => ShipmentSettingsModel.fromJson(e)).cast<ShipmentSettingsModel>().toList(),
        addresses: (json['addresses'] as List).map((e) => AddressResponseModel.fromJson(e)).cast<AddressResponseModel>().toList(),
        branches: (json['branches'] as List).map((e) => UserModel.fromJson(e)).cast<UserModel>().toList(),
        packages: (json['packages'] as List).map((e) => PackageModel.fromJson(e)).cast<PackageModel>().toList(),
        deliveryTimes: (json['delivery_times'] as List).map((e) => DeliveryTimeModel.fromJson(e)).cast<DeliveryTimeModel>().toList(),
        paymentTypes: (json['payment_types'] as Map<String, dynamic>)
            .entries
            .where((e) => e.value != false)
            .map((e) => PaymentMethodModel.fromJson({'name': e.key}))
            .cast<PaymentMethodModel>()
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'shipment_setting': shipmentSettings.map((e) => e.toJson()).toList(),
        'addresses': addresses.map((e) => e.toJson()).toList(),
        'branches': branches.map((e) => e.toJson()).toList(),
        'packages': packages.map((e) => e.toJson()).toList(),
        'delivery_times': deliveryTimes.map((e) => e.toJson()).toList(),
        'payment_types': paymentTypes.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
