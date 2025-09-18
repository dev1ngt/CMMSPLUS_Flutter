
import 'package:flutter/cupertino.dart';

@immutable
sealed class CMListEvent {}

class CMListFetchEvent extends CMListEvent{
  CMListFetchEvent();
}
class CMListCountEvent extends CMListEvent {
  String type;
  CMListCountEvent(this.type);
}




