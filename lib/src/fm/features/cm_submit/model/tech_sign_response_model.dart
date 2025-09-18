class TechSignResponseModel {
  final String status;
  final String message;
  final List<DataModel> data;

  TechSignResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TechSignResponseModel.fromJson(Map<String, dynamic> json) {
    // Extract data from the JSON response
    List<DataModel> dataList = [];
    if (json['data'] != null) {
      dataList = List<DataModel>.from(
        json['data'].map((data) => DataModel.fromJson(data)),
      );
    }

    return TechSignResponseModel(
      status: json['status'],
      message: json['message'],
      data: dataList,
    );
  }
}

class DataModel {
  final String technicianSignature;
  final int taskId;

  DataModel({
    required this.technicianSignature,
    required this.taskId,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      technicianSignature: json['technicianSignature'],
      taskId: json['taskId'],
    );
  }
}