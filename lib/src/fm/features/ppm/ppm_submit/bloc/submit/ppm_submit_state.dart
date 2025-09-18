

import 'package:cmms/src/features/pendingresponsedetails/model/SubmitResponseModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../cm_submit/model/submit_response_model.dart';




@immutable
sealed class  PPMSubmitState {}

class PPMSubmitInitial extends PPMSubmitState {}


class PPMSubmitInProgress extends PPMSubmitState {}



class PPMSubmitSuccess extends PPMSubmitState {
  PPMSubmitSuccess(this.submitResponseModel);
  final SubmitResponseModel submitResponseModel;
}

class PPMSubmitFailure extends PPMSubmitState {
  final String error;
  PPMSubmitFailure(this.error);
}