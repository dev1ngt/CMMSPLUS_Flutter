class PPMPostUploadFileResponseModel {
  final String status;
  final String message;
  final List<PPMPostUploadedImageData> data;

  PPMPostUploadFileResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PPMPostUploadFileResponseModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<PPMPostUploadedImageData> imageDataList =
    dataList.map((e) => PPMPostUploadedImageData.fromJson(e)).toList();

    return PPMPostUploadFileResponseModel(
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

class PPMPostUploadedImageData {
  final String imageAfterPath;
  int ppmImageId;

  PPMPostUploadedImageData({
    required this.imageAfterPath,
    required this.ppmImageId,
  });

  factory PPMPostUploadedImageData.fromJson(Map<String, dynamic> json) {
    return PPMPostUploadedImageData(
      imageAfterPath: json['imageAfterPath'],
      ppmImageId: json['ppmImageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageAfterPath': imageAfterPath,
      'ppmImageId': ppmImageId,
    };
  }
}