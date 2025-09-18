import 'package:cmms/src/features/faultreport/submit/model/priority_response_model.dart';

class FaultReportSaveModel {
  int? propertyId;
  int? levelId;
  int? type;
  String? description;
  String? requestorName;
  String? requestorEmail;
  String? requestedPhone;
  String? priority;
  String? imagePath;
  String? requestDate;
  int? createdBy;
  String? propertyName;
  String? typeName;
  int? subTypeID;
  String? subTypeName;
  String? additionalSpace;
  List<MultipleImage> multipleImage = [];

  FaultReportSaveModel({
    this.propertyId,
    this.levelId,
    this.type,
    this.description,
    this.requestorName,
    this.requestorEmail,
    this.requestedPhone,
    this.priority,
    this.imagePath,
    this.requestDate,
    this.createdBy,
    this.propertyName,
    this.typeName,
    this.subTypeID,
    this.subTypeName,
    this.additionalSpace,
    List<MultipleImage>? multipleImage,
  }): multipleImage = multipleImage ?? [];

  // Create a factory constructor for JSON deserialization
  factory FaultReportSaveModel.fromJson(Map<String, dynamic> json) {
    return FaultReportSaveModel(
      propertyId: json['property_id'],
      levelId: json['level_id'],
      type: json['type'],
      description: json['description'],
      requestorName: json['requestor_name'],
      requestorEmail: json['requestor_email'],
      requestedPhone: json['requested_phone'],
      priority: json['priority'],
      imagePath: json['image_path'],
      requestDate: json['request_date'],
      createdBy: json['created_by'],
      propertyName: json['property_name'],
      typeName: json['type_name'],
      subTypeID: json['subtype_id'],
      subTypeName: json['subtype_name'],
      additionalSpace: json['additional_space'],
      multipleImage: (json['multipleimage'] as List<dynamic>)
          .map((e) => MultipleImage.fromJson(e))
          .toList(),
    );
  }

  // Create a method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'property_id': propertyId,
      'level_id': levelId,
      'type': type,
      'description': description,
      'requestor_name': requestorName,
      'requestor_email': requestorEmail,
      'requested_phone': requestedPhone,
      'priority': priority,
      'image_path': imagePath,
      'request_date': requestDate,
      'created_by': createdBy,
      'property_name': propertyName,
      'type_name': typeName,
      'subtype_id': subTypeID,
      'subtype_name': subTypeName,
      'additional_space': additionalSpace,
      'multipleimage': multipleImage.map((e) => e.toJson()).toList(),
    };
  }
}