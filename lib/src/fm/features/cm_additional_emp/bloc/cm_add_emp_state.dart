

import 'package:flutter/cupertino.dart';

import '../model/cm_add_emp_response_model.dart';


@immutable
sealed class CMAddEmpState {}

final class CMAddEmpInitial extends CMAddEmpState {}

class CMAddEmpLoading extends CMAddEmpState{}

class CMAddEmpSuccessState extends CMAddEmpState {
  CMAddEmpSuccessState(this.moduleResponse);
  CMAdditionalEmployeeModel moduleResponse;
}

class CMAddEmpFailureState extends CMAddEmpState {
  CMAddEmpFailureState(this.loginError);
  String loginError = '';
}



