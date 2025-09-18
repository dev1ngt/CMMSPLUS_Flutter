class ReportResponseModel {
  ReportResponseModel({
    required this.status,
    required this.message,
    required this.error,
    required this.report,
  });

  final bool? status;
  final String? message;
  final String? error;
  final List<Report> report;

  factory ReportResponseModel.fromJson(Map<String, dynamic> json){
    return ReportResponseModel(
      status: json["status"],
      message: json["message"],
      error: json["error"],
      report: json["report"] == null ? [] : List<Report>.from(json["report"]!.map((x) => Report.fromJson(x))),
    );
  }

}

class Report {
  Report({
    required this.date,
    required this.totalWorkingHours,
    required this.name,
    required this.dutyName,
    required this.userId,
    required this.checkIn,
    required this.checkOut,
    required this.propertyName,
    required this.regionName,
  });

  final String? date;
  final String? totalWorkingHours;
  final String? name;
  final String? dutyName;
  final int? userId;
  final String? checkIn;
  final String? checkOut;
  final String? propertyName;
  final String? regionName;

  factory Report.fromJson(Map<String, dynamic> json){
    return Report(
      date: json["date"],
      totalWorkingHours: json["total_working_hours"],
      name: json["name"],
      dutyName: json["dutyName"],
      userId: json["user_id"],
      checkIn: json["check_in"],
      checkOut: json["check_out"],
      propertyName: json["property_name"],
      regionName: json["regionName"],
    );
  }

}
