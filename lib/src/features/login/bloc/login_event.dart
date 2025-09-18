
import 'package:flutter/cupertino.dart';

import '../model/login_model.dart';

@immutable
sealed class LoginEvent {}

class LoginFetchEvent extends LoginEvent{

  LoginFetchEvent();
}

class LoginClickEvent extends LoginEvent {
  LoginClickEvent(this.loginData);
  LoginInput loginData = LoginInput();
}

class ForgotPasswordClickEvent extends LoginEvent {
  final String email;
  ForgotPasswordClickEvent({
    required this.email,
  });
}
