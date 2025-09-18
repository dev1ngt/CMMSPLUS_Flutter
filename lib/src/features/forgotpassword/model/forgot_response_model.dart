class ForgotResponseModel {
  final bool isError;
  final String message;

  ForgotResponseModel({
    required this.isError,
    required this.message,
  });

  factory ForgotResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotResponseModel(
      isError: json['IsError'],
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsError'] = this.isError;
    data['message'] = this.message;
    return data;
  }
}