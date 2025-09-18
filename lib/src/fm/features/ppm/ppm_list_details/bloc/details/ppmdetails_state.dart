

import 'package:cmms/src/features/ppm/view/model/ppm_details_response_model.dart';
import 'package:flutter/cupertino.dart';

import '../../model/ppmdetails_response_model.dart';


@immutable
sealed class PPMDetailsState {}

final class PPMDetailsInitial extends PPMDetailsState {}

class PPMDetailsLoading extends PPMDetailsState{}

class PPMDetailsSuccessState extends PPMDetailsState {
  PPMDetailsSuccessState(this.moduleResponse);
  PPMDetailsResponseModelOne moduleResponse;
}

class PPMDetailsFailureState extends PPMDetailsState {
  PPMDetailsFailureState(this.loginError);
  String loginError = '';
}



