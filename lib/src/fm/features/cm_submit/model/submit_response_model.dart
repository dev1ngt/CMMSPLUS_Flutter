class CMSubmitResponseModel {

  final String status;
  final String message;

  CMSubmitResponseModel({
    required this.status,
    required this.message,
  });

  factory CMSubmitResponseModel.fromJson(Map<String, dynamic> json) {
    return CMSubmitResponseModel(
      status: json['status'],
      message: json['message'],
    );
  }
}