
import 'package:flutter/cupertino.dart';

@immutable
sealed class PPMListEvent {}

class PPMListFetchEvent extends PPMListEvent{
  PPMListFetchEvent();
}
class PPMListDataEvent extends PPMListEvent {
  String type;
  PPMListDataEvent(this.type);
}




