class InprogressSubmitResponseModel {
  final bool? status;
  final String? message;
  final String? error;

  InprogressSubmitResponseModel({
    this.status,
    this.message,
    this.error,
  });

  factory InprogressSubmitResponseModel.fromJson(Map<String, dynamic> json) {
    return InprogressSubmitResponseModel(
      status: json['status'],
      message: json['message'],
      error: json['error'],
    );
  }
}