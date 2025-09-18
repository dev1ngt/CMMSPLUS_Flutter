
import 'package:flutter/cupertino.dart';





@immutable
sealed class PPMStartTimeEvent {}

class PPMStartTimeFetchEvent extends PPMStartTimeEvent{
  String startTime , PPMID;
  PPMStartTimeFetchEvent(this.startTime ,this.PPMID);
}


