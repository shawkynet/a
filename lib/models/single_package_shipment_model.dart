import 'dart:convert';

class SinglePackageShipmentModel {
    SinglePackageShipmentModel(
            {required this.id,
      required this.created_at,
      required this.updated_at,
      required this.package_id,
      required this.shipment_id,
      required this.description,
      required this.weight,
      required this.length,
      required this.width,
      required this.height,
      required this.qty,
                required this.package});

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'id': id,
            'created_at': created_at,
            'updated_at': updated_at,
            'package_id': package_id,
            'shipment_id': shipment_id,
            'description': description,
            'weight': weight,
            'length': length,
            'width': width,
            'height': height,
            'qty': qty,
            'package': package,
        };
    }

    static fromJson(data) {
        return SinglePackageShipmentModel(
            id: (data?['id']??'').toString(),
            created_at: (data?['created_at']??''),
            updated_at: (data?['updated_at']??''),
            package_id: (data?['package_id']??'').toString(),
            shipment_id: (data?['shipment_id']??'').toString(),
            description: (data?['description']??''),
            weight: (data?['weight']??'0').toString(),
            length: (data?['length']??'0').toString(),
            width: (data?['width']??'0').toString(),
            height: (data?['height']??'0').toString(),
            qty: (data?['qty']??'0').toString(),
            package: PackageSubModel.fromJson(data?['package']??{}),
        );
    }

    final String id;
    final String created_at;
    final String updated_at;
    final String package_id;
    final String shipment_id;
    final String description;
    final String weight;
    final String length;
    final String width;
    final String height;
    final String qty;
    final PackageSubModel package;
}

class PackageSubModel {
    PackageSubModel({required this.id, required this.name, required this.created_at, required this.updated_at, required this.cost});

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'id': id,
            'name': name,
            'created_at': created_at,
            'updated_at': updated_at,
            'cost': cost,
        };
    }

    static fromJson(user) {
    final name = jsonDecode(user['name'])['en'];

        return PackageSubModel(
            id: user['id'].toString(),
            name: name,
            created_at: user['created_at'],
            updated_at: user['updated_at'],
            cost: user['cost'].toString(),
        );
    }

    final String id;
    final String name;
    final String created_at;
    final String updated_at;
    final String cost;
}
