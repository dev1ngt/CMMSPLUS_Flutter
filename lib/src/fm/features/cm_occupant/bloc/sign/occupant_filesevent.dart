import 'dart:io';
sealed class OccuapntSignFilesEvent {}


class OccuapntSignInProgressEvent extends OccuapntSignFilesEvent{}


class OccuapntSignFileInProgressEvent extends OccuapntSignFilesEvent{
  late final File file ;
  String work_id = "";
  String type = "";
  OccuapntSignFileInProgressEvent(this.file , this.work_id , this.type);
}