import 'dart:io';
sealed class PPMPreWorkEvent {}
class PPMPreWorkLoadEvent extends PPMPreWorkEvent{}

class PPMPreWorkInProgressEvent extends PPMPreWorkEvent{
  int  taskid ;
  PPMPreWorkInProgressEvent(this.taskid);
 }