import 'package:cargo/ui/forget_password/bloc/forget_password_events.dart';
import 'package:cargo/ui/forget_password/bloc/forget_password_states.dart';
import 'package:cargo/utils/network/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvents, ForgetPasswordStates> {
  final Repository _repository;
  bool showPassword =false;


  ForgetPasswordBloc(this._repository) : super(InitialForgetPasswordState());

  static ForgetPasswordBloc get(BuildContext context) => BlocProvider.of(context);

  @override
  Stream<ForgetPasswordStates> mapEventToState(ForgetPasswordEvents event) async*
  {
    if (event is SubmitForgetPasswordEvent) {
      yield LoadingForgetPasswordState();
      final forgetPasswordResponse =await _repository.forgetPassword(
        email: event.email,
      );

      yield* forgetPasswordResponse.fold((l)async* {
        print('lllllllllllllllll');
        print(l);
        yield ErrorForgetPasswordState(l);
      }, (r) async*{
        if(r.status){
          yield ErrorForgetPasswordState(r.message);
        }else{
          yield SuccessForgetPasswordState(r.message);
        }
      });
    }
  }


}
