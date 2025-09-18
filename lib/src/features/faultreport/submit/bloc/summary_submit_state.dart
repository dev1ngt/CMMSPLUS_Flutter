

import 'package:flutter/cupertino.dart';

import '../../../pendingresponsedetails/model/UploadFileResponseModel.dart';
import '../model/fault_report_save_model.dart';
import '../model/fault_report_submit_response_model.dart';
import '../model/priority_response_model.dart';

@immutable
sealed class FRSubmitState {}

class FRSubmitInitial extends FRSubmitState {}

class FRSubmitInProgress extends FRSubmitState{
}

class FRSubmitLoaded extends FRSubmitState{
  FRSubmitLoaded(this.submitresponse_);
   FaultReportSaveResponseModel submitresponse_ = FaultReportSaveResponseModel();
}


class FRSubmitError extends FRSubmitState{
  FRSubmitError(this.error);
  final String error;
}

class UploadFilesInitial extends FRSubmitState {}

class UploadFilesSuccess extends FRSubmitState {
  UploadFilesSuccess(this.fileuploadresponse);
  final UploadFileResponseModel fileuploadresponse;
}

class UploadFilesFailure extends FRSubmitState {
  final String error;
  UploadFilesFailure(this.error);
}


class FRPriorityInProgress extends FRSubmitState {}

class FRPrioritySuccess extends FRSubmitState {
  FRPrioritySuccess(this.priorityResponseModel);
  final PriorityResponseModel priorityResponseModel;
}

class FRPriorityFailure extends FRSubmitState {
  final String error;
  FRPriorityFailure(this.error);
}