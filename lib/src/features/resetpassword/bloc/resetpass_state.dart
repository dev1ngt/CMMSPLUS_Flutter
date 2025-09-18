
import 'package:cmms/src/features/resetpassword/model/resetpass_response_model.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class ResetPassState {
}

class ResetPassInitialState extends ResetPassState {

}

class ResetPassLoadedState extends ResetPassState {
  ResetPassLoadedState(this.resetResponseModel);
  final ResetpassResponseModel resetResponseModel;

}

class ResetPassErrorState extends ResetPassState {
  ResetPassErrorState(this.error);
  final String error;

}