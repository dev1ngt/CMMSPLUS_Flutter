
class RoomRequestModel {
  int? propertyId;

  RoomRequestModel({this.propertyId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['property_id'] = this.propertyId;
    return data;
  }

  // Deserialize JSON to RoomRequestModel
  factory RoomRequestModel.fromJson(Map<String, dynamic> json) {
    return RoomRequestModel(
      propertyId: json['property_id'],
    );
  }
}