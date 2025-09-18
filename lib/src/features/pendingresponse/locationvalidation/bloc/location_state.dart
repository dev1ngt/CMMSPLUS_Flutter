
import 'package:flutter/cupertino.dart';

import '../../model/location_model.dart';

@immutable
sealed class LocationValidationState {
}

class LocationInitialState extends LocationValidationState {

}

class LocationLoadedState extends LocationValidationState {
  LocationLoadedState(this.locationresponse);
  final PropertyLocationResponseModel locationresponse;

}

class LocationErrorState extends LocationValidationState {
  LocationErrorState(this.error);
  final String error;

}