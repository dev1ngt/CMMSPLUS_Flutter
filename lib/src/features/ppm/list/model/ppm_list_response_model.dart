import '../../../faultreport/submit/model/priority_response_model.dart';

class PPMListResponseModel {
  dynamic isError;
  dynamic message;
  List<ParentItem> parentItems;
  List<StatusArray> statusArrays;

  PPMListResponseModel({
    this.isError,
    this.message,
    required this.parentItems,
    required this.statusArrays,
  });

  factory PPMListResponseModel.fromJson(Map<String, dynamic> json) {
    var parentItemsList = json['parentItems'] as List?;
    List<ParentItem> parentItems = parentItemsList != null
        ? parentItemsList.map((i) => ParentItem.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    var statusArraysList = json['statusArrays'] as List?;
    List<StatusArray> statusArrays = statusArraysList != null
        ? statusArraysList.map((i) => StatusArray.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return PPMListResponseModel(
      isError: json['IsError'],
      message: json['Message'],
      parentItems: parentItems,
      statusArrays: statusArrays,
    );
  }
}

class ParentItem {
  dynamic count;
  dynamic monthName;
  dynamic isExpand;
  List<ChildItem> childItems; // Changed from dynamic

  ParentItem({
    this.count,
    this.monthName,
    this.isExpand,
    required this.childItems, // Made required if it always exists
  });

  factory ParentItem.fromJson(Map<String, dynamic> json) {
    var childItemsList = json['childItems'] as List?;
    List<ChildItem> childItems = childItemsList != null
        ? childItemsList.map((i) => ChildItem.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return ParentItem(
      count: json['Count'],
      monthName: json['MonthName'],
      isExpand: json['IsExpand'],
      childItems: childItems,
    );
  }
}

class ChildItem {
  dynamic scheduleId;
  dynamic scheduleName;
  dynamic scheduleStartDateTime;
  dynamic scheduleEndDateTime;
  dynamic inspectionType;
  dynamic regionName;
  dynamic propertyName;
  dynamic assetId;
  dynamic asset;
  dynamic priorityId;
  dynamic priority;
  dynamic webViewUrl;
  dynamic inspectionId;
  dynamic status;
  dynamic vendorId;
  dynamic vendor;
  List<ScheduleHistory> scheduleHistoryData; // Changed from dynamic
  List<AssignedUser> assignedUsers;         // Changed from dynamic
  dynamic assignedToId;
  dynamic assignedTo;
  dynamic maxFile;
  List<MultipleImage> multipleImage;       // Changed from dynamic

  ChildItem({
    this.scheduleId,
    this.scheduleName,
    this.scheduleStartDateTime,
    this.scheduleEndDateTime,
    this.inspectionType,
    this.regionName,
    this.propertyName,
    this.assetId,
    this.asset,
    this.priorityId,
    this.priority,
    this.webViewUrl,
    this.inspectionId,
    this.status,
    this.vendorId,
    this.vendor,
    required this.scheduleHistoryData, // Made required if they always exist
    required this.assignedUsers,
    this.assignedToId,
    this.assignedTo,
    this.maxFile,
    required this.multipleImage,
  });

  factory ChildItem.fromJson(Map<String, dynamic> json) {
    var scheduleHistoryDataList = json['schedule_history_data'] as List?;
    List<ScheduleHistory> scheduleHistoryData = scheduleHistoryDataList != null
        ? scheduleHistoryDataList.map((i) => ScheduleHistory.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    var assignedUsersList = json['assigned_users'] as List?;
    List<AssignedUser> assignedUsers = assignedUsersList != null
        ? assignedUsersList.map((i) => AssignedUser.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    var multipleImageList = json['multipleimage'] as List?;
    List<MultipleImage> multipleImage = multipleImageList != null
        ? multipleImageList.map((i) => MultipleImage.fromJson(i as Map<String, dynamic>)).toList()
        : [];

    return ChildItem(
      scheduleId: json["ScheduleId"],
      scheduleName: json['ScheduleName'],
      scheduleStartDateTime: json['ScheduleStartDateTime'],
      scheduleEndDateTime: json['ScheduleEndDateTime'],
      inspectionType: json['InspectionType'],
      regionName: json['regionName'],
      propertyName: json['PropertyName'],
      assetId: json['asset_id'],
      asset: json['asset'],
      priorityId: json['PriorityID'],
      priority: json['Priority'],
      webViewUrl: json['web_view_url'],
      inspectionId: json['InspectionID'],
      status: json['Status'],
      vendorId: json['vendor_id'],
      vendor: json['vendor'],
      scheduleHistoryData: scheduleHistoryData,
      assignedUsers: assignedUsers,
      assignedToId: json['assigned_to_id'],
      assignedTo: json['assigned_to'],
      maxFile: json['max_file'],
      multipleImage: multipleImage,
    );
  }
}

class ScheduleHistory {
  dynamic type;
  dynamic updateDate;
  dynamic comments;
  dynamic status;
  dynamic assignedTo;
  dynamic updatedBy;

  ScheduleHistory({
    this.type,
    this.updateDate,
    this.comments,
    this.status,
    this.assignedTo,
    this.updatedBy,
  });

  factory ScheduleHistory.fromJson(Map<String, dynamic> json) {
    return ScheduleHistory(
      type: json['type'],
      updateDate: json['update_date'],
      comments: json['comments'],
      status: json['status'],
      assignedTo: json['assigned_to'],
      updatedBy: json['updated_by'],
    );
  }
}

class AssignedUser {
  dynamic id;
  dynamic firstName;

  AssignedUser({
    this.id,
    this.firstName,
  });

  factory AssignedUser.fromJson(Map<String, dynamic> json) {
    return AssignedUser(
      id: json['id'],
      firstName: json['first_name'],
    );
  }
}

class MultipleImage {
  final int id;
  final String type;
  final String path;

  MultipleImage({
    required this.id,
    required this.type,
    required this.path,
  });

  factory MultipleImage.fromJson(Map<String, dynamic> json) {
    return MultipleImage(
      id: json['id'] as int,
      type: json['type'] as String,
      path: json['path'] as String,
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


class StatusArray {
  dynamic pending;
  dynamic completed;
  dynamic closed;

  StatusArray({
    this.pending,
    this.completed,
    this.closed,
  });

  factory StatusArray.fromJson(Map<String, dynamic> json) {
    return StatusArray(
      pending: json['Pending'],
      completed: json['Completed'],
      closed: json['Closed'],
    );
  }
}