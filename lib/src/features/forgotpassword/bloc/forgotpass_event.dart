


import 'package:flutter/cupertino.dart';

@immutable
sealed class ForgotPassEvent {}

class ForgotPassFetchEvent extends ForgotPassEvent{

  ForgotPassFetchEvent();
}

class SubmitClickEvent extends ForgotPassEvent {
  final String current_password;
  final String new_password;
  final String confirm_password;

  SubmitClickEvent({
    required this.current_password,
    required this.new_password,
    required this.confirm_password,
  });
}
