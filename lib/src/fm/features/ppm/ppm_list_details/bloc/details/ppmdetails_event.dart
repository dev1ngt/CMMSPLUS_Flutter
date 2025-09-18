
import 'package:flutter/cupertino.dart';





@immutable
sealed class PPMDetailsEvent {}

class PPMDetailsFetchEvent extends PPMDetailsEvent{
  String ppmID;
  PPMDetailsFetchEvent(this.ppmID);
}


