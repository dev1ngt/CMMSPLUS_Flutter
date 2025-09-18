import 'dart:io';
sealed class TechSignFileEvent {}


class TechSignFileInitEvent extends TechSignFileEvent{}


class TechSignFileInProgressEvent extends TechSignFileEvent{
  late final File file ;
  String work_id = "";
  String type = "";
  TechSignFileInProgressEvent(this.file , this.work_id , this.type);
}