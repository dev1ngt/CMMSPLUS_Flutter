import 'package:cmms/src/features/myfaultreport/list/model/myfault_list_view_model.dart';
import 'package:cmms/src/features/pendingresponsedetails/model/SubmitResponseModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../pendingresponsedetails/model/UploadFileResponseModel.dart';
import '../../../request/view/model/delete_file_response_model.dart';
import '../../../request/view/model/request_list_view_model.dart';

@immutable
abstract class MyFaultRequestViewState extends Equatable {}

class MyFaultRequestViewInitialState extends MyFaultRequestViewState {
  @override
  List<Object?> get props => [];
}

class MyFaultRequestViewLoadedState extends MyFaultRequestViewState {
  final RequestViewModel requestViewModel;

  MyFaultRequestViewLoadedState(this.requestViewModel);

  @override
  List<Object> get props => [requestViewModel];
}

class MyFaultRequestViewErrorState extends MyFaultRequestViewState {
  final String error;

  MyFaultRequestViewErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class MyFaultRequestViewSubmitInitialState extends MyFaultRequestViewState {
  @override
  List<Object?> get props => [];
}

class MyFaultRequestViewSubmitLoadedState extends MyFaultRequestViewState {
  final SubmitResponseModel requestViewModel;

  MyFaultRequestViewSubmitLoadedState(this.requestViewModel);

  @override
  List<Object> get props => [requestViewModel];
}

class MyFaultRequestViewSubmitErrorState extends MyFaultRequestViewState {
  final String error;

  MyFaultRequestViewSubmitErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class MyFaultUploadFilesInitial extends MyFaultRequestViewState {
  @override
  List<Object?> get props => [];
}

class MyFaultUploadFilesSuccess extends MyFaultRequestViewState {
  MyFaultUploadFilesSuccess(this.fileuploadresponse);

  final UploadFileResponseModel fileuploadresponse;

  @override
  List<Object?> get props => [fileuploadresponse];
}

class MyFaultUploadFilesFailure extends MyFaultRequestViewState {
  final String error;

  MyFaultUploadFilesFailure(this.error);

  List<Object?> get props => [error];
}

class MyFaultDeleteFileInProgress extends MyFaultRequestViewState {
  @override
  List<Object?> get props => [];
}

class MyFaultDeleteFileSuccess extends MyFaultRequestViewState {
  MyFaultDeleteFileSuccess(this.deleteFileResponseModel);

  final DeleteFileResponseModel deleteFileResponseModel;

  @override
  List<Object?> get props => [deleteFileResponseModel];
}

class DeleteFileFailure extends MyFaultRequestViewState {
  final String error;

  DeleteFileFailure(this.error);

  List<Object?> get props => [error];
}