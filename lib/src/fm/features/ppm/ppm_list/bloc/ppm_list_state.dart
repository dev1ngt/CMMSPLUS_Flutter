

import 'package:flutter/cupertino.dart';

import '../../../cm/model/cm_model_response.dart';
import '../model/ppm_list_response_model.dart';


@immutable
sealed class PPMListState {}

final class PPMListInitial extends PPMListState {}

class PPMListLoading extends PPMListState{}

class PPMListSuccessState extends PPMListState {
  PPMListSuccessState(this.taskModel);
  PPMList taskModel;
}

class PPMListFailureState extends PPMListState {
  PPMListFailureState(this.loginError);
  String loginError = '';
}



