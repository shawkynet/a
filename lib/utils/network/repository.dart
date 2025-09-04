import 'dart:convert' hide utf8;
import 'dart:io';

import 'package:cargo/models/address_model.dart';
import 'package:cargo/models/address_response_model.dart';
import 'package:cargo/models/area_model.dart';
import 'package:cargo/models/county_model.dart';
import 'package:cargo/models/create_address_model.dart';
import 'package:cargo/models/create_mission_model.dart';
import 'package:cargo/models/create_order_model.dart';
import 'package:cargo/models/currency_model.dart';
import 'package:cargo/models/delivery_times_model.dart';
import 'package:cargo/models/forget_password_model.dart';
import 'package:cargo/models/google_maps_model.dart';
import 'package:cargo/models/mission_model.dart';
import 'package:cargo/models/new_order_config_model.dart';
import 'package:cargo/models/notification_model.dart';
import 'package:cargo/models/package_model.dart';
import 'package:cargo/models/payment_method_model.dart';
import 'package:cargo/models/receiver_model.dart';
import 'package:cargo/models/shipment_model.dart';
import 'package:cargo/models/shipment_settings_model.dart';
import 'package:cargo/models/shipments_response_model.dart';
import 'package:cargo/models/single_package_shipment_model.dart';
import 'package:cargo/models/state_model.dart';
import 'package:cargo/models/user/auth_response_model.dart';
import 'package:cargo/models/user/user_model.dart';
import 'package:cargo/utils/cache/cache_helper.dart';
import 'package:cargo/utils/config/config.dart';
import 'package:cargo/utils/constants/app_keys.dart';
import 'package:cargo/utils/constants/local_keys.dart';
import 'package:cargo/utils/di/di.dart';
import 'package:cargo/utils/errors/server_exception.dart';
import 'package:cargo/utils/network/remote/api_helper.dart';
import 'package:cargo/utils/network/remote/dio_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

abstract class Repository {
  UserModel user = UserModel.fromJson({});

  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  });

  Future<Either<String, ForgetPasswordModel>> forgetPassword({
    required String email,
  });

  Future<Either<String, String>> createShipment({
    required CreateOrderModel createOrderModel,
  });

  Future<Either<String, String>> createMission({
    required CreateMissionModel createMissionModel,
  });

  Future<Either<String, ShipmentResponseModel>> getShipments({String? code,String page});
  Future<Either<String, ShipmentModel>> getTrackingShipments({String? code});
  Future<Either<String, String>> getUserWallet();
  Future<Either<String,CurrencyModel>> getCurrencies();
  Future<Either<String, List<SinglePackageShipmentModel>>> getSingleShipmentPackages({required String shipmentId});
  // Future<Either<String, List<ShipmentResponseModel>>> getShipmentPackages({String code,String page});
  Future<Either<String, List<ShipmentModel>>> getMissionShipments({String id});
  Future<Either<String, List<MissionModel>>> getMissions();

  Future<bool> logout();

  Future<Either<String, List<NotificationModel>>> getNotifications();

  Future<Either<String, UserModel>> register({
    required  UserModel userModel,
  });

  Future<Either<String, List<AddressResponseModel>>> saveNewAddressOfSender({
    required  AddressModel addressModel,
    required  PickResult? pickResult,
  });

  Future<Either<String, List<AddressResponseModel>>> saveNewAddressOfReceiver({
    required  AddressResponseModel addressResponseModel,
  });

  Future<Either<String, ReceiverModel>> saveNewReceiver({
    required  ReceiverModel receiverModel,
  });

  Future<Either<String,List<ReceiverModel>>> getReceivers();
  Future<Either<String,List<AddressResponseModel>>> getReceiversAddresses();
  Future<Either<String,List<UserModel>>> getBranches();
  Future<Either<String,List<ShipmentSettingsModel>>> getShipmentSettings();
  Future<Either<String,List<AddressResponseModel>>> getAddresses();
  Future<Either<String,List<DeliveryTimeModel>>> getDeliveryTimes();
  Future<Either<String,List<PackageModel>>> getPackages();
  Future<Either<String,List<PaymentMethodModel>>> getPaymentTypes();

  Future<Either<String, String>> downloadImage({
    required String url,
  });

  Future<Either<String, List<CountryModel>>> getAllCountries();
  Future<Either<String, GoogleMapsModel>> getGoogleMaps();
  Future<Either<String,NewOrderConfigModel?>> getNewOrderConfig();
  Future<Either<String, List<StateModel>>> getCities({
  required  String countyID,
});

  Future<Either<String, List<AreaModel>>> getAreas({
  required  String cityID,
});
}

