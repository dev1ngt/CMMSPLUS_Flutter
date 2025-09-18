class LocationResponse {
  bool status;
  List<Location> locations;

  LocationResponse({required this.status, required this.locations});

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> locationsJson = json['Location'];
    List<Location> locations =
    locationsJson.map((locationJson) => Location.fromJson(locationJson)).toList();

    return LocationResponse(
      status: json['status'],
      locations: locations,
    );
  }
}

class Location {
  int id;
  String propertyName;
  int isSelected;

  Location({required this.id, required this.propertyName, required this.isSelected});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      propertyName: json['property_name'],
      isSelected: json['is_selected'],
    );
  }
}