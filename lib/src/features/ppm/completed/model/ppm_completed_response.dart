


class ScheduleResponse {
  ScheduleResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  final Data data;
  final bool status;
  final String message;

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) =>
      ScheduleResponse(
        data: Data.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
      );


}

class Data {
  Data({
    required this.id,
    required this.scheduleStartDateTime,
    required this.propertyName,
    required this.type,
    required this.subType,
    required this.status,
    required this.statusName,
    required this.priority,
    required this.priorityName,
    required this.assignedTo,
    required this.initiatedBy,
    required this.comments,
    required this.scheduleEndDateTime,
    required this.trackData,
    required this.technicianDescription,
    required this.technicianSign,
    required this.technicianDateTime,
    required this.finalDocument,
    required this.trackImageFilePath,
    required this.signatureFilePath,
    required this.finalDocumentFilePath,
    required this.clientSignature,
  });

  final int id;
  final String scheduleStartDateTime;
  final String propertyName;
  final String type;
  final String subType;
  final int status;
  final String statusName;
  final int priority;
  final String priorityName;
  final String assignedTo;
  final String initiatedBy;
  final String comments;
  final String scheduleEndDateTime;
  final List<TrackData> trackData;
  final String technicianDescription;
  final String technicianSign;
  final String technicianDateTime;
  final String finalDocument;
  final String trackImageFilePath;
  final String signatureFilePath;
  final String finalDocumentFilePath;
  final String clientSignature;

  factory Data.fromJson(Map<String, dynamic> json) {
    var list = json['track_data'] as List;
    List<TrackData> trackDataList = list.map((i) => TrackData.fromJson(i)).toList();

    return Data(
      id: json['id'],
      scheduleStartDateTime: json['schedule_start_date_time'],
      propertyName: json['property_name'],
      type: json['type'],
      subType: json['sub_type'],
      status: json['status'],
      statusName: json['status_name'],
      priority: json['prority'],
      priorityName: json['prority_name'],
      assignedTo: json['assigned_to'],
      initiatedBy: json['initiated_by'],
      comments: json['comments'],
      scheduleEndDateTime: json['schedule_end_date_time'],
      trackData: trackDataList,
      technicianDescription: json['technician_description'],
      technicianSign: json['technician_sign'],
      technicianDateTime: json['technician_date_time'],
      finalDocument: json['final_document'],
      trackImageFilePath: json['track_image_file_path'],
      signatureFilePath: json['signature_file_path'],
      finalDocumentFilePath: json['final_document_file_path'],
      clientSignature: json['client_signature'],
    );
  }
}

class TrackData {
  TrackData({
    required this.id,
    required this.afterImage,
    required this.beforeImage,
  });

  final int id;
  final String afterImage;
  final String beforeImage;

  factory TrackData.fromJson(Map<String, dynamic> json) => TrackData(
    id: json['id'],
    afterImage: json['after_image'],
    beforeImage: json['before_image'],
  );
}