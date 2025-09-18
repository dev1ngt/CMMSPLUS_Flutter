

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../model/uploadfile_after_response_model.dart';
import '../model/uploadfile_response_model.dart';

@immutable
sealed class UploadFilesState {}


class UploadFilesInitial extends UploadFilesState {}


class UploadInProgress extends UploadFilesState {}



class UploadFilesSuccess extends UploadFilesState {
  UploadFilesSuccess(this.fileuploadresponse);
  final UploadFileResponseFMModel fileuploadresponse;
}

class UploadFilesFailure extends UploadFilesState {
  final String error;
  UploadFilesFailure(this.error);
}

