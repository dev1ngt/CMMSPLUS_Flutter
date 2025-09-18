
import 'package:flutter/cupertino.dart';


import '../model/image_delete/preimage_deleteresponse_model.dart';


@immutable
sealed class PreWorkState {}

class PreWorkInitial extends PreWorkState {}

class PreWorkInProgress extends PreWorkState {}

class PreWorkSuccess extends PreWorkState {
  PreWorkSuccess(this.fileuploadresponse);
  final RemovalResponse fileuploadresponse;
}

class PreWorkFailure extends PreWorkState {
  final String error;
  PreWorkFailure(this.error);
}