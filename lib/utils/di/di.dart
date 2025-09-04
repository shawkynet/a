import 'dart:convert';

import 'package:cargo/ui/add_new_address/bloc/add_address_bloc.dart';
import 'package:cargo/ui/add_new_receiver/bloc/add_receiver_bloc.dart';
import 'package:cargo/ui/add_new_receiver_address/bloc/add_receiver_address_bloc.dart';
import 'package:cargo/ui/config_loader/bloc/config_loader_bloc.dart';
import 'package:cargo/ui/create_mission/bloc/create_mission_bloc.dart';
import 'package:cargo/ui/forget_password/bloc/forget_password_bloc.dart';
import 'package:cargo/ui/home/bloc/home_bloc.dart';
import 'package:cargo/ui/home/screens/notification/bloc/notification_bloc.dart';
import 'package:cargo/ui/login/bloc/login_bloc.dart';
import 'package:cargo/ui/mission_shipments/bloc/mission_shipments_bloc.dart';
import 'package:cargo/ui/new_order/new_order_bloc/new_order_bloc.dart';
import 'package:cargo/ui/register/bloc/register_bloc.dart';
import 'package:cargo/ui/search/bloc/search_bloc.dart';
import 'package:cargo/ui/shipment_details/bloc/shipment_details_bloc.dart';
import 'package:cargo/ui/splash/bloc/splash_bloc.dart';
import 'package:cargo/utils/cache/cache_helper.dart';
import 'package:cargo/utils/config/config.dart';
import 'package:cargo/utils/global/global_bloc.dart';
import 'package:cargo/utils/network/remote/api_helper.dart';
import 'package:cargo/utils/network/remote/dio_helper.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:cargo/utils/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final di = GetIt.I..allowReassignment = true;

Future init() async {

    final sp = await SharedPreferences.getInstance();
    di.registerSingleton<CacheHelper>(CacheHelper(sp));
    Config sc = await Config.init(await rootBundle.loadString('assets/config.json'));
    di.registerSingleton<Config>(sc);

    di.registerLazySingleton<ApiHelper>(
                () => ApiImpl(),
    );
    di.registerLazySingleton<DioHelper>(
                () => DioImpl(),
    );

    di.registerLazySingleton<Repository>(
                () => RepoImpl(
            apiHelper: di<ApiHelper>(),
            dioHelper: di<DioHelper>(),
            cacheHelper: di<CacheHelper>(),
        ),
    );

    var theme = ThemeMode.light;
    if (sp.containsKey('dark')) theme = (jsonDecode(sp.getString('dark')??'false') as bool) ? ThemeMode.dark : ThemeMode.light;

    di.registerFactory<SplashBloc>(() => SplashBloc(di<Repository>()));
    di.registerFactory<LoginBloc>(() => LoginBloc(di<Repository>()));
    di.registerFactory<RegisterBloc>(() => RegisterBloc(di<Repository>()));
    di.registerFactory<ConfigLoaderBloc>(() => ConfigLoaderBloc(di<Repository>()));
    di.registerFactory<ThemeBloc>(() => ThemeBloc());
    di.registerFactory<HomeBloc>(() => HomeBloc(di<Repository>()));
    di.registerFactory<NotificationBloc>(() => NotificationBloc(di<Repository>()));
    di.registerFactory<GlobalBloc>(() => GlobalBloc(di<Repository>()));
    di.registerFactory<NewOrderBloc>(() => NewOrderBloc(di<Repository>()));
    di.registerFactory<AddAddressBloc>(() => AddAddressBloc(di<Repository>()));
    di.registerFactory<AddReceiverBloc>(() => AddReceiverBloc(di<Repository>()));
    di.registerFactory<SearchBloc>(() => SearchBloc(di<Repository>()));
    di.registerFactory<CreateMissionBloc>(() => CreateMissionBloc(di<Repository>()));
    di.registerFactory<MissionShipmentsBloc>(() => MissionShipmentsBloc(di<Repository>()));
    di.registerFactory<ShipmentDetailsBloc>(() => ShipmentDetailsBloc(di<Repository>()));
    di.registerFactory<AddReceiverAddressBloc>(() => AddReceiverAddressBloc(di<Repository>()));
    di.registerFactory<ForgetPasswordBloc>(() => ForgetPasswordBloc(di<Repository>()));
}
