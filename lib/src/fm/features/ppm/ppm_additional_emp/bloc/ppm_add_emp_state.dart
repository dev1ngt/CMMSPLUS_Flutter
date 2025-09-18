

import 'package:flutter/cupertino.dart';

import '../model/ppm_add_emp_response_model.dart';


@immutable
sealed class PPMAddEmpState {}

final class PPMAddEmpInitial extends PPMAddEmpState {}

class PPMAddEmpLoading extends PPMAddEmpState{}

class PPMAddEmpSuccessState extends PPMAddEmpState {
  PPMAddEmpSuccessState(this.moduleResponse);
  PPMAdditionalEmployeeModel moduleResponse;
}

class PPMAddEmpFailureState extends PPMAddEmpState {
  PPMAddEmpFailureState(this.loginError);
  String loginError = '';
}



