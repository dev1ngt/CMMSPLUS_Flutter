import 'dart:io';
sealed class PPMTechSignFileEvent {}


class PPMTechSignFileInitEvent extends PPMTechSignFileEvent{}


class PPMTechSignFileInProgressEvent extends PPMTechSignFileEvent{
  late final File file ;
  String work_id = "";
  String type = "";
  PPMTechSignFileInProgressEvent(this.file , this.work_id , this.type);
}


