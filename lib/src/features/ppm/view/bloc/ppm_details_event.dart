import 'dart:io';
import 'package:equatable/equatable.dart';

import '../../list/model/ppm_list_response_model.dart';
import '../model/ppm_details_submit_request.dart';

sealed class PPMDetailsEvent extends Equatable {
  const PPMDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the page is initialized
class PPMDetailsInitEvent extends PPMDetailsEvent {
  const PPMDetailsInitEvent();
}

/// Triggered when PPM details are loaded (e.g. based on schedule ID)
class PPMDetailsLoadEvent extends PPMDetailsEvent {
  final String scheduleID;
  const PPMDetailsLoadEvent(this.scheduleID);

  @override
  List<Object?> get props => [scheduleID];
}

/// Triggered when the user submits the PPM form
class PPMDetailsSubmitEvent extends PPMDetailsEvent {
  final PPMSubmitRequestModel ppmSubmitRequestModel;

  const PPMDetailsSubmitEvent(this.ppmSubmitRequestModel);

  @override
  List<Object?> get props => [ppmSubmitRequestModel];
}

/// Triggered while a file upload is in progress
class PPMUploadFileInProgressEvent extends PPMDetailsEvent {
  final File file;
  final String fileName;

  const PPMUploadFileInProgressEvent(this.file, this.fileName);

  @override
  List<Object?> get props => [file, fileName];
}

/// Triggered to delete an uploaded file (before submission)
class PPMDeleteUploadedFileEvent extends PPMDetailsEvent {
  final int id;
  final String ppmScheduleId;

  const PPMDeleteUploadedFileEvent({
    required this.id,
    required this.ppmScheduleId,
  });

  @override
  List<Object?> get props => [id, ppmScheduleId];
}

