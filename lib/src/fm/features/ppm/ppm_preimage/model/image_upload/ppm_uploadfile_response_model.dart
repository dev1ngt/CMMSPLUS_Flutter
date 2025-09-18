class PPMUploadFileResponseModel {
  final String status;
  final String message;
  final List<PPMUploadedImageData> data;

 PPMUploadFileResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PPMUploadFileResponseModel.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<PPMUploadedImageData> imageDataList =
    dataList.map((e) => PPMUploadedImageData.fromJson(e)).toList();

    return PPMUploadFileResponseModel(
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

class PPMUploadedImageData {
  final String imageBeforePath;
  int ppmImageId;

  PPMUploadedImageData({
    required this.imageBeforePath,
    required this.ppmImageId,
  });

  factory PPMUploadedImageData.fromJson(Map<String, dynamic> json) {
    return PPMUploadedImageData(
      imageBeforePath: json['imageBeforePath'],
      ppmImageId: json['ppmImageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageBeforePath': imageBeforePath,
      'ppmImageId': ppmImageId,
    };
  }
}