

import '../model/complaint_reg_response_model.dart';

sealed class ComplaintRegisterEvent {}

class ComplaintRegisterFetchEvent extends ComplaintRegisterEvent{
  ComplaintRegisterFetchEvent();
}


class ComplaintRegisterSubmitEvent extends ComplaintRegisterEvent{
  ComplaintRegisterSubmitEvent(this.complaintSubmitInput);
  ComplaintSubmitInput complaintSubmitInput = ComplaintSubmitInput();
}
