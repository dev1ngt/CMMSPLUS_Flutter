
import 'package:flutter/cupertino.dart';





@immutable
sealed class StartTimeEvent {}

class StartTimeFetchEvent extends StartTimeEvent{
  String startTime , CMID;
  StartTimeFetchEvent(this.startTime ,this.CMID);
}


