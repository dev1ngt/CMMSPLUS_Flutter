
import 'package:flutter/cupertino.dart';

import '../../../cm_afterimage/model/image_delete/preimage_deleteresponse_model.dart';
import '../../../cm_beforeimage/model/image_delete/preimage_deleteresponse_model.dart';


@immutable
sealed class PPMPostWorkState {}

class PPMPostWorkInitial extends PPMPostWorkState {}

class PPMPostWorkInProgress extends PPMPostWorkState {}

class PPMPostWorkSuccess extends PPMPostWorkState {
  PPMPostWorkSuccess(this.fileuploadresponse);
  final RemovalResponse fileuploadresponse;
}

class PPMPostWorkFailure extends PPMPostWorkState {
  final String error;
  PPMPostWorkFailure(this.error);
}