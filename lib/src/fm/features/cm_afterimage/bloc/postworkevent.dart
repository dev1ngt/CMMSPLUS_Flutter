import 'dart:io';
sealed class PostWorkEvent {}
class PostWorkLoadEvent extends PostWorkEvent{}

class PostWorkInProgressEvent extends PostWorkEvent{
  int  taskid ;
  PostWorkInProgressEvent(this.taskid);
 }