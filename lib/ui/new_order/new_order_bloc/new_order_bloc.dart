import 'package:cargo/models/address_response_model.dart';
import 'package:cargo/models/create_order_model.dart';
import 'package:cargo/models/delivery_times_model.dart';
import 'package:cargo/models/new_order/address_new_order.dart';
import 'package:cargo/models/package_model.dart';
import 'package:cargo/models/payment_method_model.dart';
import 'package:cargo/models/receiver_model.dart';
import 'package:cargo/models/shipment_settings_model.dart';
import 'package:cargo/models/user/user_model.dart';
import 'package:cargo/ui/new_order/new_order_bloc/new_order_events.dart';
import 'package:cargo/ui/new_order/new_order_bloc/new_order_states.dart';
import 'package:cargo/ui/new_order/settings_new_order.dart';
import 'package:cargo/utils/constants/app_keys.dart';
import 'package:cargo/utils/constants/constants.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

class NewOrderBloc extends Bloc<NewOrderEvents, NewOrderStates> {
  final Repository _repository;
  // Position location;
  // LatLng latLng;
  int currentIndex = 0;
  bool isPickup = true;
  DateTime? dateTime ;
  TimeOfDay collectionTime = TimeOfDay.now();
  intl.DateFormat dateFormat = intl.DateFormat('HH:mm');

  List<ReceiverModel> receivers= [];
  List<UserModel> branches= [];
  List<AddressResponseModel> addresses= [];
  List<AddressResponseModel> receiverAddresses= [];
  List<ShipmentSettingsModel> settings= [];
  List<PackageModel> packages= [];
  List<PaymentMethodModel> paymentMethods= [];
  List<AddressOrderModel> packageWidgets= [];
  List<DeliveryTimeModel> deliveryTimes= [];

  PaymentMethodModel?  paymentMethodModel;
  PackageModel?  defaultPackage;
  int?  paymentType;
  AddressResponseModel?  senderAddress;
  UserModel?  selectedBranch;
  DeliveryTimeModel?  selectedDeliveryTime;
  AddressResponseModel?  receiverAddress;
  ReceiverModel?  receiverModel;

  String amount_to_be_collected = '0';
  String orderID = '';
  String weightUnit = AppKeys.weights.first;
  String heightUnit= AppKeys.heights.first;
  String widthUnit= AppKeys.heights.first;
  String lengthUnit= AppKeys.heights.first;
  bool errorOccurred= false ;

  NewOrderBloc(this._repository) : super(InitialNewOrderState());

