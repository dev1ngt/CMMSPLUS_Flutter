

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../cm_submit/model/tech_sign_response_model.dart';
import '../../model/ppm_tech_sign_response_model.dart';

@immutable
sealed class PPMTechSignFileState {}

class PPMTechSignFileInitial extends PPMTechSignFileState {}


class PPMTechSignFileInProgress extends PPMTechSignFileState {}



class PPMTechSignFileSuccess extends PPMTechSignFileState {
  PPMTechSignFileSuccess(this.fileuploadresponse);
  final PPMTechSignResponseModel fileuploadresponse;
}

class PPMTechSignFileFailure extends PPMTechSignFileState {
  final String error;
  PPMTechSignFileFailure(this.error);
}