import 'dart:io';

import 'package:cmms/src/features/request/view/model/request_list_view_model.dart';

sealed class MyFaultRequestViewEvent {}

class MyFaultRequestViewInitEvent extends MyFaultRequestViewEvent {}

class MyFaultRequestViewLoadEvent extends MyFaultRequestViewEvent {
  final int requestID;
  MyFaultRequestViewLoadEvent(this.requestID);
  @override
  List<Object?> get props => [];
}

class MyFaultRequestViewSubmitEvent extends MyFaultRequestViewEvent {
  final int userID, requestID, assigneeID, statusID;
  final String comments , additionalSpace, assetID;
  List<Multipleimage> uploadedFiles = [];
  MyFaultRequestViewSubmitEvent(this.userID, this.requestID, this.assigneeID,
      this.statusID, this.comments ,this.additionalSpace, this.uploadedFiles, this.assetID);
  @override
  List<Object?> get props => [];
}

class MyFaultUploadFileInProgressEvent extends MyFaultRequestViewEvent{
  late final File file ;
  String FileName = "";
  MyFaultUploadFileInProgressEvent(this.file , this.FileName);
}

class MyFaultDeleteUploadedFileEvent extends MyFaultRequestViewEvent {
  final int id;
  final String requestId;

  MyFaultDeleteUploadedFileEvent({required this.id, required this.requestId});
}
