class FaultReportSaveResponseModel {
  bool? status;
  String? message;


  FaultReportSaveResponseModel({
    this.status,
    this.message,

  });

  factory FaultReportSaveResponseModel.fromJson(Map<String, dynamic> json) {
    return FaultReportSaveResponseModel(
      status: json['status'],
      message: json['message'],

    );
  }
}
