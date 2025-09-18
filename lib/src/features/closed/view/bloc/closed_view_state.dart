import 'package:cmms/src/features/closed/view/model/closed_response_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../pendingresponsedetails/model/UploadFileResponseModel.dart';

@immutable
abstract class ClosedViewState extends Equatable {}

class ClosedViewInitialState extends ClosedViewState {
  @override
  List<Object?> get props => [];
}

class ClosedViewLoadedState extends ClosedViewState {
  final ClosedViewModelNew closedViewModel;

  ClosedViewLoadedState(this.closedViewModel);

  @override
  List<Object> get props => [closedViewModel];
}

class ClosedViewErrorState extends ClosedViewState {
  final String error;

  ClosedViewErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class UploadFilesInitial extends ClosedViewState {
  @override
  List<Object?> get props => [];
}

class UploadFilesSuccess extends ClosedViewState {
  UploadFilesSuccess(this.fileuploadresponse);

  final UploadFileResponseModel fileuploadresponse;

  @override
  List<Object?> get props => [fileuploadresponse];
}

class UploadFilesFailure extends ClosedViewState {
  final String error;

  UploadFilesFailure(this.error);

  List<Object?> get props => [error];
}
