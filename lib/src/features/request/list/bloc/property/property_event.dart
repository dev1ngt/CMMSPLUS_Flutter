
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract  class PropertyEvent extends Equatable {
  const PropertyEvent();
}

class PropertyFetchEvent extends PropertyEvent{

  PropertyFetchEvent();
  @override
  List<Object?> get props  =>[];

}


