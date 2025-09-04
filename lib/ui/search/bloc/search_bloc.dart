import 'package:cargo/models/shipment_model.dart';
import 'package:cargo/ui/search/bloc/search_events.dart';
import 'package:cargo/ui/search/bloc/search_states.dart';
import 'package:cargo/utils/constants/app_keys.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvents, SearchStates> {
  final Repository _repository;
  ShipmentModel? shipment;
  List<ShipmentLogModel> logs=[];

  SearchBloc(this._repository) : super(InitialSearchState());

  static SearchBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<SearchStates> mapEventToState(SearchEvents event) async*
  {
    if (event is NextSearchEvent) {
      yield SuccessNextSearchState();
    }

    if (event is FetchSearchEvent) {
      shipment= null ;
      if(event.code!= null && event.code!.trim().isNotEmpty){
        print('event.code');
        print(event.code);
        yield LoadingSearchState();
        final f =await  _repository.getTrackingShipments(code: event.code);
        yield* f.fold((l) async*{
          yield ErrorSearchState(l);
        }, (r) async*{
          if(r.message !=null){
            yield ErrorSearchState(r.message);
          }else{
            shipment = r;
            print('r.length');
            print(r.logs.length);
            print(r.toJson());
            logs= [
              ShipmentLogModel(
                id: '0',
                created_at: r.created_at,
                to:AppKeys.TRACKING_CLIENT_STATUS_CREATED.toString(),
                from:AppKeys.TRACKING_CLIENT_STATUS_CREATED.toString(),
                shipment_id: r.id,
                updated_at: r.updated_at,
                created_by: '',
              ),
              ...r.logs
            ];
            yield SuccessSearchState();

          }
        });

      }
    }
  }
}
