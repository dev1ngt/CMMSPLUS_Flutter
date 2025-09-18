

import 'package:flutter/cupertino.dart';

import '../../forgotpassword/model/forgot_response_model.dart';
import '../model/login_model.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoading extends LoginState{}

class LoginSuccessState extends LoginState {
  LoginSuccessState(this.loginResponse);
  LoginResponseModel loginResponse = LoginResponseModel();
}

class LoginFailureState extends LoginState {
  LoginFailureState(this.loginError);
  String loginError = '';
}

class BlocButtonClickedState extends LoginState {
  final BuildContext tempContext;
  BlocButtonClickedState(this.tempContext);
}


class ForgotPassInitialState extends LoginState {

}

class ForgotPassLoadedState extends LoginState {
  ForgotPassLoadedState(this.forgotResponseModel);
  final ForgotResponseModel forgotResponseModel;

}

class ForgotPassErrorState extends LoginState {
  ForgotPassErrorState(this.error);
  final String error;

}
