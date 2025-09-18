class AdhocInspectionSubmitModel {
  final bool isError;
  final String message;

  AdhocInspectionSubmitModel({
    required this.isError,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory AdhocInspectionSubmitModel.fromJson(Map<String, dynamic> json) {
    return AdhocInspectionSubmitModel(
      isError: json['IsError'] as bool,
      message: json['Message'] as String,
    );
  }

  // Convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'IsError': isError,
      'Message': message,
    };
  }
}
