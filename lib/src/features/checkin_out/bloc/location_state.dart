import '../model/latlong_response_model.dart';

abstract class LocationState {
  final double? latitude;
  final double? longitude;
  final bool? isCheckedIn;
  final bool? checkInFlag; // Flag to track check-in status

  const LocationState({
    this.latitude,
    this.longitude,
    this.isCheckedIn = false,
    this.checkInFlag = false, // Default to false (button enabled)
  });
}

class LocationInitial extends LocationState {}

class LocationInRadiusState extends LocationState {
  const LocationInRadiusState({
    double? latitude,
    double? longitude,
    bool? isCheckedIn = false,
    bool? checkInFlag = false,
  }) : super(latitude: latitude, longitude: longitude, isCheckedIn: isCheckedIn, checkInFlag: checkInFlag);
}

class LocationOutsideRadiusState extends LocationState {
  double latitude;
  double longitude;
  bool checkInFlag;

  LocationOutsideRadiusState({
    required this.latitude,
    required this.longitude,
    required this.checkInFlag,
  });
}

class LocationError extends LocationState {
  final String message;

  LocationError(this.message);

  @override
  List<Object?> get props => [message];
}

class CheckedOutState extends LocationState {}

class SlowNetworkState extends LocationState {} // New state for slow network

class FetchLatLongLoaded extends LocationState {
  FetchLatLongLoaded(this.latLongData);

  final LatlongResponseModel latLongData;
}

