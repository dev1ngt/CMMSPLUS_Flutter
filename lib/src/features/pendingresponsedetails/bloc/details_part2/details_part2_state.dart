
import 'package:flutter/cupertino.dart';

import '../../model/SignatureUploadResponseModel.dart';
import '../../model/SubmitResponseModel.dart';

@immutable
sealed class DetailsPart2State {}

class DetailsPart2Initial extends DetailsPart2State {}

class DetailsPart2InProgress extends DetailsPart2State {}

class SignUploadSuccess extends DetailsPart2State {
  SignUploadSuccess(this.fileuploadresponse);
  final SignatureUploadResponseModel fileuploadresponse;
}

class SignUploadFailure extends DetailsPart2State {
  final String error;
  SignUploadFailure(this.error);
}

class SubmitUploadInit extends DetailsPart2State{

}

class SubmitUploadSuccess extends DetailsPart2State{
 SubmitUploadSuccess(this.submitResponseModel);
 final SubmitResponseModel submitResponseModel;

}

class SubmitUploadFailure extends DetailsPart2State{
  final String error;
  SubmitUploadFailure(this.error);

}