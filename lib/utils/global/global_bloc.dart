import 'package:cargo/utils/global/global_events.dart';
import 'package:cargo/utils/global/global_states.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalBloc extends Bloc<GlobalEvents, GlobalStates> {
  final Repository _repository;
  // String path = '' ;
  final connectivity = Connectivity();
  bool online = true;
  bool loading = false;
  bool popupOpened = false;


  GlobalBloc(this._repository) : super(InitialGlobalState());

  static GlobalBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<GlobalStates> mapEventToState(GlobalEvents event) async*
  {
    if (event is FetchGlobalLogoEvent) {
      // path = await di<CacheHelper>().get(AppKeys.APP_LOGO_PATH);
      yield SuccessGlobalState();
    }
    if (event is ConnectionChangedGlobalEvent) {
      yield ConnectionChangedGlobalState(event.isOnline);
    }
  }

  checkConnectivity() {
    print('bbbbbbbbbbbbbbb');

    connectivity.checkConnectivity().then((value) {
      print('dddddddddd');
      if (value == ConnectivityResult.none) {
        online = false;
      } else {
        online = true;
      }
      loading = false;
      add(ConnectionChangedGlobalEvent(online));
    });
    connectivity.onConnectivityChanged.listen((event) {
      print('dddddddddd2');
        if (event == ConnectivityResult.none) {
          online = false;
        } else {
          online = true;
        }
        loading = false;
        add(ConnectionChangedGlobalEvent(online));
      });
    }

}
