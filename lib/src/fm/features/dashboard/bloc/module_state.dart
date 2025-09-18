

import 'package:flutter/cupertino.dart';

import '../model/model_response.dart';





@immutable
sealed class ModuleState {}

final class ModuleInitial extends ModuleState {}

class ModuleLoading extends ModuleState{}

class ModuleSuccessState extends ModuleState {
  ModuleSuccessState(this.moduleResponse);
  ModuleResponse moduleResponse;
}

class ModuleFailureState extends ModuleState {
  ModuleFailureState(this.loginError);
  String loginError = '';
}



