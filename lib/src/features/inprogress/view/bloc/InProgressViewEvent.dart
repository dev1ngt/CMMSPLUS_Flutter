import 'package:cmms/src/features/inprogress/view/model/inprogress_submit_request_model.dart';
import 'package:flutter/cupertino.dart';


sealed class InProgressViewEvent {}

class InProgressViewsInitEvent extends InProgressViewEvent{}

class InProgressViewsEvent extends InProgressViewEvent{}

class InProgressSubmitEvent extends InProgressViewEvent{

   InProgressSubmitEvent(this.inprogressSubmitRequestModel);
   InprogressSubmitRequestModel inprogressSubmitRequestModel = InprogressSubmitRequestModel();
}