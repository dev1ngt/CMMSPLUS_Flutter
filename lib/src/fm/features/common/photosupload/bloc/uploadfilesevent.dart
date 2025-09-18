import 'dart:io';
sealed class UploadFilesEvent {}


class UploadInProgressEvent extends UploadFilesEvent{}

class UploadFileInProgressEvent extends UploadFilesEvent{
  late final File file ;
  String work_id = "";
  String type = "";
  UploadFileInProgressEvent(this.file , this.work_id , this.type);
 }

