
import 'package:flutter/cupertino.dart';

@immutable
sealed class CMMaterialEvent {}

class CMMaterialFetchEvent extends CMMaterialEvent{
  String cmID;
  CMMaterialFetchEvent(this.cmID);
}


