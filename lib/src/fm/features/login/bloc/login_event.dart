
import 'package:flutter/cupertino.dart';

import '../model/login_model.dart';



@immutable
sealed class LoginEvent {}

class LoginFetchEvent extends LoginEvent{

  LoginFetchEvent();
}

class LoginClickEvent extends LoginEvent {
  LoginClickEvent(this.loginData);
  LoginInputFM loginData = LoginInputFM();
}


