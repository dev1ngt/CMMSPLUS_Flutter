import 'dart:io';
sealed class PreWorkEvent {}
class PreWorkLoadEvent extends PreWorkEvent{}

class PreWorkInProgressEvent extends PreWorkEvent{
  int  taskid ;
  PreWorkInProgressEvent(this.taskid);
 }