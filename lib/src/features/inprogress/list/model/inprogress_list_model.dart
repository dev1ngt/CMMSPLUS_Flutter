
class InProgressListResponseModel {
  List<InProgressData> inprogressData;
  bool status;
  String message;

  InProgressListResponseModel({
    required this.inprogressData,
    required this.status,
    required this.message,
  });

  factory InProgressListResponseModel.fromJson(Map<String, dynamic> json) {

    List<dynamic> pendingList = json['inprogress_data'];
    List<InProgressData> parsedList = pendingList.map((e) => InProgressData.fromJson(e)).toList();

    return InProgressListResponseModel(
      inprogressData: parsedList,
      status: json['status'],
      message: json['message'],
    );


  }
}

class InProgressData {
  int id;
  int cwRequestListId;
  String caseId;
  String companyName;
  String propertyName;
  String dateOfArrival;
  String timeOfArrival;
  String status;
  int followUpAction;
  int statusId;

  InProgressData({
    required this.id,
    required this.cwRequestListId,
    required this.caseId,
    required this.companyName,
    required this.propertyName,
    required this.dateOfArrival,
    required this.timeOfArrival,
    required this.status,
    required this.followUpAction,
    required this.statusId,
  });

  factory InProgressData.fromJson(Map<String, dynamic> json) {
    return InProgressData(
      id: json['id'],
      cwRequestListId: json['cw_request_list_id'],
      caseId: json['case_id'],
      companyName: json['company_name'],
      propertyName: json['property_name'],
      dateOfArrival: json['date_of_arrival'],
      timeOfArrival: json['time_of_arrival'],
      status: json['status'],
      followUpAction: json['follow_up_action'],
      statusId: json['status_id'],
    );
  }
}