

import 'package:flutter/cupertino.dart';

import '../model/login_model.dart';



@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoading extends LoginState{}

class LoginSuccessState extends LoginState {
  LoginSuccessState(this.loginResponse);
  LoginResponseModelFM loginResponse = LoginResponseModelFM();
}

class LoginFailureState extends LoginState {
  LoginFailureState(this.loginError);
  String loginError = '';
}

class BlocButtonClickedState extends LoginState {
  final BuildContext tempContext;
  BlocButtonClickedState(this.tempContext);
}


