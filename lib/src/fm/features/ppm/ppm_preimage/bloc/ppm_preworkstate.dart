
import 'package:flutter/cupertino.dart';

import '../../../cm_beforeimage/model/image_delete/preimage_deleteresponse_model.dart';



@immutable
sealed class PPMPreWorkState {}

class PPMPreWorkInitial extends PPMPreWorkState {}

class PPMPreWorkInProgress extends PPMPreWorkState {}

class PPMPreWorkSuccess extends PPMPreWorkState {
  PPMPreWorkSuccess(this.fileuploadresponse);
  final RemovalResponse fileuploadresponse;
}

class PPMPreWorkFailure extends PPMPreWorkState {
  final String error;
  PPMPreWorkFailure(this.error);
}