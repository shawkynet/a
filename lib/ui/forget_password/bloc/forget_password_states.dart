import 'package:flutter/foundation.dart';

@immutable
abstract class ForgetPasswordStates {
  const ForgetPasswordStates();
}

class InitialForgetPasswordState extends ForgetPasswordStates {}

class LoadingForgetPasswordState extends ForgetPasswordStates {}

class SuccessForgetPasswordState extends ForgetPasswordStates {
  final String message;

  SuccessForgetPasswordState(this.message);

}

class ErrorForgetPasswordState extends ForgetPasswordStates {
  final String error;

  ErrorForgetPasswordState(this.error);
}