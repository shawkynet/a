import 'dart:async';

import 'package:cargo/components/my_svg.dart';
import 'package:cargo/models/user/user_model.dart';
import 'package:cargo/ui/config_loader/config_loader_screen.dart';
import 'package:cargo/ui/home/home_screen.dart';
import 'package:cargo/ui/login/login_screen.dart';
import 'package:cargo/ui/onboard/onboard_screen.dart';
import 'package:cargo/ui/splash/bloc/splash_bloc.dart';
import 'package:cargo/ui/splash/bloc/splash_events.dart';
import 'package:cargo/ui/splash/bloc/splash_states.dart';
import 'package:cargo/utils/cache/cache_helper.dart';
import 'package:cargo/utils/config/config.dart';
import 'package:cargo/utils/constants/app_keys.dart';
import 'package:cargo/utils/constants/constants.dart';
import 'package:cargo/utils/di/di.dart';
import 'package:cargo/utils/global/global_bloc.dart';
import 'package:cargo/utils/global/global_states.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Config.get');
    print(Config.get);
    return BlocProvider<SplashBloc>(
      create: (BuildContext context) => di<SplashBloc>()..add(FetchSplashEvent()),
      child: BlocListener<SplashBloc, SplashStates>(
        listener: (BuildContext context, SplashStates state) async {
          if (state is ErrorSplashState) {
            showToast(state.error, false);
          }
          if (state is NavigateToConfigLoader) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ConfigLoaderScreen()));
          }
          if (state is SuccessSplashState) {
            Timer(Duration(seconds: 1), () async {
              final userData = await di<CacheHelper>().get(AppKeys.userData);
              if (userData != null ) {
                di<Repository>().user = UserModel.fromJson(userData);
                // print('userData');
                // print(di<Repository>().user);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(false)));
              } else {
                final onOnBoardOpened = await di<CacheHelper>().get(AppKeys.onOnBoardOpened);
                if (onOnBoardOpened != null &&onOnBoardOpened ) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                } else {
                  di<CacheHelper>().put(AppKeys.onOnBoardOpened,true);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => OnBoardScreen()));
                }
              }

            });
          }
        },
        child: Scaffold(
          backgroundColor:
              rgboOrHex(Config.get.styling[Config.get.themeMode]?.primary),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: MySVG(
                    svgPath: 'assets/icons/splash_background.svg',
                  )),
                  Spacer(),
                ],
              ),
              BlocBuilder<GlobalBloc, GlobalStates>(
                builder: (context, state) => Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: MySVG(
                                    size: MediaQuery.of(context).size.height * (11 / 100),
                                    imagePath: 'assets/images/logo.png',
                            fromFiles: true,
                                  ),

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
