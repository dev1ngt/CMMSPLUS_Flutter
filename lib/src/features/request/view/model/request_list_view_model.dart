class RequestViewModel {
  dynamic id;
  List<RequestHistory> requestHistory;
  List<AssignedUser> assignedUsers;
  List<OptionStatus> optionStatus;
  List<Multipleimage> multipleimage;
  final List<Asset> assets;
  int assignedToId;
  String assignedTo;
  int statusId;
  String currentStatus;
  bool status;
  String priorityName;
  int priorityId;
  String message;
  String remarks;
  String additionalSpace;
  int maxFile;
  int estimatedAmount;

  RequestViewModel({
    required this.id,
    required this.requestHistory,
    required this.assignedUsers,
    required this.optionStatus,
    required this.multipleimage,
    required this.assets,
    required this.assignedToId,
    required this.assignedTo,
    required this.statusId,
    required this.currentStatus,
    required this.status,
    required this.message,
    required this.remarks,
    required this.priorityName,
    required this.priorityId,
    required this.additionalSpace,
    required this.maxFile,
    required this.estimatedAmount,
  });

  factory RequestViewModel.fromJson(Map<String, dynamic> json) {
    return RequestViewModel(
      id: json['id'],
      requestHistory: json['request_history'] != null
          ? List<RequestHistory>.from(json['request_history'].map((x) => RequestHistory.fromJson(x)))
          : [],
      assignedUsers: json['assigned_users'] != null
          ? List<AssignedUser>.from(json['assigned_users'].map((x) => AssignedUser.fromJson(x)))
          : [],
      optionStatus: json['option_status'] != null
          ? List<OptionStatus>.from(json['option_status'].map((x) => OptionStatus.fromJson(x)))
          : [],
      multipleimage: json['multipleimage'] != null
          ? List<Multipleimage>.from(json['multipleimage'].map((x) => Multipleimage.fromJson(x)))
          : [],
      assets: json['assets'] !=null
          ? List<Asset>.from(json['assets'].map((e) => Asset.fromJson(e)))
          : [],
      assignedToId: json['assigned_to_id'] ?? 0,
      assignedTo: json['assigned_to'] ?? '',
      statusId: json['status_id'] ?? 0,
      currentStatus: json['current_status'] ?? '',
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      remarks: json['remarks'] ?? '',
      priorityName: json['priority_name'] ?? '',
      priorityId: json['priority_id'] ?? 0,
      additionalSpace: json['additional_space'] ?? '',
      maxFile: json['max_file'] ?? 0,
      estimatedAmount: json['estimated_amount'] ?? 0,
    );
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
    required this.type,
    required this.updateDate,
    required this.comments,
    required this.status,
    required this.assignedTo,
    required this.updatedBy,
  });

  factory RequestHistory.fromJson(Map<String, dynamic> json) {
    return RequestHistory(
      type: json['type'] ?? '',
      updateDate: json['update_date'] ?? '',
      comments: json['comments'] ?? '',
      status: json['status'] ?? '',
      assignedTo: json['assigned_to'] ?? '',
      updatedBy: json['updated_by'] ?? '',
    );
  }
}

class AssignedUser {
  int id;
  String firstName;

  AssignedUser({
    required this.id,
    required this.firstName,
  });

  factory AssignedUser.fromJson(Map<String, dynamic> json) {
    return AssignedUser(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
    );
  }
}

class OptionStatus {
  int id;
  int optionId;
  String optionText;

  OptionStatus({
    required this.id,
    required this.optionId,
    required this.optionText,
  });

  factory OptionStatus.fromJson(Map<String, dynamic> json) {
    return OptionStatus(
      id: json['id'] ?? 0,
      optionId: json['option_id'] ?? 0,
      optionText: json['option_text'] ?? '',
    );
  }
}

class Multipleimage {
  int id;
  String path;
  String type;

  Multipleimage({
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

  factory Multipleimage.fromJson(Map<String, dynamic> json) {
    return Multipleimage(
      id: json['id'] ?? 0,
      path: json['path'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class Asset {
  final int assetId;
  final String assetName;

  Asset({required this.assetId, required this.assetName});

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      assetId: json['asset_id'],
      assetName: json['asset_name'],
    );
  }
}
