class UploadFileAfterResponseModel {
  final String status;
  final String message;
  final List<UploadedAfterImageData> data;

  UploadFileAfterResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UploadFileAfterResponseModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<UploadedAfterImageData> imageDataList =
    dataList.map((e) => UploadedAfterImageData.fromJson(e)).toList();

    return UploadFileAfterResponseModel(
      status: json['status'],
      message: json['message'],
      data: imageDataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class UploadedAfterImageData {
  final String imageAfterPath;
  int taskId;

  UploadedAfterImageData({
    required this.imageAfterPath,
    required this.taskId,
  });

  factory UploadedAfterImageData.fromJson(Map<String, dynamic> json) {
    return UploadedAfterImageData(
      imageAfterPath: json['imageAfterPath'],
      taskId: json['taskId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageAfterPath': imageAfterPath,
      'taskId': taskId,
    };
  }
}