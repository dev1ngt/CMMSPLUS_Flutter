import 'dart:io';

import 'package:cmms/src/features/request/view/model/request_list_view_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

sealed class RequestViewEvent {}

class RequestViewInitEvent extends RequestViewEvent {}

class RequestViewLoadEvent extends RequestViewEvent {
  final int requestID;
  RequestViewLoadEvent(this.requestID);
  @override
  List<Object?> get props => [];
}

class RequestViewSubmitEvent extends RequestViewEvent {
  final int userID, requestID, assigneeID, statusID;
  final String comments , additionalSpace, estimatedAmt, assetID;
  List<Multipleimage> uploadedFiles = [];
  RequestViewSubmitEvent(this.userID, this.requestID, this.assigneeID,
      this.statusID, this.comments ,this.additionalSpace, this.uploadedFiles, this.estimatedAmt, this.assetID);
  @override
  List<Object?> get props => [];
}

class uploadFileInProgressEvent extends RequestViewEvent{
  late final File file ;
  String FileName = "";
  uploadFileInProgressEvent(this.file , this.FileName);
}

class DeleteUploadedFileEvent extends RequestViewEvent {
  final int id;
  final String requestId;

  DeleteUploadedFileEvent({required this.id, required this.requestId});
}

