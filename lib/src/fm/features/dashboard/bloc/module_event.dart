
import 'package:flutter/cupertino.dart';





@immutable
sealed class ModuleEvent {}

class ModuleFetchEvent extends ModuleEvent{
  ModuleFetchEvent();
}
class ModuleCountEvent extends ModuleEvent {
  ModuleCountEvent();
}


