
import 'package:flutter/cupertino.dart';





@immutable
sealed class CMAddEmpEvent {}

class CMAddEmpFetchEvent extends CMAddEmpEvent{
  String cmID;
  CMAddEmpFetchEvent(this.cmID);
}


