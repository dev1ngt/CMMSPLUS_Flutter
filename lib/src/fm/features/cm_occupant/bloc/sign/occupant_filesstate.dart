

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../model/cm_occupant_sign_response_model.dart';



@immutable
sealed class OccupantSignFilesState {}

class OccupantSignFilesInitial extends OccupantSignFilesState {}


class OccupantSignInProgress extends OccupantSignFilesState {}



class OccupantSignFilesSuccess extends OccupantSignFilesState {
  OccupantSignFilesSuccess(this.fileuploadresponse);
  final OccupantSignResponseModel fileuploadresponse;
}

class OccupantSignFilesFailure extends OccupantSignFilesState {
  final String error;
  OccupantSignFilesFailure(this.error);
}