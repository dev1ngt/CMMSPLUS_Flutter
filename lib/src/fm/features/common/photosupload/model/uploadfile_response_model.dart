class UploadFileResponseFMModel {
  final String status;
  final String message;
  final List<UploadedImageData> data;

  UploadFileResponseFMModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UploadFileResponseFMModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<UploadedImageData> imageDataList =
    dataList.map((e) => UploadedImageData.fromJson(e)).toList();

    return UploadFileResponseFMModel(
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

class UploadedImageData {
  final String imageBeforePath;
  int taskId;

  UploadedImageData({
    required this.imageBeforePath,
    required this.taskId,
  });

  factory UploadedImageData.fromJson(Map<String, dynamic> json) {
    return UploadedImageData(
      imageBeforePath: json['imageBeforePath'],
      taskId: json['taskId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageBeforePath': imageBeforePath,
      'taskId': taskId,
    };
  }
}