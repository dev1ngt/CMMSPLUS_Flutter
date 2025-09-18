import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../pendingresponsedetails/model/SubmitResponseModel.dart';
import '../../../pendingresponsedetails/model/UploadFileResponseModel.dart';
import '../../../request/view/model/delete_file_response_model.dart';
import '../../list/model/ppm_list_response_model.dart';
import '../model/ppm_details_response_model.dart';

@immutable
abstract class PPMDetailsStateI extends Equatable {
  @override
  List<Object?> get props => [];
}
/// Initial state when screen loads
class PPMDetailsInitialState extends PPMDetailsStateI {
  List<Object?> get props => [];
}

/// While data is being loaded
class PPMDetailsLoadingState extends PPMDetailsStateI {}

/// When PPM data is successfully loaded
class PPMDetailsLoadedState extends PPMDetailsStateI {
  final PPMDetailsResponseModel ppmViewModel; // Replace with actual model

  PPMDetailsLoadedState(this.ppmViewModel);

  @override
  List<Object?> get props => [ppmViewModel];
}

/// When there's an error loading data
class PPMDetailsErrorState extends PPMDetailsStateI {
  final String error;

  PPMDetailsErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

/// When submission is in progress
class PPMDetailsSubmitUploadInProgress extends PPMDetailsStateI {}

/// When submission is successful
class PPMDetailsSubmitUploadSuccess extends PPMDetailsStateI {
  final SubmitResponseModel submitResponseModel;

  PPMDetailsSubmitUploadSuccess(this.submitResponseModel);

  @override
  List<Object?> get props => [submitResponseModel];
}

/// When submission fails
class PPMDetailsSubmitUploadFailure extends PPMDetailsStateI {
  final String error;

  PPMDetailsSubmitUploadFailure(this.error);

  @override
  List<Object?> get props => [error];
}

/// When file upload starts
class PPMUploadFilesInitial extends PPMDetailsStateI {}

/// When file upload is successful
class PPMUploadFilesSuccess extends PPMDetailsStateI {
  PPMUploadFilesSuccess(this.fileuploadresponse);

  final UploadFileResponseModel fileuploadresponse;

  @override
  List<Object?> get props => [fileuploadresponse];
}

/// When file upload fails
class PPMUploadFilesFailure extends PPMDetailsStateI {
  final String error;

  PPMUploadFilesFailure(this.error);

  @override
  List<Object?> get props => [error];
}

/// While deleting file
class PPMDeleteFileInProgress extends PPMDetailsStateI {}

/// When file deletion is successful
class PPMDeleteFileSuccess extends PPMDetailsStateI {
  final DeleteFileResponseModel deleteFileResponseModel;

  PPMDeleteFileSuccess(this.deleteFileResponseModel);

  @override
  List<Object?> get props => [deleteFileResponseModel];
}

/// When file deletion fails
class PPMDeleteFileFailure extends PPMDetailsStateI {
  final String error;

  PPMDeleteFileFailure(this.error);

  @override
  List<Object?> get props => [error];
}


