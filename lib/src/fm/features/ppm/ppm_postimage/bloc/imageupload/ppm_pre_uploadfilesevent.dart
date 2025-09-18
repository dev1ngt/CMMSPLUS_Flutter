import 'dart:io';
sealed class PPMPostUploadFilesEvent {}


class PPMPostUploadInProgressEvent extends PPMPostUploadFilesEvent{}

class PPMPostUploadFileInProgressEvent extends PPMPostUploadFilesEvent{
  late final File file ;
  String work_id = "";
  String type = "";
  PPMPostUploadFileInProgressEvent(this.file , this.work_id , this.type);
 }

