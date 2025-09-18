import 'dart:io';

import '../../../cm_summary/model/cm_submit_request_model.dart';
sealed class CMSubmitEvent {}


class CMSubmitInitEvent extends CMSubmitEvent{}


class CMSubmitInProgressEvent extends CMSubmitEvent{
  CMSubmitRequestModel submitRequestModel;
  CMSubmitInProgressEvent(this.submitRequestModel );
}