
import '../model/fault_report_save_model.dart';
import 'dart:io';

import '../model/fault_report_save_model_old.dart';
import '../model/priority_request_model.dart';

sealed class FRSubmitEvent {}

class FRSubmitFetchEvent extends FRSubmitEvent {
  FRSubmitFetchEvent();
}

class FRSubmitClick extends FRSubmitEvent {
  FRSubmitClick(this.submitResponse);

  FaultReportSaveModel submitResponse = FaultReportSaveModel();
}

class FRSubmitClick1 extends FRSubmitEvent {
  FRSubmitClick1(this.submitResponse);

  FaultReportOldSaveModel submitResponse = FaultReportOldSaveModel();
}

class uploadFileInProgressEvent extends FRSubmitEvent {
  late final File file;
  String FileName = "";
  uploadFileInProgressEvent(this.file, this.FileName);
}

class FRPriorityEvent extends FRSubmitEvent {
  PriorityRequestModel priorityRequestModel;
  String requestId;
  FRPriorityEvent(this.priorityRequestModel, this.requestId);
}
