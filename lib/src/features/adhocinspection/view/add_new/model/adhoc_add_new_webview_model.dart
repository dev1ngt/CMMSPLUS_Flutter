class AdhocInspectionWebViewResponseModel {
  final bool isError;
  final String message;
  final InspectionClassData inspectionClassData;

  AdhocInspectionWebViewResponseModel({
    required this.isError,
    required this.message,
    required this.inspectionClassData,
  });

  // Manual From JSON method
  factory AdhocInspectionWebViewResponseModel.fromJson(Map<String, dynamic> json) {
    return AdhocInspectionWebViewResponseModel(
      isError: json['IsError'],
      message: json['Message'],
      inspectionClassData: InspectionClassData.fromJson(json['InspectionClassData']),
    );
  }

  // Manual To JSON method
  Map<String, dynamic> toJson() {
    return {
      'IsError': isError,
      'Message': message,
      'InspectionClassData': inspectionClassData.toJson(),
    };
  }
}

class InspectionClassData {
  final String webViewUrl;

  InspectionClassData({
    required this.webViewUrl,
  });

  // Manual From JSON method
  factory InspectionClassData.fromJson(Map<String, dynamic> json) {
    return InspectionClassData(
      webViewUrl: json['web_view_url'],
    );
  }

  // Manual To JSON method
  Map<String, dynamic> toJson() {
    return {
      'web_view_url': webViewUrl,
    };
  }
}
