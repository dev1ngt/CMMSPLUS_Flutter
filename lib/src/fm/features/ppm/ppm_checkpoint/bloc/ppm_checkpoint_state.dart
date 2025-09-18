

import 'package:cmms/src/fm/features/ppm/ppm_checkpoint/model/ppm_checklist_response_model.dart';
import 'package:flutter/cupertino.dart';


@immutable
sealed class PPMCheckpointState {}

final class PPMCheckpointInitial extends PPMCheckpointState {}

class PPMCheckpointLoading extends PPMCheckpointState{}

class PPMCheckpointSuccessState extends PPMCheckpointState {
  PPMCheckpointSuccessState(this.moduleResponse);
  PPMChecklistModel moduleResponse;
}

class PPMCheckpointFailureState extends PPMCheckpointState {
  PPMCheckpointFailureState(this.loginError);
  String loginError = '';
}



