

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../model/tech_sign_response_model.dart';


@immutable
sealed class TechSignFileState {}

class TechSignFileInitial extends TechSignFileState {}


class TechSignFileInProgress extends TechSignFileState {}



class TechSignFileSuccess extends TechSignFileState {
  TechSignFileSuccess(this.fileuploadresponse);
  final TechSignResponseModel fileuploadresponse;
}

class TechSignFileFailure extends TechSignFileState {
  final String error;
  TechSignFileFailure(this.error);
}