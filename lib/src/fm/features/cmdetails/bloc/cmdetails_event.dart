
import 'package:flutter/cupertino.dart';





@immutable
sealed class CMDetailsEvent {}

class CMDetailsFetchEvent extends CMDetailsEvent{
  String cmID;
  CMDetailsFetchEvent(this.cmID);
}


