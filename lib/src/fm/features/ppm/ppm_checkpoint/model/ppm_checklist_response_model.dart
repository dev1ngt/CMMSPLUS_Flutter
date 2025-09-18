class PPMChecklistModel {
  final String status;
  final String message;
  final List<PPMCheckList> ppmChecklist;
  final List<PPMCheckStatus> ppmCheckstatus;
  final int totalCount;

  PPMChecklistModel({
    required this.status,
    required this.message,
    required this.ppmChecklist,
    required this.ppmCheckstatus,
    required this.totalCount,
  });

  factory PPMChecklistModel.fromJson(Map<String, dynamic> json) {
    var list = json['ppmCheck'] as List;
    List<PPMCheckList> checkList = list.map((i) => PPMCheckList.fromJson(i)).toList();

    var list_ = json['checkstatus'] as List;
    List<PPMCheckStatus> checkList_status = list_.map((i) => PPMCheckStatus.fromJson(i)).toList();

    return PPMChecklistModel(
      status: json['status'],
      message: json['message'],
      ppmChecklist: checkList,
      ppmCheckstatus: checkList_status,
      totalCount: json['totalCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'ppmTask': ppmChecklist.map((task) => task.toJson()).toList(),
      'checkstatus': ppmCheckstatus.map((status) => status.toJson()).toList(),
      'totalcount': totalCount,
    };
  }

  static PPMChecklistModel mockData() {
    return PPMChecklistModel(
      status: "success",
      message: "Data fetched successfully",
      ppmChecklist: [
        PPMCheckList(
          ppmId: 1,
          ppmDetailID: 101,
          checkpointID: 1001,
          checkpointName: "Check temperature",
          statusName: "Done",
          statusId: "1",
          isMandatory: 1,
          remarks: "Temperature is within range",
          readingValue: "75",
        ),
        PPMCheckList(
          ppmId: 2,
          ppmDetailID: 102,
          checkpointID: 1002,
          checkpointName: "Check pressure",
          statusName: "Not Done",
          statusId: "2",
          isMandatory: 0,
          remarks: "Pressure check not completed",
          readingValue: "N/A",
        ),
        PPMCheckList(
          ppmId: 3,
          ppmDetailID: 103,
          checkpointID: 1003,
          checkpointName: "Check Oil Level",
          statusName: "Not Applicable",
          statusId: "3",
          isMandatory: 0,
          remarks: "Pressure check not completed",
          readingValue: "N/A",
        ),
      ],
      ppmCheckstatus: [
        PPMCheckStatus(
          checkStatusID: 1,
          checkStatusName: "Done",
        ),
        PPMCheckStatus(
          checkStatusID: 2,
          checkStatusName: "Not Done",
        ),
        PPMCheckStatus(
          checkStatusID: 3,
          checkStatusName: "Not Applicable",
        ),
      ],
      totalCount: 3,
    );
  }
}

class PPMCheckList {
  final int ppmId;
  final int ppmDetailID;
  final int checkpointID;
  final String checkpointName;
   String statusName;
  final String  statusId;
  final int isMandatory;
  String remarks;
  String readingValue;

  PPMCheckList({
    required this.ppmId,
    required this.ppmDetailID,
    required this.checkpointID,
    required this.checkpointName,
    required this.statusName,
    required this.statusId,
    required this.isMandatory,
    required this.remarks,
    required this.readingValue,
  });

  factory PPMCheckList.fromJson(Map<String, dynamic> json) {
    return PPMCheckList(
      ppmId: json['ppmId'],
      ppmDetailID: json['ppmDetailID'],
      checkpointID: json['checkpointID'],
      checkpointName: json['checkpointName'],
      statusName: json['statusName'],
      statusId: json['statusId'],
      isMandatory: json['isMandatory'],
      remarks: json['remarks'],
      readingValue: json['readingValue'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'ppmId': ppmId,
      'ppmDetailID': ppmDetailID,
      'checkpointID': checkpointID,
      'checkpointName': checkpointName,
      'statusName': statusName,
      'statusID': statusId,
      'isMandatory': isMandatory,
      'remarks': remarks,
      'readingValue': readingValue,
    };
  }
}

class PPMCheckStatus {
  final int checkStatusID;
  final String checkStatusName;

  PPMCheckStatus({
    required this.checkStatusID,
    required this.checkStatusName,
  });

  factory PPMCheckStatus.fromJson(Map<String, dynamic> json) {
    return PPMCheckStatus(
      checkStatusID: json['checkStatusID'],
      checkStatusName: json['checkStatusName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkStatusID': checkStatusID,
      'checkStatusName': checkStatusName,
    };
  }
}