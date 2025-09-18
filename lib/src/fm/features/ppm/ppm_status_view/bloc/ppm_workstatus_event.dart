
import 'package:flutter/cupertino.dart';

@immutable
sealed class PPMWorkStatusEvent {}

class PPMWorkStatusFetchEvent extends PPMWorkStatusEvent{
  PPMWorkStatusFetchEvent();
}
class PPMWorkStatusCountEvent extends PPMWorkStatusEvent {
  String type;
  PPMWorkStatusCountEvent(this.type);
}




