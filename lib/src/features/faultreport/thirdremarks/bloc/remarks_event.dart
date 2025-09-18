

import 'package:flutter/cupertino.dart';

@immutable
sealed class RemarksEvent {}


class RemarkLoadEvent extends RemarksEvent {
  RemarkLoadEvent();

}


class NextClickEvent extends RemarksEvent {
  NextClickEvent();

}