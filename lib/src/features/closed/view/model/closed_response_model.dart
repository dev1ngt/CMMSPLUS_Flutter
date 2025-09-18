class ClosedViewModelNew {
  dynamic id;
  List<RequestHistory> requestHistory;
  int assignedToId;
  String assignedTo;
  int statusId;
  String currentStatus;
  String description;
  String remarks;
  int priorityId;
  String priorityName;
  String additionalSpace;
  List<Multipleimage> multipleimage;
  bool status;
  String message;

  ClosedViewModelNew({
    this.id = 0,
    this.requestHistory = const [],
    this.assignedToId = 0,
    this.assignedTo = '',
    this.statusId = 0,
    this.currentStatus = '',
    this.description = '',
    this.remarks = '',
    this.priorityId = 0,
    this.priorityName = '',
    this.additionalSpace = '',
    this.multipleimage = const [],
    this.status = false,
    this.message = '',
  });

  ClosedViewModelNew.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        assignedToId = json['assigned_to_id'] ?? 0,
        assignedTo = json['assigned_to'] ?? '',
        statusId = json['status_id'] ?? 0,
        currentStatus = json['current_status'] ?? '',
        description = json['description'] ?? '',
        remarks = json['remarks'] ?? '',
        priorityId = json['priority_id'] ?? 0,
        priorityName = json['priority_name'] ?? '',
        additionalSpace = json['additional_space'] ?? '',
        status = json['status'] ?? false,
        message = json['message'] ?? '',
        requestHistory = (json['request_history'] as List<dynamic>?)
            ?.map((v) => RequestHistory.fromJson(v))
            .toList() ??
            [],
        multipleimage = (json['multipleimage'] as List<dynamic>?)
            ?.map((v) => Multipleimage.fromJson(v))
            .toList() ??
            [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_history': requestHistory.map((v) => v.toJson()).toList(),
      'assigned_to_id': assignedToId,
      'assigned_to': assignedTo,
      'status_id': statusId,
      'current_status': currentStatus,
      'description': description,
      'remarks': remarks,
      'priority_id': priorityId,
      'priority_name': priorityName,
      'additional_space': additionalSpace,
      'multipleimage': multipleimage.map((v) => v.toJson()).toList(),
      'status': status,
      'message': message,
    };
  }
}

class RequestHistory {
  String type;
  String updateDate;
  String comments;
  String status;
  String assignedTo;
  String updatedBy;

  RequestHistory({
    this.type = '',
    this.updateDate = '',
    this.comments = '',
    this.status = '',
    this.assignedTo = '',
    this.updatedBy = '',
  });

  RequestHistory.fromJson(Map<String, dynamic> json)
      : type = json['type'] ?? '',
        updateDate = json['update_date'] ?? '',
        comments = json['comments'] ?? '',
        status = json['status'] ?? '',
        assignedTo = json['assigned_to'] ?? '',
        updatedBy = json['updated_by'] ?? '';

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

class Multipleimage {
  int id;
  String path;
  String type;

  Multipleimage({
    this.id = 0,
    this.path = '',
    this.type = '',
  });

  Multipleimage.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        path = json['path'] ?? '',
        type = json['type'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'type': type,
    };
  }
}
