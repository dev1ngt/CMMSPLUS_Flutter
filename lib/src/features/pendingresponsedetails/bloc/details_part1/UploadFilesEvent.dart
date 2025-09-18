import 'dart:io';
sealed class UploadFilesEvent {}


class UploadInProgressEvent extends UploadFilesEvent{}

class UploadFileInProgressEvent extends UploadFilesEvent{
  late final File file ;
  String FileName = "";
  UploadFileInProgressEvent(this.file , this.FileName);
 }