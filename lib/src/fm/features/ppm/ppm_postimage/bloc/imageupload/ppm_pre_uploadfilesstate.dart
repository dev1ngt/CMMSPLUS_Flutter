

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../model/image_upload/ppm_post_uploadfile_response_model.dart';



@immutable
sealed class PPMPostUploadFilesState {}


class PPMPostUploadFilesInitial extends PPMPostUploadFilesState {}


class PPMPostUploadInProgress extends PPMPostUploadFilesState {}



class PPMPostUploadFilesSuccess extends PPMPostUploadFilesState {
  PPMPostUploadFilesSuccess(this.fileuploadresponse);
  final PPMPostUploadFileResponseModel fileuploadresponse;
}

class PPMPostUploadFilesFailure extends PPMPostUploadFilesState {
  final String error;
  PPMPostUploadFilesFailure(this.error);
}

