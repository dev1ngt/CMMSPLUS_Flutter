class ClosedListModel {
  List<ClosedData> closedList;
  bool status;
  String message;

  ClosedListModel({
    required this.closedList,
    required this.status,
    required this.message,
  });

  factory ClosedListModel.fromJson(Map<String, dynamic> json) {
    return ClosedListModel(
      closedList: List<ClosedData>.from(json["request_list"].map((x) => ClosedData.fromJson(x))),
      status: json["status"],
      message: json["message"],
    );
  }
}

class ClosedData {
  final int id;
  String requestId;
  String requestedBy;
  String regionName;
  String property;
  String spaceFloor;
  String type;
  String subType;
  String originalMessage;
  String status;
  String priorityName;
  String mobile;
  int priorityId;
  String additionalSpace;

  ClosedData({
    required this.id,
    required this.requestId,
    required this.requestedBy,
    required this.regionName,
    required this.property,
    required this.spaceFloor,
    required this.type,
    required this.subType,
    required this.originalMessage,
    required this.status,
    required this.priorityName,
    required this.mobile,
    required this.priorityId,
    required this.additionalSpace,
  });

  factory ClosedData.fromJson(Map<String, dynamic> json) {
    return ClosedData(
      id: json['id'],
      requestId: json["request_id"],
      requestedBy: json["requested_by"],
      regionName: json["regionName"],
      property: json["property"],
      spaceFloor: json["space_floor"],
      type: json["type"],
      subType: json["sub_type"],
      originalMessage: json["original_message"],
      status: json["status"],
      priorityName: json["priority_name"],
      mobile: json["mobile"],
      priorityId: json["priority_id"],
      additionalSpace: json["additional_space"],
    );
  }
}