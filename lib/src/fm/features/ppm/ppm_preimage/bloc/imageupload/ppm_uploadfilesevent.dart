import 'dart:io';
sealed class PPMUploadFilesEvent {}


class PPMUploadInProgressEvent extends PPMUploadFilesEvent{}

class PPMUploadFileInProgressEvent extends PPMUploadFilesEvent{
  late final File file ;
  String work_id = "";
  String type = "";
  PPMUploadFileInProgressEvent(this.file , this.work_id , this.type);
 }

