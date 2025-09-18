import 'package:cmms/src/features/pendingresponsedetails/model/SubmitResponseModel.dart';
import 'package:cmms/src/features/request/view/model/delete_file_response_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../pendingresponsedetails/model/UploadFileResponseModel.dart';
import '../model/request_list_view_model.dart';

@immutable
abstract class RequestViewState extends Equatable {}

class RequestViewInitialState extends RequestViewState {
  @override
  List<Object?> get props => [];
}

class RequestViewLoadedState extends RequestViewState {
  final RequestViewModel requestViewModel;

  RequestViewLoadedState(this.requestViewModel);

  @override
  List<Object> get props => [requestViewModel];
}

class RequestViewErrorState extends RequestViewState {
  final String error;

  RequestViewErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class RequestViewSubmitInitialState extends RequestViewState {
  @override
  List<Object?> get props => [];
}

class RequestViewSubmitLoadedState extends RequestViewState {
  final SubmitResponseModel requestViewModel;

  RequestViewSubmitLoadedState(this.requestViewModel);

  @override
  List<Object> get props => [requestViewModel];
}

class RequestViewSubmitErrorState extends RequestViewState {
  final String error;

  RequestViewSubmitErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class UploadFilesInitial extends RequestViewState {
  @override
  List<Object?> get props => [];
}

class UploadFilesSuccess extends RequestViewState {
  UploadFilesSuccess(this.fileuploadresponse);

  final UploadFileResponseModel fileuploadresponse;

  @override
  List<Object?> get props => [fileuploadresponse];
}

class UploadFilesFailure extends RequestViewState {
  final String error;

  UploadFilesFailure(this.error);

  List<Object?> get props => [error];
}

class DeleteFileInProgress extends RequestViewState {
  @override
  List<Object?> get props => [];
}

class DeleteFileSuccess extends RequestViewState {
  DeleteFileSuccess(this.deleteFileResponseModel);

  final DeleteFileResponseModel deleteFileResponseModel;

  @override
  List<Object?> get props => [deleteFileResponseModel];
}

class DeleteFileFailure extends RequestViewState {
  final String error;

  DeleteFileFailure(this.error);

  List<Object?> get props => [error];
}
