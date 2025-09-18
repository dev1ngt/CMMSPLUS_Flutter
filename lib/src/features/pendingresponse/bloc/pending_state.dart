import 'package:cmms/src/features/pendingresponse/model/location_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../model/pending_model.dart';


// States mean ( UI <------ bloc )
@immutable
sealed class InProgressState {
}

class InProgressInitialState extends InProgressState {
}

class InProgressLoadedState extends InProgressState {
  InProgressLoadedState(this.pendingList);
  final PendingListResponseModel pendingList;

}

class InProgressErrorState extends InProgressState {

  InProgressErrorState(this.error);
  final String error;

}
// Location Update





