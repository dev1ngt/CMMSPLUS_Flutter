class SubtypeRequestModel {
  int? typeID;

  SubtypeRequestModel({this.typeID});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type_id'] = this.typeID;
    return data;
  }

  // Deserialize JSON to RoomRequestModel
  factory SubtypeRequestModel.fromJson(Map<String, dynamic> json) {
    return SubtypeRequestModel(
      typeID: json['type_id'],
    );
  }
}