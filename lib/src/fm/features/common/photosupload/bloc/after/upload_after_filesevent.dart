import 'dart:io';
sealed class UploadAfterFilesEvent {}


class UploadAfterInProgressEvent extends UploadAfterFilesEvent{}


class UploadAfterFileInProgressEvent extends UploadAfterFilesEvent{
  late final File file ;
  String work_id = "";
  String type = "";
  UploadAfterFileInProgressEvent(this.file , this.work_id , this.type);
}