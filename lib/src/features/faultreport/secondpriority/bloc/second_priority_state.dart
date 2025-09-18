


import 'package:cmms/src/features/faultreport/secondpriority/model/priority_response.dart';
import 'package:flutter/cupertino.dart';

import '../../submit/model/fault_report_save_model.dart';

@immutable
sealed class FRSecondPriorityState {}

class FRSecondPriorityInitial extends FRSecondPriorityState {}


class FRSecondPriorityLoaded extends FRSecondPriorityState{
  FRSecondPriorityLoaded(this.prioritylist);
  final PrioritiesResponse prioritylist;

}

class FRSecondPriorityError extends FRSecondPriorityState{
  FRSecondPriorityError(this.error);
  final String error;
}

class FRSecondPrioritySaveDataLoaded extends FRSecondPriorityState{
  FRSecondPrioritySaveDataLoaded(this.savedata);
  final FaultReportSaveModel savedata;

}