  static NewOrderBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<NewOrderStates> mapEventToState(NewOrderEvents event) async*
  {
    if (event is NextNewOrderEvent) {
      yield SuccessNextNewOrderState();
    }

    if (event is ChangeCollectionTimeNewOrderEvent) {
      collectionTime = event.timeOfDay;
      yield SuccessChangedCollectionTimeOrderState();
    }

    if (event is SetPaymentMethodNewOrderEvent) {
      yield SuccessPaymentMethodState();
    }

    if (event is SetAmountToBeCollectedNewOrderEvent) {
      yield SuccessSetAmountToBeCollectedNewOrderState();
    }
    if (event is SetOrderIDNewOrderEvent) {
      yield SuccessSetOrderIdNewOrderState();
    }

    if (event is CreateNewOrderEvent) {
      yield LoadingNewOrderState();
      final createOrderModel =
         CreateOrderModel(
        shipment_client_lat: senderAddress?.client_lat??'',
        shipment_client_lng: senderAddress?.client_lng??'',
        shipment_client_street_address_map: senderAddress?.client_street_address_map??'',
        shipment_client_url: senderAddress?.client_url??'',
        shipment_reciver_lat: receiverAddress?.client_lat??'',
        shipment_reciver_lng: receiverAddress?.client_lng??'',
        shipment_reciver_street_address_map: receiverAddress?.client_street_address_map??'',
        shipment_reciver_url: receiverAddress?.client_url??'',
           delivery_time:selectedDeliveryTime?.id??'',
        packages: packageWidgets,
        shipment_payment_type: paymentType.toString(),
        shipment_reciver_address: receiverAddress?.address??'',
        shipment_reciver_name: receiverModel?.receiver_name??'',
        shipment_reciver_phone: receiverModel?.receiver_mobile??'',
        shipment_shipping_date: (dateTime?.year??'').toString()+ '-'+ ((dateTime?.month??0) > 9?'':'0')+ (dateTime?.month??'').toString()+ '-'+ ((dateTime?.day??0) >9?'':'0')+ (dateTime?.day??0).toString(),
        shipment_to_country_id: receiverAddress?.country_id??'',
        shipment_to_area_id: receiverAddress?.area_id??'',
        shipment_to_state_id: receiverAddress?.state_id??'',
        shipment_type: isPickup? AppKeys.PICKUP.toString() : AppKeys.DROPOFF.toString(),
        shipment_branch_id: selectedBranch?.id??'',
        shipment_client_address: senderAddress?.id??'',
        shipment_client_phone: _repository.user.responsible_mobile??'',
        shipment_from_country_id: senderAddress?.country_id??'',
        shipment_from_area_id: senderAddress?.area_id??'',
        shipment_from_state_id: senderAddress?.state_id??'',
        amount_to_be_collected: amount_to_be_collected,
        shipment_payment_method_id: (paymentMethodModel?.name??'').toString(),
        collection_time: dateFormat.format(DateTime(0,0,0,collectionTime.hourOfPeriod,collectionTime.minute,0,0,0))
        + getDayPeriodString(collectionTime.period)
        ,
        order_id: orderID,
      );

      final response = await _repository.createShipment(
        createOrderModel: createOrderModel
      );
      yield* response.fold((l) async*{
        yield ErrorNewOrderState(l);
         showToast(l,false);
      }, (r)async*{
        yield SuccessCreateOrderState();
         showToast(r,true);
      });
    }

    if (event is SetSenderAddressNewOrderEvent) {
      yield SuccessSenderAddressOrderState();
    }

    if (event is SetBranchNewOrderEvent) {
      yield SuccessSetBranchAddressOrderState();
    }

    if (event is AddDateNewOrderEvent) {
      yield SuccessAddedDateOrderState();
    }

    if (event is SetPaymentNewOrderEvent) {
      yield SuccessPaymentSelectedOrderState();
    }

    if (event is SetReceiverAddressNewOrderEvent) {
      yield SuccessReceiverAddressOrderState();
    }

    if (event is ChangeSendReceiveNewOrderEvent) {
      isPickup = !isPickup;
      yield ChangedSendReceiveNewOrderState();
    }

    if (event is NewOrderChangeEvent) {
      yield SuccessStepForwardNewOrderState();
    }

    if (event is NewOrderChangeBackwardEvent) {
      yield SuccessStepBackwardNewOrderState();
    }

    if (event is AddPackageNewOrderEvent) {
      yield SuccessAddedPackageNewOrderState();
    }

    if (event is RemovePackageNewOrderEvent) {
      yield SuccessRemovedNewOrderState();
    }

    if (event is FetchNewOrderEvent) {
      errorOccurred = false;
      yield LoadingNewOrderState();
     // try {
     //     location =  await Geolocator.getCurrentPosition();
     //  latLng = LatLng(location.latitude, location.longitude);
     //  } catch (e) {
     //  latLng = LatLng(40.7128, 74.0060);
     //  }

      final List<Either<String, List<dynamic>>> responses = await Future.wait([
        _repository.getShipmentSettings(),
        _repository.getDeliveryTimes(),
        _repository.getAddresses(),
        _repository.getBranches(),
        _repository.getPackages(),
        _repository.getPaymentTypes(),
        _repository.getReceivers(),
        _repository.getReceiversAddresses(),
      ]);

      final Either<String, List<ShipmentSettingsModel>> getShipmentSettings = responses[0].map((r) => r.cast() );
      yield* getShipmentSettings.fold((l) async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r) async* {
        settings = r;
      });

      final Either<String, List<DeliveryTimeModel>> getDeliveryTimes = responses[1].map((r) => r.cast() );
      yield* getDeliveryTimes.fold((l) async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r) async* {
        deliveryTimes = r;
      });

