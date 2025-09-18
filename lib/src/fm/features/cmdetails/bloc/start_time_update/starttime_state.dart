

import 'package:flutter/cupertino.dart';

import '../../model/starttime_response_model.dart';


@immutable
sealed class StartTimeState {}

final class StartTimeInitial extends StartTimeState {}

class StartTimeLoading extends StartTimeState{}

class StartTimeSuccessState extends StartTimeState {
  StartTimeSuccessState(this.moduleResponse);
  StartTimeResponseModel moduleResponse;
}

class StartTimeFailureState extends StartTimeState {
  StartTimeFailureState(this.error);
  String error = '';
}



