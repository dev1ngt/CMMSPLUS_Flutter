

import 'package:cmms/src/features/pendingresponsedetails/model/SubmitResponseModel.dart';
import 'package:flutter/cupertino.dart';

import '../../../cm_submit/model/submit_response_model.dart';
import '../model/complaint_reg_response_model.dart';

@immutable
sealed class ComplaintRegisterState {
}
/* Customer Data Load */
class ComplaintRegisterInitial extends ComplaintRegisterState {
}

class ComplaintRegisterInProgress extends ComplaintRegisterState {
}

class ComplaintRegisterLoaded extends ComplaintRegisterState{
  ComplaintRegisterLoaded(this.complaintreg);
  final ComplainerData complaintreg;
}

class ComplaintRegisterError extends ComplaintRegisterState{
  ComplaintRegisterError(this.error);
  final String error;
}



class ComplaintRegisterSubmitInProgress extends ComplaintRegisterState {
}

class ComplaintRegisterSubmitLoaded extends ComplaintRegisterState{
  ComplaintRegisterSubmitLoaded(this.complaintreg);
  final SubmitResponseModel complaintreg;
}

class ComplaintRegisterSubmitError extends ComplaintRegisterState{
  ComplaintRegisterSubmitError(this.error);
  final String error;
}
