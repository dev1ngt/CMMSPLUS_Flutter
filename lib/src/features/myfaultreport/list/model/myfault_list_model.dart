class MyFaultList {
  List<RequestData1> requestList;
  bool status;
  String message;

  MyFaultList({
    required this.requestList,
    required this.status,
    required this.message,
  });

  factory MyFaultList.fromJson(Map<String, dynamic> json) {
    return MyFaultList(
      requestList: List<RequestData1>.from(
          json["my_fault_report_list"].map((x) => RequestData1.fromJson(x))),
      status: json["status"],
      message: json["message"],
    );
  }
}

class RequestData1 {
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
  String additionalSpace;
  int IsSubmitButton;
  String Attachment;

  RequestData1({
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
    required this.IsSubmitButton,
    required this.Attachment,
    required this.additionalSpace,
  });

  factory RequestData1.fromJson(Map<String, dynamic> json) {
    return RequestData1(
      id: json['Id'],
      requestId: json["RequestId"],
      requestedBy: json["RequestorName"],
      regionName: json["regionName"],
      property: json["PropertyName"],
      spaceFloor: json["SpaceFloorName"],
      type: json["Type"],
      subType: json["SubType"],
      originalMessage: json["Description"],
      status: json["StatusName"],
      IsSubmitButton: json["IsSubmitButton"],
      Attachment: json["Attachment"],
      additionalSpace: json["additional_space"],
    );
  }
}
