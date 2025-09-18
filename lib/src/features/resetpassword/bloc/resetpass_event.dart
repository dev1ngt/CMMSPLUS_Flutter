


import 'package:flutter/cupertino.dart';

@immutable
sealed class ResetPassEvent {}

class ResetPassFetchEvent extends ResetPassEvent{

  ResetPassFetchEvent();
}

class SubmitClickEvent extends ResetPassEvent {
  final String current_password;
  final String new_password;
  final String confirm_password;

  SubmitClickEvent({
    required this.current_password,
    required this.new_password,
    required this.confirm_password,
  });
}
