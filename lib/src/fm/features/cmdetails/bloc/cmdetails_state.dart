

import 'package:flutter/cupertino.dart';

import '../model/cmdetails_response_model.dart';

@immutable
sealed class CMDetailsState {}

final class CMDetailsInitial extends CMDetailsState {}

class CMDetailsLoading extends CMDetailsState{}

class CMDetailsSuccessState extends CMDetailsState {
  CMDetailsSuccessState(this.moduleResponse);
  CMDetailsResponseModel moduleResponse;
}

class CMDetailsFailureState extends CMDetailsState {
  CMDetailsFailureState(this.loginError);
  String loginError = '';
}



