import 'dart:convert';

class ShipmentModel {
    ShipmentModel({
        required this.id,
        required this.message,
        required this.code,
        required this.status_id,
        required this.type,
        required this.branch_id,
        required this.error,
        required this.shipping_date,
        required this.otp,
        required this.client_id,
        required this.client_address,
        required this.payment_type,
        required this.paid,
        required this.payment_integration_id,
        required this.payment_method_id,
        required this.tax,
        required this.insurance,
        required this.delivery_time,
        required this.shipping_cost,
        required this.total_weight,
        required this.employee_user_id,
        required this.client_street_address_map,
        required this.client_lat,
        required this.client_lng,
        required this.client_url,
        required this.reciver_street_address_map,
        required this.reciver_lat,
        required this.from_address,
        required this.reciver_lng,
        required this.reciver_url,
        required this.attachments_before_shipping,
        required this.attachments_after_shipping,
        required this.client_phone,
        required this.reciver_phone,
        required this.created_at,
        required this.updated_at,
        required this.reciver_name,
        required this.reciver_address,
        required this.mission_id,
        required this.captain_id,
        required this.return_cost,
        required this.from_country_id,
        required this.from_state_id,
        required this.from_area_id,
        required this.to_country_id,
        required this.to_state_id,
        required this.to_area_id,
        required this.prev_branch,
        required this.client_status,
        required this.amount_to_be_collected,
        required this.barcode,
        required this.logs,
    });

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    Map<String, String> toJson() {
        return  {
            'id': id,
            'code': code,
            'status_id': status_id,
            'type': type,
            'branch_id': branch_id,
            'otp': otp,
            'error': error,
            'shipping_date': shipping_date,
            'client_id': client_id,
            'client_address': client_address,
            'payment_type': payment_type,
            'paid': paid,
            'payment_integration_id': payment_integration_id,
            'payment_method_id': payment_method_id,
            'tax': tax,
            'insurance': insurance,
            'delivery_time': delivery_time,
            'shipping_cost': shipping_cost,
            'total_weight': total_weight,
            'employee_user_id': employee_user_id,
            'client_street_address_map': client_street_address_map,
            'client_lat': client_lat,
            'client_lng': client_lng,
            'client_url': client_url,
            'reciver_street_address_map': reciver_street_address_map,
            'reciver_lat': reciver_lat,
            'reciver_lng': reciver_lng,
            'reciver_url': reciver_url,
            'attachments_before_shipping': attachments_before_shipping,
            'attachments_after_shipping': attachments_after_shipping,
            'client_phone': client_phone,
            'reciver_phone': reciver_phone,
            'created_at': created_at,
            'updated_at': updated_at,
            'reciver_name': reciver_name,
            'reciver_address': reciver_address,
            'mission_id': mission_id,
            'captain_id': captain_id,
            'return_cost': return_cost,
            'from_country_id': from_country_id,
            'from_state_id': from_state_id,
            'from_area_id': from_area_id,
            'to_country_id': to_country_id,
            'to_state_id': to_state_id,
            'to_area_id': to_area_id,
            'prev_branch': prev_branch,
            'client_status': client_status,
            'amount_to_be_collected': amount_to_be_collected,
            'barcode': barcode,
        };
    }

    static fromJson(data) {
        List<ShipmentLogModel> logsModels=[];

        if (data !=null && data['logs']!= null) {
          for(int index = 0; index < (data['logs'] as List).length;index++  ){
              logsModels.add(ShipmentLogModel.fromJson(data['logs'][index]));
          }
        }
    // final delivery_time = jsonDecode(user['delivery_time'])['en'];
        

        return ShipmentModel(
            id: (data['id']??'').toString(),
            message: data?['message']??'',
            code: data?['code']??'',
            status_id: (data?['status_id']??''??'').toString(),
            type: (data?['type']??'').toString(),
            branch_id: (data?['branch_id']??''??'').toString(),
            otp: (data?['otp']??''??'').toString(),
            error: data?['error']??'',
            shipping_date: data?['shipping_date']??'',
            client_id: (data?['client_id']??''??'').toString(),
            client_address: data?['client_address']??'',
            payment_type: (data?['payment_type']??''??'').toString(),
            paid: (data?['paid']??''??'').toString(),
            payment_integration_id: data?['payment_integration_id']??'',
            payment_method_id: (data?['payment_method_id']??''??'').toString(),
            tax: (data?['tax']??''??'').toString(),
            insurance: (data?['insurance']??''??'').toString(),
            delivery_time: data?['delivery_time']??'',
            shipping_cost: (data?['shipping_cost']??''??'').toString(),
            total_weight: (data?['total_weight']??''??'').toString(),
            employee_user_id: data?['employee_user_id']??'',
            client_street_address_map: data?['client_street_address_map']??'',
            client_lat: data?['client_lat']??'',
            client_lng: data?['client_lng']??'',
            client_url: data?['client_url']??'',
            reciver_street_address_map: data?['reciver_street_address_map']??'',
            reciver_lat: data?['reciver_lat']??'',
            reciver_lng: data?['reciver_lng']??'',
            reciver_url: data?['reciver_url']??'',
            attachments_before_shipping: data?['attachments_before_shipping']??'',
            attachments_after_shipping: data?['attachments_after_shipping']??'',
            client_phone: data?['client_phone']??'',
            reciver_phone: data?['reciver_phone']??'',
            created_at: data?['created_at']??'',
            updated_at: data?['updated_at']??'',
            reciver_name: data?['reciver_name']??'',
            reciver_address: data?['reciver_address']??'',
            mission_id: (data?['mission_id']??''??'').toString(),
            captain_id: (data?['captain_id']??'').toString(),
            return_cost: (data?['return_cost']??''??'').toString(),
            from_country_id: (data?['from_country_id']??''??'').toString(),
            from_state_id: (data?['from_state_id']??''??'').toString(),
            from_area_id: (data?['from_area_id']??''??'').toString(),
            to_country_id: (data?['to_country_id']??''??'').toString(),
            to_state_id: (data?['to_state_id']??''??'').toString(),
            to_area_id: (data?['to_area_id']??''??'').toString(),
            prev_branch: (data?['prev_branch']??''??'').toString(),
            client_status: (data?['client_status']??''??'').toString(),
            amount_to_be_collected: (data?['amount_to_be_collected']??'').toString(),
            barcode: data?['barcode']??'',
            logs: logsModels,
            from_address: FromAddressModel.fromJson(data?['from_address']??{}),
        );
    }

