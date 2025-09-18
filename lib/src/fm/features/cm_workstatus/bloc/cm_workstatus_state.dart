

import 'package:flutter/cupertino.dart';

import '../../cm/model/cm_model_response.dart';



@immutable
sealed class CMWorkStatusState {}

final class CMWorkStatusInitial extends CMWorkStatusState {}

class CMWorkStatusLoading extends CMWorkStatusState{}

class CMWorkStatusSuccessState extends CMWorkStatusState {
  CMWorkStatusSuccessState(this.taskModel);
  TaskModel taskModel;
}

class CMWorkStatusFailureState extends CMWorkStatusState {
  CMWorkStatusFailureState(this.loginError);
  String loginError = '';
}



