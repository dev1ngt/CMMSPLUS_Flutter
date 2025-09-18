

import 'package:flutter/cupertino.dart';
import '../model/cm_model_response.dart';


@immutable
sealed class CMListState {}

final class CMListInitial extends CMListState {}

class CMListLoading extends CMListState{}

class CMListSuccessState extends CMListState {
  CMListSuccessState(this.taskModel);
  TaskModel taskModel;
}

class CMListFailureState extends CMListState {
  CMListFailureState(this.loginError);
  String loginError = '';
}



