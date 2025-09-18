
class PropertyLocationResponseModel {
  final bool status;
  final String message;

  PropertyLocationResponseModel({
    required this.status,
    required this.message,
  });

  factory PropertyLocationResponseModel.fromJson(Map<String, dynamic> json) {
    return PropertyLocationResponseModel(
      status: json['status'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}