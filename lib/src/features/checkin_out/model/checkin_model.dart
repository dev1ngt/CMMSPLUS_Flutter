class CheckInModel {
  bool? status;
  String? message;
  String? error;
  List<PropertyInfo>? propertyInfo;

  CheckInModel({this.status, this.message, this.error, this.propertyInfo});

  CheckInModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    error = json['error'];
    if (json['Property_info'] != null) {
      propertyInfo = <PropertyInfo>[];
      json['Property_info'].forEach((v) {
        propertyInfo!.add(new PropertyInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['error'] = this.error;
    if (this.propertyInfo != null) {
      data['Property_info'] =
          this.propertyInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PropertyInfo {
  int? propertyId;
  String? lat;
  String? lang;
  String? radius;
  int? punchId;
  int? attendanceId;

  PropertyInfo(
      {this.propertyId,
        this.lat,
        this.lang,
        this.radius,
        this.punchId,
        this.attendanceId});

  PropertyInfo.fromJson(Map<String, dynamic> json) {
    propertyId = json['property_id'];
    lat = json['lat'];
    lang = json['lang'];
    radius = json['radius'];
    punchId = json['punch_id'];
    attendanceId = json['attendance_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['property_id'] = this.propertyId;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    data['radius'] = this.radius;
    data['punch_id'] = this.punchId;
    data['attendance_id'] = this.attendanceId;
    return data;
  }
}