    final String message;
    final String id;
    final String code;
    final String status_id;
    final String type;
    final String branch_id;
    final String error;
    final String otp;
    final String shipping_date;
    final String client_id;
    final String client_address;
    final String payment_type;
    final String paid;
    final String payment_integration_id;
    final String payment_method_id;
    final String tax;
    final String insurance;
    final String delivery_time;
    final String shipping_cost;
    final String total_weight;
    final String employee_user_id;
    final String client_street_address_map;
    final String client_lat;
    final String client_lng;
    final String client_url;
    final String reciver_street_address_map;
    final String reciver_lat;
    final String reciver_lng;
    final String reciver_url;
    final String attachments_before_shipping;
    final String attachments_after_shipping;
    final String client_phone;
    final String reciver_phone;
    final String created_at;
    final String updated_at;
    final String reciver_name;
    final String reciver_address;
    final String mission_id;
    final String captain_id;
    final String return_cost;
    final String from_country_id;
    final String from_state_id;
    final String from_area_id;
    final String to_country_id;
    final String to_state_id;
    final String to_area_id;
    final String prev_branch;
    final String client_status;
    final String amount_to_be_collected;
    final String barcode;
    final List<ShipmentLogModel> logs;
    final FromAddressModel from_address;
}
class FromAddressModel {
    FromAddressModel(
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
                required this.client_url});

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
        };
    }

    static fromJson(user) {
        return FromAddressModel(
            id:( user['id']??'').toString(),
            client_id:( user['client_id']??'').toString(),
            address:( user['address']??'').toString(),
            country_id:( user['country_id']??'').toString(),
            state_id:(  user['state_id']??'').toString(),
            area_id:( user['area_id']??'').toString(),
            client_street_address_map:( user['client_street_address_map']??'').toString(),
            client_lat:( user['client_lat']??'').toString(),
            client_lng:( user['client_lng']??'').toString(),
            client_url:( user['client_url']??'').toString(),
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
}

class ShipmentLogModel {
    ShipmentLogModel(
            {required this.id,
      required this.from,
      required this.to,
      required this.created_by,
      required this.shipment_id,
      required this.created_at,
      required this.updated_at});

    @override
    String toString() {
        return jsonEncode(toJson());
    }

    toJson() {
        return {
            'id': id,
            'from': from,
            'to': to,
            'created_by': created_by,
            'shipment_id': shipment_id,
            'created_at': created_at,
            'updated_at': updated_at,
        };
    }

    static fromJson(user) {
        return ShipmentLogModel(
            id:( user['id']??'').toString(),
            from:( user['from']??'').toString(),
            to:( user['to']??'').toString(),
            created_by:( user['created_by']??'').toString(),
            shipment_id:( user['shipment_id']??'').toString(),
            created_at:( user['created_at']??'').toString(),
            updated_at:( user['updated_at']??'').toString(),
        );
    }

    final String id;
    final String from;
    final String to;
    final String created_by;
    final String shipment_id;
    final String created_at;
    final String updated_at;
}


/*
 "logs": [
        {
            "id": 5,
            "from": 1,
            "to": 3,
            "created_by": 1,
            "shipment_id": 56,
            "created_at": "2021-07-12 11:20:21",
            "updated_at": "2021-07-12 11:20:21"
        }
    ]
*/