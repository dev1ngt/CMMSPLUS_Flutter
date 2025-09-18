class ResetpassResponseModel {
  final bool isError;
  final String message;

  ResetpassResponseModel({
    required this.isError,
    required this.message,
  });

  factory ResetpassResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetpassResponseModel(
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