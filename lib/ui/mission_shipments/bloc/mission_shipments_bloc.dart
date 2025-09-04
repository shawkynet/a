import 'package:cargo/models/payment_method_model.dart';
import 'package:cargo/models/shipment_model.dart';
import 'package:cargo/ui/mission_shipments/bloc/mission_shipments_events.dart';
import 'package:cargo/ui/mission_shipments/bloc/mission_shipments_states.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MissionShipmentsBloc extends Bloc<MissionShipmentsEvents, MissionShipmentsStates> {
  final Repository _repository;
  List<ShipmentModel> shipments=[];
  List<ShipmentModel> checkedShipments=[];
  List<PaymentMethodModel> paymentTypes= [];

  MissionShipmentsBloc(this._repository) : super(InitialMissionShipmentsState());

  static MissionShipmentsBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<MissionShipmentsStates> mapEventToState(MissionShipmentsEvents event) async*
  {
    if(event is CheckedShipmentMissionShipmentsEvent){
      yield ShipmentCheckedMissionShipmentsState();
    }

    if (event is FetchMissionShipmentsEvent) {
      yield LoadingMissionShipmentsState();

      final getPaymentTypes = await  _repository.getPaymentTypes();
      yield* getPaymentTypes.fold((l)async* {
        yield ErrorMissionShipmentsState(l);
      }, (r)async *{
        paymentTypes = r;
      });

      final f =await  _repository.getMissionShipments(id: event.missionID);
      yield* f.fold((l) async*{
        yield ErrorMissionShipmentsState(l);
      }, (r) async*{
        shipments = r;
        print('rrrr.length');
        print(paymentTypes);
        print(shipments.length);
        yield SuccessMissionShipmentsState();
      });
      yield SuccessMissionShipmentsState();
    }

  }


}
