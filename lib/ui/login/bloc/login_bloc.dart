import 'package:cargo/ui/login/bloc/login_events.dart';
import 'package:cargo/ui/login/bloc/login_states.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  final Repository _repository;
  bool showPassword =false;


  LoginBloc(this._repository) : super(InitialLoginState());

  static LoginBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<LoginStates> mapEventToState(LoginEvents event) async*
  {
    if (event is FetchLoginEvent) {
      yield SuccessLoginState();
    }

    if (event is PasswordToggleChangedLoginEvent) {
      yield PasswordToggleChangedLoginState();
    }

    if (event is SubmitLoginEvent) {
      yield LoadingLoginState();
      final authResponse =await _repository.login(
        email: event.email,
        password: event.password,
      );

      yield* authResponse.fold((l)async* {
        print('lllllllllllllllll');
        print(l);
        yield ErrorLoginState(l);
      }, (r) async*{
        _repository.user = r;
        if(r.error != null){
          yield ErrorLoginState(r.error??'');
        }else{
          yield LoggedInSuccessfully();
        }
      });
    }
  }


}
