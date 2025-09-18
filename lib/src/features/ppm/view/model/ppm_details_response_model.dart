class PPMDetailsResponseModel {
  final bool isError;
  final String message;
  final ScheduleData? data;

  PPMDetailsResponseModel({
    required this.isError,
    required this.message,
    this.data,
  });

  factory PPMDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return PPMDetailsResponseModel(
      isError: json['IsError'] ?? false,
      message: json['Message'] ?? '',
      data: json['data'] != null ? ScheduleData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IsError': isError,
      'Message': message,
      'data': data?.toJson(),
    };
  }
}

class ScheduleData {
  final int scheduleId;
  final String scheduleName;
  final String scheduleStartDateTime;
  final String scheduleEndDateTime;
  final String inspectionType;
  final String propertyName;
  final String assetId;
  final String asset;
  final int priorityId;
  final String priority;
  final int vendorId;
  final String vendor;
  final String webViewUrl;
  final String inspectionId;
  final String status;
  final String regionName;
  final int assignedToId;
  final String assignedTo;
  final List<PPMDetailsScheduleHistory> scheduleHistoryData;
  final List<PPMDetailsMultipleImage> multipleImage;
  final int maxFile;

  ScheduleData({
    required this.scheduleId,
    required this.scheduleName,
    required this.scheduleStartDateTime,
    required this.scheduleEndDateTime,
    required this.inspectionType,
    required this.propertyName,
    required this.assetId,
    required this.asset,
    required this.priorityId,
    required this.priority,
    required this.vendorId,
    required this.vendor,
    required this.webViewUrl,
    required this.inspectionId,
    required this.status,
    required this.regionName,
    required this.assignedToId,
    required this.assignedTo,
    required this.scheduleHistoryData,
    required this.multipleImage,
    required this.maxFile,
  });

  factory ScheduleData.fromJson(Map<String, dynamic> json) {
    return ScheduleData(
      scheduleId: json['ScheduleId'] ?? 0,
      scheduleName: json['ScheduleName'] ?? '',
      scheduleStartDateTime: json['ScheduleStartDateTime'] ?? '',
      scheduleEndDateTime: json['ScheduleEndDateTime'] ?? '',
      inspectionType: json['InspectionType'] ?? '',
      propertyName: json['PropertyName'] ?? '',
      assetId: json['asset_id'] ?? '',
      asset: json['asset'] ?? '',
      priorityId: json['PriorityID'] ?? 0,
      priority: json['Priority'] ?? '',
      vendorId: json['vendor_id'] ?? 0,
      vendor: json['vendor'] ?? '',
      webViewUrl: json['web_view_url']?.toString() ?? '',
      inspectionId: json['InspectionID']?.toString() ?? '',
      status: json['Status'] ?? '',
      regionName: json['regionName']?.toString() ?? '',
      assignedToId: json['assigned_to_id'] ?? 0,
      assignedTo: json['assigned_to'] ?? '',
      scheduleHistoryData: (json['schedule_history_data'] as List<dynamic>?)
          ?.map((e) => PPMDetailsScheduleHistory.fromJson(e))
          .toList() ??
          [],
      multipleImage: (json['multipleimage'] as List<dynamic>?)
          ?.map((e) => PPMDetailsMultipleImage.fromJson(e))
          .toList() ??
          [],
      maxFile: json['max_file'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ScheduleId': scheduleId,
      'ScheduleName': scheduleName,
      'ScheduleStartDateTime': scheduleStartDateTime,
      'ScheduleEndDateTime': scheduleEndDateTime,
      'InspectionType': inspectionType,
      'PropertyName': propertyName,
      'asset_id': assetId,
      'asset': asset,
      'PriorityID': priorityId,
      'Priority': priority,
      'vendor_id': vendorId,
      'vendor': vendor,
      'web_view_url': webViewUrl,
      'InspectionID': inspectionId,
      'Status': status,
      'regionName': regionName,
      'assigned_to_id': assignedToId,
      'assigned_to': assignedTo,
      'schedule_history_data':
      scheduleHistoryData.map((e) => e.toJson()).toList(),
      'multipleimage': multipleImage.map((e) => e.toJson()).toList(),
      'max_file': maxFile,
    };
  }
}

class PPMDetailsMultipleImage {
  final int id;
  final String type;
  final String path;

  PPMDetailsMultipleImage({
    required this.id,
    required this.type,
    required this.path,
  });

  factory PPMDetailsMultipleImage.fromJson(Map<String, dynamic> json) {
    return PPMDetailsMultipleImage(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      path: json['path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'path': path,
    };
  }
}

class PPMDetailsScheduleHistory {
  final String? type;
  final String? updateDate;
  final String? comments;
  final String? status;
  final String? assignedTo;
  final String? updatedBy;

  PPMDetailsScheduleHistory({
    this.type,
    this.updateDate,
    this.comments,
    this.status,
    this.assignedTo,
    this.updatedBy,
  });

  factory PPMDetailsScheduleHistory.fromJson(Map<String, dynamic> json) {
    return PPMDetailsScheduleHistory(
      type: json['type'],
      updateDate: json['update_date'],
      comments: json['comments'],
      status: json['status'],
      assignedTo: json['assigned_to'],
      updatedBy: json['updated_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'update_date': updateDate,
      'comments': comments,
      'status': status,
      'assigned_to': assignedTo,
      'updated_by': updatedBy,
    };
  }
}