      final Either<String, List<AddressResponseModel>> getAddresses = responses[2].map((r) => r.cast() );
      yield* getAddresses.fold((l) async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r) async* {
        addresses = r;
      });

      final Either<String, List<UserModel>> getBranches = responses[3].map((r) => r.cast() );
      yield* getBranches.fold((l) async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r) async* {
        branches = r;
      });

      final Either<String, List<PackageModel>> getPackages = responses[4].map((r) => r.cast() );
      yield* getPackages.fold((l) async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r) async* {
        packages = r;
      });

      final Either<String, List<PaymentMethodModel>> getPaymentMethods = responses[5].map((r) => r.cast() );
      yield* getPaymentMethods.fold((l) async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r) async* {
        paymentMethods = r;
      });

      final Either<String, List<ReceiverModel>> getReceivers = responses[6].map((r) => r.cast() );
      yield* getReceivers.fold((l) async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r) async* {
        receivers = r;
      });

      final Either<String, List<AddressResponseModel>> getReceiversAddresses = responses[7].map((r) => r.cast() );
      yield* getReceiversAddresses.fold((l) async* {
        errorOccurred = true;
        yield ErrorNewOrderState(l);
      }, (r) async* {
        receiverAddresses = r;
      });

      if(dateTime==null){
        dateTime = DateTime.now().add(Duration(days: int.parse(settings?.firstWhereOrNull((element) => element.key ==SettingsNewOrder.is_date_required)?.value??'0')));
      }

      if(selectedBranch ==null && branches != []){
        selectedBranch = branches.firstWhereOrNull((element) {

          return element.id == (settings?.firstWhereOrNull((element) => element.key ==SettingsNewOrder.def_branch)?.value??'0');
        },);
      }

      if(paymentMethodModel ==null && paymentMethods != []){
        paymentMethodModel = paymentMethods.firstWhereOrNull((element) {
          return element.id == (settings?.firstWhereOrNull((element) => element.key ==SettingsNewOrder.def_payment_method)?.value??'0');
        },
        );
      }

      if(paymentType ==null ){
        paymentType = int.tryParse(settings.firstWhereOrNull((element) => element.key ==SettingsNewOrder.def_payment_type)?.value??'');
      }

      if(defaultPackage ==null && packages != []){
        defaultPackage = packages.firstWhereOrNull((element) => element.id == (settings?.firstWhereOrNull((element) => element.key ==SettingsNewOrder.def_package_type)?.value??'0') );
      }

      print('addresses');
      print(paymentMethods);
      print(addresses);
      print(settings.length);
      print(receivers);
      if(packageWidgets.length ==0){
        packageWidgets.add(
                AddressOrderModel(
                  weightUnit: AppKeys.weights.first,
                  heightUnit: AppKeys.heights.first,
                  widthUnit: AppKeys.heights.first,
                  packageModel: defaultPackage,
                  lengthUnit: AppKeys.heights.first,
                  quantity: 1.toString(),
                  weight: 1.toString(),
                  height: 1.toString(),
                  width: 1.toString(),
                  length: 1.toString(), description: '',
                ));
      }
      yield SuccessNewOrderState();
    }
  }

String getDayPeriodString(DayPeriod dayPeriod) {
    if (dayPeriod == DayPeriod.pm) {
      return "PM";
    }else{
      return "AM";

    }
  }
}
