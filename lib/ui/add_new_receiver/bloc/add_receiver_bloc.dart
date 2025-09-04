import 'package:cargo/models/receiver_model.dart';
import 'package:cargo/ui/add_new_receiver/bloc/add_receiver_events.dart';
import 'package:cargo/ui/add_new_receiver/bloc/add_receiver_states.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddReceiverBloc extends Bloc<AddReceiverEvents, AddReceiverStates> {
  final Repository _repository;
  Position? location;
  LatLng? latLng;
  int currentIndex = 0;

  String? receiverName ;
  String? receiverEmail ;
  String? receiverMobile ;

  AddReceiverBloc(this._repository) : super(InitialAddReceiverState());

  static AddReceiverBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<AddReceiverStates> mapEventToState(AddReceiverEvents event) async*
  {
    if (event is NextAddReceiverEvent) {
      yield SuccessNextAddReceiverState();
    }

    if (event is SubmitAddReceiverEvent) {
      yield LoadingAddReceiverState();
      final registerResponse =await _repository.saveNewReceiver(receiverModel: ReceiverModel(
        receiver_name: receiverName??'',
        receiver_email: receiverEmail??'',
        receiver_mobile: receiverMobile??'',
      ),
      );

      yield* registerResponse.fold((l)async* {
        yield ErrorAddReceiverState(l,false);
      }, (r) async*{
        print('dadadad');
        print(r);
        yield SuccessAddReceiverState();
        });
    }

  }


}
