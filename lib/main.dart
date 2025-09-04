import 'package:cargo/ui/add_new_address/bloc/add_address_bloc.dart';
import 'package:cargo/ui/add_new_receiver/bloc/add_receiver_bloc.dart';
import 'package:cargo/ui/add_new_receiver_address/bloc/add_receiver_address_bloc.dart';
import 'package:cargo/ui/config_loader/bloc/config_loader_bloc.dart';
import 'package:cargo/ui/config_loader/config_loader_screen.dart';
import 'package:cargo/ui/create_mission/bloc/create_mission_bloc.dart';
import 'package:cargo/ui/home/bloc/home_bloc.dart';
import 'package:cargo/ui/home/screens/notification/bloc/notification_bloc.dart';
import 'package:cargo/ui/login/bloc/login_bloc.dart';
import 'package:cargo/ui/mission_shipments/bloc/mission_shipments_bloc.dart';
import 'package:cargo/ui/new_order/new_order_bloc/new_order_bloc.dart';
import 'package:cargo/ui/register/bloc/register_bloc.dart';
import 'package:cargo/ui/search/bloc/search_bloc.dart';
import 'package:cargo/ui/shipment_details/bloc/shipment_details_bloc.dart';
import 'package:cargo/ui/splash/bloc/splash_bloc.dart';
import 'package:cargo/utils/constants/constant_keys.dart';
import 'package:cargo/utils/constants/local_keys.dart';
import 'package:cargo/utils/di/di.dart';
import 'package:cargo/utils/global/global_bloc.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:cargo/utils/theme/theme_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await init();

  // if(Platform.isIOS){
  //   final status = await AppTrackingTransparency.requestTrackingAuthorization();
  //   print('AppTrackingTransparency : $status');
  // }

  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale(LocalKeys.en),
          Locale(LocalKeys.ar),
        ],
        path: 'assets/langs',
        useOnlyLangCode: true,
        fallbackLocale: Locale(
          'en',
        ),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConfigLoaderBloc>(create: (BuildContext context) => ConfigLoaderBloc(di<Repository>())),
        BlocProvider<LoginBloc>(create: (BuildContext context) => LoginBloc(di<Repository>())),
        BlocProvider<RegisterBloc>(create: (BuildContext context) => RegisterBloc(di<Repository>())),
        BlocProvider<SplashBloc>(create: (BuildContext context) => SplashBloc(di<Repository>())),
        BlocProvider<ThemeBloc>(create: (BuildContext context) => di<ThemeBloc>()),
        BlocProvider<HomeBloc>(create: (BuildContext context) => di<HomeBloc>()),
        BlocProvider<GlobalBloc>(create: (BuildContext context) => di<GlobalBloc>()),
        BlocProvider<NewOrderBloc>(create: (BuildContext context) => di<NewOrderBloc>()),
        BlocProvider<NotificationBloc>(create: (BuildContext context) => di<NotificationBloc>()),
        BlocProvider<AddAddressBloc>(create: (BuildContext context) => di<AddAddressBloc>()),
        BlocProvider<AddReceiverBloc>(create: (BuildContext context) => di<AddReceiverBloc>()),
        BlocProvider<SearchBloc>(create: (BuildContext context) => di<SearchBloc>()),
        BlocProvider<CreateMissionBloc>(create: (BuildContext context) => di<CreateMissionBloc>()),
        BlocProvider<MissionShipmentsBloc>(create: (BuildContext context) => di<MissionShipmentsBloc>()),
        BlocProvider<ShipmentDetailsBloc>(create: (BuildContext context) => di<ShipmentDetailsBloc>()),
        BlocProvider<AddReceiverAddressBloc>(create: (BuildContext context) => di<AddReceiverAddressBloc>()),
      ],
      child: BlocProvider<GlobalBloc>(
        create: (context) => di<GlobalBloc>(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: EasyLocalization.of(context)?.locale,
          home: DefaultTextStyle(
            style: TextStyle(
              fontFamily: FONT_MONTSERRAT,
            ),
            child: Builder(
              builder: (context) => ConfigLoaderScreen(),
            ),
          ),
        ),
      ),
    );
  }
}
