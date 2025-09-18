import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

sealed class ClosedViewEvent {}

class ClosedViewInitEvent extends ClosedViewEvent {}

class ClosedViewLoadEvent extends ClosedViewEvent {
  final int requestID;
  ClosedViewLoadEvent(this.requestID);
  @override
  List<Object?> get props => [];
}

class uploadFileInProgressEvent extends ClosedViewEvent{
  late final File file ;
  String FileName = "";
  uploadFileInProgressEvent(this.file , this.FileName);
}
