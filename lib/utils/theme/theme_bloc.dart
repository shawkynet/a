import 'package:cargo/utils/config/config.dart';
import 'package:cargo/utils/theme/theme_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Cubit<ThemeStates> {
  ThemeMode themeMode = Config.get.themeMode;

  bool switchButton = Config.get.themeMode == ThemeMode.dark ? true : false;

  bool pushNotifications = false;

  ThemeBloc() : super(InitialThemeState()) {
    () async {
      // if (await di<CacheHelper>().has('theme')) {
      //   di<CacheHelper>().get('theme').then((value) {
      //     if (value != null) {
      //       if (value == 'system') {
      //         switchSystem = true;
      //       }else{
      //         switchSystem = false;
      //       }
      //     }
      //   });
      // }

    }();
  }

  static ThemeBloc get(BuildContext context) => BlocProvider.of(context);

}
