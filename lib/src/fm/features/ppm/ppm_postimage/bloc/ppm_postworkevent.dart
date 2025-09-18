import 'dart:io';
sealed class PPMPostWorkEvent {}
class PPMPostWorkLoadEvent extends PPMPostWorkEvent{}

class PPMPostWorkInProgressEvent extends PPMPostWorkEvent{
  int  taskid ;
  PPMPostWorkInProgressEvent(this.taskid);
 }