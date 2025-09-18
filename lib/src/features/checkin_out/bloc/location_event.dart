abstract class LocationEvent {}

class StartTracking extends LocationEvent {}

class StopTracking extends LocationEvent {}

class UpdateLocation extends LocationEvent {
  final double latitude;
  final double longitude;

  UpdateLocation(this.latitude, this.longitude);
}

class CheckInEvent extends LocationEvent {}

class CheckOutEvent extends LocationEvent {}

class FetchTargetLocationEvent extends LocationEvent {}
