

import 'package:flutter/cupertino.dart';

import '../../model/ppm_starttime_response_model.dart';


@immutable
sealed class PPMStartTimeState {}

final class PPMStartTimeInitial extends PPMStartTimeState {}

class PPMStartTimeLoading extends PPMStartTimeState{}

class PPMStartTimeSuccessState extends PPMStartTimeState {
  PPMStartTimeSuccessState(this.moduleResponse);
  PPMStartTimeResponseModel moduleResponse;
}

class PPMStartTimeFailureState extends PPMStartTimeState {
  PPMStartTimeFailureState(this.error);
  String error = '';
}



