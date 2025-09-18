
import 'package:flutter/cupertino.dart';





@immutable
sealed class PPMCheckpointEvent {}

class PPMCheckpointFetchEvent extends PPMCheckpointEvent{
  String ppmID;
  PPMCheckpointFetchEvent(this.ppmID);
}


