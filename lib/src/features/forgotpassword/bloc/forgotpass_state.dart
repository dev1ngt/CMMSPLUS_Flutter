
import 'package:flutter/cupertino.dart';

import '../model/forgot_response_model.dart';

@immutable
sealed class ForgotPassState {
}

class ForgotPassInitialState extends ForgotPassState {

}

class ForgotPassLoadedState extends ForgotPassState {
  ForgotPassLoadedState(this.forgotResponseModel);
  final ForgotResponseModel forgotResponseModel;

}

class ForgotPassErrorState extends ForgotPassState {
  ForgotPassErrorState(this.error);
  final String error;

}