

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../model/image_upload/ppm_uploadfile_response_model.dart';



@immutable
sealed class PPMUploadFilesState {}


class PPMUploadFilesInitial extends PPMUploadFilesState {}


class PPMUploadInProgress extends PPMUploadFilesState {}



class PPMUploadFilesSuccess extends PPMUploadFilesState {
  PPMUploadFilesSuccess(this.fileuploadresponse);
  final PPMUploadFileResponseModel fileuploadresponse;
}

class PPMUploadFilesFailure extends PPMUploadFilesState {
  final String error;
  PPMUploadFilesFailure(this.error);
}

