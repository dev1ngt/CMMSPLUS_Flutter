

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../cm_summary/model/cm_submit_request_model.dart';
import '../../model/submit_response_model.dart';
import '../../model/tech_sign_response_model.dart';


@immutable
sealed class CMSubmitState {}

class CMSubmitInitial extends CMSubmitState {}


class CMSubmitInProgress extends CMSubmitState {}



class CMSubmitSuccess extends CMSubmitState {
  CMSubmitSuccess(this.submitResponseModel);
  final CMSubmitResponseModel submitResponseModel;
}

class CMSubmitFailure extends CMSubmitState {
  final String error;
  CMSubmitFailure(this.error);
}