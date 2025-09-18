



import 'package:flutter/cupertino.dart';

import '../model/ppm_completed_response.dart';

@immutable
sealed class PPMCompletedState {}



class PPMCompletedInit extends PPMCompletedState{

}

class PPMCompletedInProgress extends PPMCompletedState{

}

class PPMCompletedSuccess extends PPMCompletedState{
  PPMCompletedSuccess(this.schedule);
  final ScheduleResponse schedule;

}

class PPMCompletedFailure extends PPMCompletedState{
  final String error;
  PPMCompletedFailure(this.error);

}