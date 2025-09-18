

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AdhocDetailsViewEvent extends Equatable {
  const AdhocDetailsViewEvent();
}

class AdhocDetailsViewPageEvent extends AdhocDetailsViewEvent {
  final int inspectionID;
  AdhocDetailsViewPageEvent(this.inspectionID);

  @override
  List<Object?> get props  =>[];

}