import 'dart:convert';

import 'package:cargo/models/package_model.dart';

class AddressOrderModel {
    AddressOrderModel(
            {
                // required this.index,
                this.packageModel,
                required this.quantity,
                required this.weight,
                required this.weightUnit,
                required this.height,
                required this.heightUnit,
                required this.width,
                required this.widthUnit,
                required this.length,
                required this.lengthUnit,
                required this.description,
            });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    Map<String, String> toJson() {
        return  {
            'packageModel': packageModel?.toJson(),
            'quantity': quantity,
            'weight': weight,
            'weightUnit': weightUnit,
            'height': height,
            'heightUnit': heightUnit,
            'width': width,
            'widthUnit': widthUnit,
            'length': length,
            'lengthUnit': lengthUnit,
            'description': description??'',
        };
    }

    static fromJson(data) {
        return AddressOrderModel(
            packageModel: AddressOrderModel.fromJson(data?['packageModel']??{}),
            quantity: data?['quantity']??'',
            weight: data?['weight']??'',
            weightUnit: data?['weightUnit']??'',
            height: data?['height']??'',
            heightUnit: data?['heightUnit']??'',
            width: data?['width']??'',
            widthUnit: data?['widthUnit']??'',
            length: data?['length']??'',
            lengthUnit: data?['lengthUnit']??'',
            description: data?['description']??'',
          // index: user['index'],
        );
    }

    // int index ;
    PackageModel? packageModel;
    String quantity;
    String weight;
    String weightUnit;
    String height;
    String heightUnit;
    String width;
    String widthUnit;
    String length;
    String lengthUnit;
    String? description;
}
