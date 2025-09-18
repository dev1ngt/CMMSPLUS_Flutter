class PriorityRequestModel {
  final int? typeId;
  final int? subTypeId;
  final int? propertyId;

  PriorityRequestModel({
    required this.typeId,
    required this.subTypeId,
    required this.propertyId,
  });

  factory PriorityRequestModel.fromJson(Map<String, dynamic> json) {
    return PriorityRequestModel(
      typeId: json['type_id'] as int,
      subTypeId: json['sub_type_id'] as int,
      propertyId: json['property_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type_id': typeId,
      'sub_type_id': subTypeId,
      'property_id': propertyId,
    };
  }
}
