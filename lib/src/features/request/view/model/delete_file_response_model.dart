class DeleteFileResponseModel {
  final bool status;
  final String message;

  DeleteFileResponseModel({required this.status, required this.message});

  factory DeleteFileResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteFileResponseModel(
      status: json['status'] as bool,
      message: json['message'] as String,
    );
  }
}
