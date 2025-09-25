class PPMStartTimeResponseModel {
  final String status;
  final String message;
  final PPMStartTimeData? data;

  PPMStartTimeResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory PPMStartTimeResponseModel.fromJson(Map<String, dynamic> json) {
    return PPMStartTimeResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? PPMStartTimeData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class PPMStartTimeData {
  final int ppmId;
  final String technicianDateTime;
  final String parsedIso;

  PPMStartTimeData({
    required this.ppmId,
    required this.technicianDateTime,
    required this.parsedIso,
  });

  factory PPMStartTimeData.fromJson(Map<String, dynamic> json) {
    return PPMStartTimeData(
      ppmId: json['ppmId'] ?? 0,
      technicianDateTime: json['technicianDateTime'] ?? '',
      parsedIso: json['parsedIso'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ppmId': ppmId,
      'technicianDateTime': technicianDateTime,
      'parsedIso': parsedIso,
    };
  }
}
