
class PPMSubmitRequestModel {
  List<TrackDatum>? trackData;
  int? subScheduleId;
  int? userId;
  int? assigneeToID;
  String? technicianSign;
  String? technicianSignDateTime;
  String? finalDocument;
  String? technicianDescription;
  String? assetId;
  String? vendor;
  String? clientSignature;
  List<Multipleimage1>? multipleImage;

  PPMSubmitRequestModel({
    this.trackData,
    this.subScheduleId,
    this.userId,
    this.technicianSign,
    this.technicianSignDateTime,
    this.finalDocument,
    this.technicianDescription,
    this.assetId,
    this.vendor,
    this.clientSignature,
    this.assigneeToID,
    this.multipleImage,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['track_data'] = this.trackData?.map((e) => e.toJson()).toList();
    data['sub_schedule_id'] = this.subScheduleId;
    data['user_id'] = this.userId;
    data['assigned_to_id'] = this.assigneeToID;
    data['technician_sign'] = this.technicianSign;
    data['technician_sign_date_time'] = this.technicianSignDateTime;
    data['final_document'] = this.finalDocument;
    data['technician_description'] = this.technicianDescription;
    data['asset_id'] = this.assetId;
    data['vendor'] = this.vendor;
    data['client_signature'] = this.clientSignature;
    data['multipleimage'] = multipleImage?.map((e) => e.toJson()).toList();
    return data;
  }
}

class TrackDatum {
  String? id;
  String? afterImage;
  String? beforeImage;

  TrackDatum({
    this.id,
    this.afterImage,
    this.beforeImage,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['after_image'] = afterImage;
    data['before_image'] = beforeImage;
    return data;
  }
}

class ScheduleHistoryData {
  String? type;
  String? updateDate;
  String? comments;
  String? status;
  String? assignedTo;
  String? updatedBy;

  ScheduleHistoryData({
    this.type,
    this.updateDate,
    this.comments,
    this.status,
    this.assignedTo,
    this.updatedBy,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['update_date'] = updateDate;
    data['comments'] = comments;
    data['status'] = status;
    data['assigned_to'] = assignedTo;
    data['updated_by'] = updatedBy;
    return data;
  }
}



class Multipleimage1 {
  int id;
  String path;
  String type;

  Multipleimage1({
    required this.id,
    required this.path,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'type': type,
    };
  }

  factory Multipleimage1.fromJson(Map<String, dynamic> json) {
    return Multipleimage1(
      id: json['id'] ?? 0,
      path: json['path'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
