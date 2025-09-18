

import 'package:flutter/cupertino.dart';

import '../../../cm/model/cm_model_response.dart';
import '../model/ppm_status_response_model.dart';


@immutable
sealed class PPMWorkStatusState {}

final class PPMWorkStatusInitial extends PPMWorkStatusState {}

class PPMWorkStatusLoading extends PPMWorkStatusState{}

class PPMWorkStatusSuccessState extends PPMWorkStatusState {
  PPMWorkStatusSuccessState(this.taskModel);
  PPMStatusModel taskModel;
}

class PPMWorkStatusFailureState extends PPMWorkStatusState {
  PPMWorkStatusFailureState(this.loginError);
  String loginError = '';
}



