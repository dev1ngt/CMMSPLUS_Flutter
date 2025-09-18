
sealed class LocationValidationEvent {
}


class LocationEventInit extends LocationValidationEvent{

}

class FetchLocationEvent extends LocationValidationEvent {
  final String latitude;
  final String longitude;
  final String propertyID;

  FetchLocationEvent({
    required this.latitude,
    required this.longitude,
    required this.propertyID,
  });


}