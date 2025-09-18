import 'dart:io';

import 'package:cmms/src/features/pendingresponsedetails/model/TechnicianInitiateRequestModel.dart';

sealed class DetailsPart2Event {}

class SignFileInitEvent extends DetailsPart2Event{}

class SignFileInProgressEvent extends DetailsPart2Event{
  String FileName = "";
  File file;
  SignFileInProgressEvent(this.file , this.FileName);
}

class SubmitClickEvent extends DetailsPart2Event{
  SubmitClickEvent(this.technicianInitiateRequestModel);
  TechnicianInitiateRequestModel technicianInitiateRequestModel = TechnicianInitiateRequestModel();
}
