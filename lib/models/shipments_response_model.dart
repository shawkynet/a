import 'package:cargo/models/shipment_model.dart';

class ShipmentResponseModel {
  ShipmentResponseModel({
    required this.current_page,
    required this.data,
    required this.last_page
  });

  static fromJson(data) {
    List<ShipmentModel> ships=[];

    for(int index = 0; index < ((data?['data']??[]) as List).length;index++  ){
      ships.add(ShipmentModel.fromJson(data['data'][index]));
    }

    return ShipmentResponseModel(
      current_page: (data?['current_page']??'').toString(),
      data: ships,
      last_page: (data?['last_page']??'').toString(),
    );
  }

  final String current_page;
  final List<ShipmentModel> data;
  final String last_page;
}

