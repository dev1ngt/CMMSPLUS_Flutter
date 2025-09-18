class OccupantSignResponseModel {
  final String status;
  final String message;
  final List<OccuapntSignData> data;

  OccupantSignResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OccupantSignResponseModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<OccuapntSignData> imageDataList =
    dataList.map((e) => OccuapntSignData.fromJson(e)).toList();

    return OccupantSignResponseModel(
      status: json['status'],
      message: json['message'],
      data: imageDataList,
    );
  }
}

class OccuapntSignData {
  final String tenantSignature;
  int taskId;

  OccuapntSignData({
    required this.tenantSignature, required this.taskId
  });

  factory OccuapntSignData.fromJson(Map<String, dynamic> json) {
    return OccuapntSignData(
      tenantSignature: json['tenantSignature'],
      taskId: json['taskId'],
    );
  }
}