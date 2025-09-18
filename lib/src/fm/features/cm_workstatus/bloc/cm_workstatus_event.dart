
import 'package:flutter/cupertino.dart';

@immutable
sealed class CMWorkStatusEvent {}

class CMWorkStatusFetchEvent extends CMWorkStatusEvent{
  CMWorkStatusFetchEvent();
}
class CMWorkStatusCountEvent extends CMWorkStatusEvent {
  String type;
  CMWorkStatusCountEvent(this.type);
}




