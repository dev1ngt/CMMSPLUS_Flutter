import 'dart:convert';

class PendingListResponseModel {
  List<PendingRequest>? pendingRequestList;
  List<StatusArray>? statusArray;
  bool? status;
  String? message;

  PendingListResponseModel({
    this.pendingRequestList,
    this.statusArray,
    this.status,
    this.message,
  });

  factory PendingListResponseModel.fromJson(Map<String, dynamic> json) {
    return PendingListResponseModel(
      pendingRequestList: json['pending_of_request_list'] != null
          ? (json['pending_of_request_list'] as List)
          .map((i) => PendingRequest.fromJson(i))
          .toList()
          : null,
      statusArray: json['status_array'] != null
          ? (json['status_array'] as List)
          .map((i) => StatusArray.fromJson(i))
          .toList()
          : null,
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pending_of_request_list': pendingRequestList?.map((i) => i.toJson()).toList(),
      'status_array': statusArray?.map((i) => i.toJson()).toList(),
      'status': status,
      'message': message,
    };
  }
}

class PendingRequest {
  String? contractorName;
  int? id;
  String? caseId;
  String? requestorName;
  String? dateOfRequest;
  String? timeOfRequest;
  String? property;
  String? propertyId;
  String? block;
  String? blockId;
  String? level;
  String? levelId;
  String? type;
  String? typeId;
  String? subType;
  String? subTypeId;
  String? beforePhotoPath;
  String? vendor;
  String? vendorId;
  String? asset;
  String? assetId;
  String? faultSeverity;
  String? description;
  String? status;
  String? statusName;
  String? additionalSpace;
  String? priority;

  PendingRequest({
    this.contractorName,
    this.id,
    this.caseId,
    this.requestorName,
    this.dateOfRequest,
    this.timeOfRequest,
    this.property,
    this.propertyId,
    this.block,
    this.blockId,
    this.level,
    this.levelId,
    this.type,
    this.typeId,
    this.subType,
    this.subTypeId,
    this.beforePhotoPath,
    this.vendor,
    this.vendorId,
    this.asset,
    this.assetId,
    this.faultSeverity,
    this.description,
    this.status,
    this.statusName,
    this.additionalSpace,
     this.priority,
  });

  factory PendingRequest.fromJson(Map<String, dynamic> json) {
    return PendingRequest(
      contractorName: json['contractor_name'],
      id: json['id'],
      caseId: json['case_id'],
      requestorName: json['requestor_name'],
      dateOfRequest: json['date_of_request'],
      timeOfRequest: json['time_of_request'],
      property: json['property'],
      propertyId: json['property_id'],
      block: json['block'],
      blockId: json['block_id'],
      level: json['level'],
      levelId: json['level_id'],
      type: json['type'],
      typeId: json['type_id'],
      subType: json['sub_type'],
      subTypeId: json['sub_type_id'],
      beforePhotoPath: json['before_photo_path'],
      vendor: json['vendor'],
      vendorId: json['vendor_id'],
      asset: json['asset'],
      assetId: json['asset_id'],
      faultSeverity: json['fault_severity'],
      description: json['description'],
      status: json['status'],
      statusName: json['status_name'],
      additionalSpace: json['additional_space'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contractor_name': contractorName,
      'id': id,
      'case_id': caseId,
      'requestor_name': requestorName,
      'date_of_request': dateOfRequest,
      'time_of_request': timeOfRequest,
      'property': property,
      'property_id': propertyId,
      'block': block,
      'block_id': blockId,
      'level': level,
      'level_id': levelId,
      'type': type,
      'type_id': typeId,
      'sub_type': subType,
      'sub_type_id': subTypeId,
      'before_photo_path': beforePhotoPath,
      'vendor': vendor,
      'vendor_id': vendorId,
      'asset': asset,
      'asset_id': assetId,
      'fault_severity': faultSeverity,
      'description': description,
      'status': status,
      'status_name': statusName,
      'additional_space': additionalSpace,
    };
  }
}

class StatusArray {
  String? status;

  StatusArray({this.status});

  factory StatusArray.fromJson(Map<String, dynamic> json) {
    return StatusArray(
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}