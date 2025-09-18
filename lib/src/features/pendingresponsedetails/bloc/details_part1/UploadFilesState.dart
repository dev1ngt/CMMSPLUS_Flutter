

import 'package:cmms/src/features/pendingresponsedetails/model/UploadFileResponseModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
sealed class UploadFilesState {}


class UploadFilesInitial extends UploadFilesState {}

class UploadFilesSuccess extends UploadFilesState {
  UploadFilesSuccess(this.fileuploadresponse);
  final UploadFileResponseModel fileuploadresponse;
}

class UploadFilesFailure extends UploadFilesState {
  final String error;
  UploadFilesFailure(this.error);
}