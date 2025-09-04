import 'package:cargo/ui/config_loader/bloc/config_loader_events.dart';
import 'package:cargo/ui/config_loader/bloc/config_loader_states.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigLoaderBloc extends Bloc<ConfigLoaderEvents, ConfigLoaderStates> {
  final Repository _repository;


  ConfigLoaderBloc(this._repository) : super(InitialConfigLoaderState());

  static ConfigLoaderBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<ConfigLoaderStates> mapEventToState(ConfigLoaderEvents event) async*
  {
    if (event is FetchConfigLoaderEvent) {
      yield LoadingConfigLoaderState();
    }

    if (event is FetchedConfigLoaderEvent) {
      // final path = await di<CacheHelper>().get(AppKeys.APP_LOGO_PATH) ;
      // print('dasdsadadasdsadadasdsada');
      // print(path);
      // if(path==null){
      //   await _repository.downloadImage(url: Config.get.logo.dark);
      // }
      yield SuccessConfigLoaderState();
    }
  }


}
