

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../model/uploadfile_after_response_model.dart';


@immutable
sealed class UploadAfterFilesState {}



class UploadAfterFilesInitial extends UploadAfterFilesState {}


class UploadAfterInProgress extends UploadAfterFilesState {}



class UploadAfterFilesSuccess extends UploadAfterFilesState {
  UploadAfterFilesSuccess(this.fileuploadresponse);
  final UploadFileAfterResponseModel fileuploadresponse;
}

class UploadAfterFilesFailure extends UploadAfterFilesState {
  final String error;
  UploadAfterFilesFailure(this.error);
}