class RepoImpl extends Repository {
  final ApiHelper apiHelper;
  final DioHelper dioHelper;
  final CacheHelper cacheHelper;

  RepoImpl({
    required  this.apiHelper,
    required  this.dioHelper,
    required  this.cacheHelper,
  }) {
    // if we want to cache
  }

  @override
  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  }) async {
    return _basicErrorHandling<UserModel>(
      onSuccess: () async {
        String? token = await FirebaseMessaging.instance.getToken();
        final f = await apiHelper.postData(di<Config>().baseURL, 'v1/auth/login', token: null, data: {
          'email': email,
          'device_token': token,
          'password': password,
        });
        final data = jsonDecode(f);
        AuthResponse authResponse = AuthResponse.fromJson(data);
        // email is [email errors]
        if(authResponse.error == null&& (authResponse.email.isEmpty)){
          UserModel userModel = UserModel.fromJson(authResponse.user);
          userModel.api_token = authResponse.api_token;
          user = userModel;
          cacheHelper.put(AppKeys.userData, userModel.toJson());
          return userModel;
        }else{
          print('ddddddd');
          return UserModel.fromJson({
            'error':authResponse.error??authResponse.email.first,
          });
        }
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return tr(LocalKeys.server_error);
      },
    );
  }

  @override
  Future<Either<String, String>> createShipment({
    required CreateOrderModel createOrderModel,
  }) async {

    return _basicErrorHandling<String>(
      onSuccess: () async {
        final f = await apiHelper.postData(di<Config>().baseURL,
                'admin/shipments/create',
                authToken: user.api_token,
                data: createOrderModel.toJson());
        print('createOrderModel.toJson()');
        print(f);
        print(createOrderModel.toJson());
        final data = jsonDecode(f);
        print('admin/shipments/create response');
        print(data);
        if(data is !String){
          return data?['message']??'Shipment Created Successfully';
        }else{
          return 'An error ouccured';
        }

      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print(msg);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, String>> createMission({
    required CreateMissionModel createMissionModel,
  }) async {

    return _basicErrorHandling<String>(
      onSuccess: () async {
        final f = await apiHelper.postData(di<Config>().baseURL, 'createMission',
                token: user.api_token,
                data: createMissionModel.toJson());
        print('ffffff');
        print(createMissionModel.toJson());
        print(f);
        final data = jsonDecode(f);

        if( data !=null && data is !String){
          return data?['message']??'Mission Created Successfully';
        }else{
          return 'An error ouccured';
        }

      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<bool> logout() async {
    await cacheHelper.clear(AppKeys.userData);
    return true;
  }

  @override
  Future<Either<String, UserModel>> register({
    required  UserModel userModel,
  }) async {
    return _basicErrorHandling<UserModel>(
      onSuccess: () async {

        String? token = await FirebaseMessaging.instance.getToken();
        final f = await apiHelper.postData(di<Config>().baseURL, 'v1/auth/signup',typeJSON: false,
                data: userModel.toJsonForRegister(token??''));
        final data = jsonDecode(f);
        print(data);
        AuthResponse authResponse = AuthResponse.fromJson(data);
        // email is [email errors]
        print('authResponse');
        print(data);
        print(authResponse.email);
        if(authResponse.email.isEmpty){
          UserModel userModel = UserModel.fromJson(authResponse.user);
          userModel.api_token = authResponse.api_token;
          user = userModel;
          cacheHelper.put(AppKeys.userData, userModel.toJson());
          return userModel;
        }else{
          print('ddddddd');
          return UserModel.fromJson({
            'error':authResponse.email.first,
          });
        }
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, List<CountryModel>>> getAllCountries() async {
    return _basicErrorHandling<List<CountryModel>>(
      onSuccess: () async {
        List<CountryModel> list = [];
        final data =await jsonDecode(await apiHelper.getData(di<Config>().baseURL, 'countries', token: null,));
        for(int index = 0; index < (data as List).length;index++  ){
          list.add(CountryModel.fromJson(data[index]));
        }
        return list;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, GoogleMapsModel>> getGoogleMaps() async {
    return _basicErrorHandling<GoogleMapsModel>(
      onSuccess: () async {
        final data =await jsonDecode(await apiHelper.getData(di<Config>().baseURL, 'checkGoogleMap', token: user.api_token,));
        GoogleMapsModel googleMapsModel = GoogleMapsModel.fromJson(data);
        return googleMapsModel;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print("msg");
        print(msg);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, List<AddressResponseModel>>> saveNewAddressOfSender({
    required  AddressModel addressModel,
    required  PickResult? pickResult,
  }) async {
    return _basicErrorHandling<List<AddressResponseModel>>(
      onSuccess: () async {
        List<AddressResponseModel> list = [];
        CreateAddressModel createAddressModel = CreateAddressModel(address: addressModel.address_name??'',area: addressModel.area_id??'',client_id: user.id??'',client_lat: (pickResult?.geometry?.location?.lat??'').toString(),client_lng: (pickResult?.geometry?.location?.lng??'').toString(),client_street_address_map: pickResult?.vicinity??'',client_url: pickResult?.url??'',country: (addressModel.country_id??''),state: (addressModel.state_id??''));
        print('createAddressModel.toJson()');
        print(createAddressModel.toJson());
        final f = await apiHelper.postData(di<Config>().baseURL, 'addAddress', token: user.api_token, data: createAddressModel.toJson());
        final data = jsonDecode(f);
        print(">> "+ data.toString());
        for(int index = 0; index < (data as List).length;index++  ){
          list.add(AddressResponseModel.fromJson(data[index]));
        }
         return list;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, List<AddressResponseModel>>> saveNewAddressOfReceiver({
    required  AddressResponseModel addressResponseModel,
  }) async {
    return _basicErrorHandling<List<AddressResponseModel>>(
      onSuccess: () async {
        List<AddressResponseModel> addressModels=[];
        final addresses = await cacheHelper.get(AppKeys.receiverAddresses);
        if(addresses != null){
          for(int index =0; index < (addresses as List).length;index++){
            addressModels.add(AddressResponseModel.fromJson(addresses[index]));
          }
        }
        addressModels.add(addressResponseModel);
        await cacheHelper.put(AppKeys.receiverAddresses, addressModels);
        return addressModels;
      },

      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, ReceiverModel>> saveNewReceiver({
  required  ReceiverModel receiverModel,
}) async {
    return _basicErrorHandling<ReceiverModel>(
      onSuccess: () async {
        List<ReceiverModel> receiverModels=[];
        final receivers = await cacheHelper.get(AppKeys.receivers);
        if(receivers != null){
          for(int index =0; index < (receivers as List).length;index++){
            receiverModels.add(ReceiverModel.fromJson(receivers[index]));
          }
        }
        receiverModels.add(receiverModel);
        await cacheHelper.put(AppKeys.receivers, receiverModels);
        return receiverModel;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String,List<AddressResponseModel>>> getAddresses() async {
    return _basicErrorHandling<List<AddressResponseModel>>(
      onSuccess: () async {

        List<AddressResponseModel> addressModels=[];
        print('RepoImpl.getAddresses user.id : ${user.id}  user.api_token : ${user.api_token}');
        final call = await apiHelper.getData(di<Config>().baseURL, 'getAddresses?client_id=${user.id}', token: user.api_token,);
        final data = jsonDecode(call);
        print('RepoImpl.getAddresses data : ${data.runtimeType.toString() + data.toString()}');
        if (data is List) {
          for(int index =0; index < (data as List).length;index++){
            addressModels.add(AddressResponseModel.fromJson(data[index]));
          }
        }
        return addressModels;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String,List<ReceiverModel>>> getReceivers() async {
    return _basicErrorHandling<List<ReceiverModel>>(
      onSuccess: () async {
        List<ReceiverModel> receiverModels=[];
        final receivers = await cacheHelper.get(AppKeys.receivers);
        if(receivers != null){
          for(int index =0; index < (receivers as List).length;index++){
            receiverModels.add(ReceiverModel.fromJson(receivers[index]));
          }
        }
        return receiverModels;

      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );  }

  @override
  Future<Either<String,List<AddressResponseModel>>> getReceiversAddresses() async {
    return _basicErrorHandling<List<AddressResponseModel>>(
      onSuccess: () async {
        List<AddressResponseModel> receiverAddresses=[];
        final addresses = await cacheHelper.get(AppKeys.receiverAddresses);
        if(addresses != null){
          for(int index =0; index < (addresses as List).length;index++){
            receiverAddresses.add(AddressResponseModel.fromJson(addresses[index]));
          }
        }
        return receiverAddresses;

      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String,List<ShipmentSettingsModel>>> getShipmentSettings() async {
    return _basicErrorHandling<List<ShipmentSettingsModel>>(
      onSuccess: () async {
        List<ShipmentSettingsModel> list=[];
        final call = await apiHelper.getData(di<Config>().baseURL, 'shipment-setting', token: user.api_token,);
        if(call != null){
          final data =await jsonDecode(call);
          for(int index =0; index < (data as List).length;index++){
            list.add(ShipmentSettingsModel.fromJson(data[index]));
          }
        }
        return list;

      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }


  @override
  Future<Either<String,List<UserModel>>> getBranches() async {
    return _basicErrorHandling<List<UserModel>>(
      onSuccess: () async {
        List<UserModel> list=[];
        final call = await apiHelper.getData(di<Config>().baseURL, 'branchs', token: user.api_token,);
        if(call != null){
          final data =await jsonDecode(call);
          for(int index =0; index < (data as List).length;index++){
            list.add(UserModel.fromJson(data[index]));
          }
        }
        return list;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String,List<PackageModel>>> getPackages() async {
    return _basicErrorHandling<List<PackageModel>>(
      onSuccess: () async {
        List<PackageModel> list = [];
        final call = await apiHelper.getData(di<Config>().baseURL, 'packages', token: user.api_token,);
        final data =await jsonDecode(call);
        for(int index = 0; index < (data as List).length;index++  ){
          list.add(PackageModel.fromJson(data[index]));
        }
        return list;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String,List<DeliveryTimeModel>>> getDeliveryTimes() async {
    return _basicErrorHandling<List<DeliveryTimeModel>>(
      onSuccess: () async {
        List<DeliveryTimeModel> list = [];
        final call = await apiHelper.getData(di<Config>().baseURL, 'DeliveryTimes', token: user.api_token,);
        final data =await jsonDecode(call);
        for(int index = 0; index < (data as List).length;index++  ){
          list.add(DeliveryTimeModel.fromJson(data[index]));
        }
        return list;

      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String,List<PaymentMethodModel>>> getPaymentTypes() async {
    return _basicErrorHandling<List<PaymentMethodModel>>(
      onSuccess: () async {
        List<PaymentMethodModel> list = [];
        final call = await apiHelper.getData(di<Config>().baseURL, 'payment-types', token: user.api_token,);
        Map data =await jsonDecode(call) as Map;
         
        print('getPaymentTypes');
        print(data);
        for(int index = 0; index < data.keys.length;index++  ){
          if(data[data.keys.toList()[index]]!=false){
          list.add(PaymentMethodModel.fromJson({'name':data.keys.toList()[index]}));
          }
        }
        return list;

      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, NewOrderConfigModel?>> getNewOrderConfig() async {
    return _basicErrorHandling<NewOrderConfigModel?>(
      onSuccess: () async {
        final response = await apiHelper.getData(
          di<Config>().baseURL,
          'config?client_id=${user.id}',
          token: user.api_token,
        );
        if (response != null) {
          final json = jsonDecode(response);
          return NewOrderConfigModel.fromJson(json);
        }
        return null;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, List<StateModel>>> getCities({
    required  String countyID,
  }) async {
    return _basicErrorHandling<List<StateModel>>(
      onSuccess: () async {
        List<StateModel> list = [];
        final call = await apiHelper.getData(di<Config>().baseURL, 'states?country_id=$countyID', token: null,);
        final data =await jsonDecode(call);
        for(int index = 0; index < (data as List).length;index++  ){
          list.add(StateModel.fromJson(data[index]));
        }
        return list;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, ShipmentResponseModel>> getShipments({String? code,String? page}) async {
    return _basicErrorHandling<ShipmentResponseModel>(
      onSuccess: () async {
        if(code == null){
          code = '';
        }
        final call = await apiHelper.getData(di<Config>().baseURL, 'shipments?code=$code&page=${page??1}', token: user.api_token,);
        // final data2= (call.split(',"All Shipments",').first).substring(1,(call.split(',"All Shipments",').first).length);
        final data =await jsonDecode(call);
        ShipmentResponseModel shipmentResponseModel = ShipmentResponseModel.fromJson(data);
        return shipmentResponseModel;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, ShipmentModel>> getTrackingShipments({String? code,String? page}) async {
    return _basicErrorHandling<ShipmentModel>(
      onSuccess: () async {
        if(code == null){
          code = '';
        }
        final call = await apiHelper.getData(di<Config>().baseURL, 'shipment-tracking?code=$code', token: user.api_token,);
        // final data2= (call.split(',"All Shipments",').first).substring(1,(call.split(',"All Shipments",').first).length);
        final data =await jsonDecode(call);
        ShipmentModel shipmentModel = ShipmentModel.fromJson(data);
        return shipmentModel;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, String>> getUserWallet() async {
    return _basicErrorHandling<String>(
      onSuccess: () async {
        final call = await apiHelper.getData(di<Config>().baseURL, 'get-wallet?type=client', token: user.api_token,);
        di<Repository>().user.balance = call ;
        return call;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, List<SinglePackageShipmentModel>>> getSingleShipmentPackages({required String shipmentId}) async {
    return _basicErrorHandling<List<SinglePackageShipmentModel>>(
      onSuccess: () async {
        List<SinglePackageShipmentModel> ships=[];

        final call = await apiHelper.getData(di<Config>().baseURL, 'shipmentPackages?shipment_id=$shipmentId', token: user.api_token,);
        print('call getSingleShipmentPackages');
        print(call);
        final data =await jsonDecode(call);
        for(int index = 0; index < (data as List).length;index++  ){
          ships.add(SinglePackageShipmentModel.fromJson(data[index]));
        }
        return ships;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String,CurrencyModel>> getCurrencies() async {
    return _basicErrorHandling<CurrencyModel>(
 onSuccess: () async {
      List<CurrencyModel> currencies=[];

      final call = await apiHelper.getData(di<Config>().baseURL, 'get-system-currency', token: user.api_token,);
      final data =await jsonDecode(call);

      return CurrencyModel.fromJson(data);

    },
    onServerError: (exception) async {
    final f = exception.error;
    final msg = _handleErrorMessages(f['message']);
    print('This is The error : $exception');
    return LocalKeys.server_error;
    },
    );

  }

  @override
  Future<Either<String, List<ShipmentModel>>> getMissionShipments({String? id}) async {
    return _basicErrorHandling<List<ShipmentModel>>(
      onSuccess: () async {
        List<ShipmentModel> ships=[];

        final call = await apiHelper.getData(di<Config>().baseURL, 'MissionShipments?mission_id=$id', token: user.api_token,);
        final data =await jsonDecode(call);
        for(int index = 0; index < (data as List).length; index ++){
          ships.add(ShipmentModel.fromJson(data[index]));
        }
        return ships;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }
@override

  @override
  Future<Either<String, List<MissionModel>>> getMissions() async {
    return _basicErrorHandling<List<MissionModel>>(
      onSuccess: () async {
        List<MissionModel> missions=[];
        final call = await apiHelper.getData(di<Config>().baseURL, 'missions?client_id=${user.id}}&page=1', token: user.api_token,);
        final data =await jsonDecode(call);
        for(int index = 0; index < (data as List).length;index++  ){
          missions.add(MissionModel.fromJson(data[index]));
        }
        return missions;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }
@override

  Future<Either<String, List<NotificationModel>>> getNotifications() async {
    return _basicErrorHandling<List<NotificationModel>>(
      onSuccess: () async {
        List<NotificationModel> notifications=[];
        final call = await apiHelper.getData(di<Config>().baseURL, 'notifications?user_id=${user.id}', token: user.api_token,);
        final data =await jsonDecode(call);
        for(int index = 0; index < (data as List).length;index++  ){
          notifications.add(NotificationModel.fromJson(data[index]));
        }
        return notifications;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

 @override
  Future<Either<String, List<AreaModel>>> getAreas({
   required  String cityID,
  }) async {
    return _basicErrorHandling<List<AreaModel>>(
      onSuccess: () async {
        List<AreaModel> list = [];
        final data =await jsonDecode(await apiHelper.getData(di<Config>().baseURL, 'areas?state_id=$cityID', token: null,));
        for(int index = 0; index < (data as List).length;index++  ){
          list.add(AreaModel.fromJson(data[index]));
        }
        return list;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return LocalKeys.server_error;
      },
    );
  }

  @override
  Future<Either<String, String>> downloadImage({
    required String url,
  }) async {
    return _basicErrorHandling<String>(
      onSuccess: () async {

        var request = await HttpClient().getUrl(Uri.parse(url));
        var response = await request.close();
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);
        Directory? directory;
        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory();
        } else {
          directory = await getApplicationDocumentsDirectory();
        }
        final directoryPath = directory?.path;
        if (directoryPath == null) {
          return '';
        }
        File file = new File(path.join(directoryPath, 'cargo.jpg')
        );
        file.writeAsBytesSync(bytes); // This is a sync operation on a real
        final String localPath ='${directoryPath}/cargo.jpg';
        await cacheHelper.put(AppKeys.APP_LOGO_PATH, localPath);
        return localPath;
      },
    );
  }

  @override
  Future<Either<String, ForgetPasswordModel>> forgetPassword({required String email}) {
    return _basicErrorHandling<ForgetPasswordModel>(
      onSuccess: () async {
        final f = await apiHelper.postData(di<Config>().baseURL, 'reset/password/email', token: null, data: {
          'email': email,
        });
        final data = jsonDecode(f);
        print('login data');
        print(data);
        ForgetPasswordModel forgetPasswordModel = ForgetPasswordModel.fromJson(data);
        // email is [email errors]
        return forgetPasswordModel;
      },
      onServerError: (exception) async {
        final f = exception.error;
        final msg = _handleErrorMessages(f['message']);
        print('This is The error : $exception');
        return tr(LocalKeys.server_error);
      },
    );
  }
}

extension on Repository {
  String _handleErrorMessages(final dynamic f) {
    String msg = '';
    if (f is String) {
      msg = f;
    } else if (f is Map) {
      for (dynamic l in f.values) {
        if (l is List) {
          for (final s in l) {
            msg += '$s\n';
          }
        }
      }
      if (msg.contains('\n')) {
        msg = msg.substring(0, msg.lastIndexOf('\n'));
      }
      if (msg.isEmpty) {
        msg = 'Server Error';
      }
    } else {
      msg = 'Server Error';
    }
    print('This is The error : $f');
    return LocalKeys.server_error;
  }

  Future<Either<String, T>> _basicErrorHandling<T>({
    required  Future<T> onSuccess(),
    Future<String> onServerError(ServerException exception)?,
    Future<String> onCacheError(CacheException exception)?,
    Future<String> onOtherError(Exception exception)?,
  }) async {
    try {
      final f = await onSuccess();
      return Right(f);
    }  catch (e, s) {
      print(e);
      print(s);
      return Left(tr(LocalKeys.server_error));

    }
  }
}
