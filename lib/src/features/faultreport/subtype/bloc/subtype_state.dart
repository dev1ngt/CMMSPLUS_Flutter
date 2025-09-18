

import 'package:flutter/cupertino.dart';

import '../model/response/subtype_response_model.dart';



@immutable
sealed class SubtypeState {}

class SubtypeInitial extends SubtypeState {}


class SubtypeLoaded extends SubtypeState{
  SubtypeLoaded(this.subtypeResponseModel);
  final SubtypeResponseModel subtypeResponseModel;

}

class SubtypeError extends SubtypeState{
  SubtypeError(this.error);
  final String error;
}
