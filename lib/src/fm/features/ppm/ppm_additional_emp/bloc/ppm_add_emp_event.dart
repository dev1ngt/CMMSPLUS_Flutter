
import 'package:flutter/cupertino.dart';





@immutable
sealed class PPMAddEmpEvent {}

class PPMAddEmpFetchEvent extends PPMAddEmpEvent{
  String ppmid;
  PPMAddEmpFetchEvent(this.ppmid);
}


