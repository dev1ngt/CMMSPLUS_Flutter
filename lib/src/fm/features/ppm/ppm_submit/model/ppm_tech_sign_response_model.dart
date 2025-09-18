class PPMTechSignResponseModel {
  final String status;
  final String message;
  final List<PPMDataModel> data;

  PPMTechSignResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PPMTechSignResponseModel.fromJson(Map<String, dynamic> json) {
    // Extract data from the JSON response
    List<PPMDataModel> dataList = [];
    if (json['data'] != null) {
      dataList = List<PPMDataModel>.from(
        json['data'].map((data) => PPMDataModel.fromJson(data)),
      );
    }

    return PPMTechSignResponseModel(
      status: json['status'],
      message: json['message'],
      data: dataList,
    );
  }
}

class PPMDataModel {
  final String technicianSignature;
  final int ppmImageId;

  PPMDataModel({
    required this.technicianSignature,
    required this.ppmImageId,
  });

  factory PPMDataModel.fromJson(Map<String, dynamic> json) {
    return PPMDataModel(
      technicianSignature: json['technicianSignature'],
      ppmImageId: json['ppmImageId'],
    );
  }
}