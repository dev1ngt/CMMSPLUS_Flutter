import 'package:flutter/cupertino.dart';

import '../model/inprogress_response_model.dart';
import '../model/inprogress_submit_request_model.dart';
import '../model/inprogress_submit_response.dart';
@immutable
sealed class InProgressViewState {}

class InProgressViewInitial extends InProgressViewState {

}

class InProgressViewInfo extends InProgressViewState {

}

class InProgressViewSuccess extends InProgressViewState{
  InProgressViewSuccess(this.inprogressResponseModel);
  final InprogressResponseModel inprogressResponseModel;
}


class InProgressViewFailure extends InProgressViewState{
  final String error;
  InProgressViewFailure(this.error);
}


class InProgressSubmitLoad extends InProgressViewState {
}

class InProgressSubmitSuccess extends InProgressViewState{
  InProgressSubmitSuccess(this.submitResponseModel);
  final InprogressSubmitResponseModel submitResponseModel;
}

class InProgressSubmitFailure extends InProgressViewState{
  final String error;
  InProgressSubmitFailure(this.error);
}