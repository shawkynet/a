import 'package:flutter/foundation.dart';

@immutable
abstract class ForgetPasswordEvents
{
  const ForgetPasswordEvents();
}

class SubmitForgetPasswordEvent extends ForgetPasswordEvents {
  final String email;
  SubmitForgetPasswordEvent({
    required  this.email,
});
}