class MyFaultListview {
  List<RequestData2> requestList;
  bool status;
  String message;

  MyFaultListview({
    required this.requestList,
    required this.status,
    required this.message,
  });

  factory MyFaultListview.fromJson(Map<String, dynamic> json) {
    return MyFaultListview(
      requestList: List<RequestData2>.from(
          json["my_fault_report_view"].map((x) => RequestData2.fromJson(x))),
      status: json["status"],
      message: json["message"],
    );
  }
}

class RequestData2 {
  final int id;
  String requestId;
  String requestedBy;
  String property;
  String spaceFloor;
  String type;
  String subType;
  String originalMessage;
  String status;
  String ContractorName;
  int IsSubmitButton;
  String Attachment;

  RequestData2({
    required this.id,
    required this.requestId,
    required this.requestedBy,
    required this.property,
    required this.spaceFloor,
    required this.type,
    required this.subType,
    required this.originalMessage,
    required this.status,
    required this.ContractorName,
    required this.IsSubmitButton,
    required this.Attachment,
  });

  factory RequestData2.fromJson(Map<String, dynamic> json) {
    return RequestData2(
      id: json['Id'],
      requestId: json["RequestId"],
      requestedBy: json["RequestorName"],
      property: json["PropertyName"],
      spaceFloor: json["SpaceFloorName"],
      type: json["Type"],
      subType: json["SubType"],
      originalMessage: json["Description"],
      status: json["StatusName"],
      ContractorName: json["ContractorName"],
      IsSubmitButton: json["IsSubmitButton"],
      Attachment: json["Attachment"],
    );
  }
}
