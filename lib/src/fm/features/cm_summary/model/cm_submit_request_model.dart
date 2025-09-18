

import '../../cm_additional_emp/model/cm_add_emp_response_model.dart';
import '../../common/photosupload/model/uploadfile_after_response_model.dart';
import '../../common/photosupload/model/uploadfile_response_model.dart';

class CMSubmitRequestModel {
  int? cmID;
  String? startTime;
  String? endTime;
  List<UploadedImageData>? pre_images;
  List<UploadedAfterImageData>? post_images;
  String? observation;
  int? rootCauseID;
  String? rootCauseName;
  List<AssignedEmployeeList>? assignedEmp;
  String? occupantName;
  String? occupantMobile;
  String? occupantSign;
  String? tecRemarks;
  String? tecSign;
  int? createdBy;

  CMSubmitRequestModel({
   this.cmID,
   this.startTime,
   this.endTime,
   this.pre_images,
   this.post_images,
   this.observation,
   this.rootCauseID,
   this.rootCauseName,
   this.assignedEmp,
   this.occupantName,
   this.occupantMobile,
   this.occupantSign,
   this.tecRemarks,
   this.tecSign,
   this.createdBy,
});



  // Create a factory constructor for JSON deserialization
  factory CMSubmitRequestModel.fromJson(Map<String, dynamic> json) {
    return CMSubmitRequestModel(
      cmID: json['cm_id'],
      startTime: json['starttime'],
      endTime: json['endtime'],
      pre_images: json['pre_images'],
      post_images: json['post_images'],
      observation: json['observation'],
      rootCauseID: json['rootcause_id'],
      rootCauseName: json['rootcause_name'],
      assignedEmp: json['assigned_emp'],
      occupantName: json['occupant_name'],
      occupantMobile: json['occupant_mobile'],
      occupantSign: json['occupant_sign'],
      tecRemarks: json['tech_remarks'],
      tecSign: json['tech_sign'],
      createdBy: json['createdBy'],
    );
  }

  // Create a method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'cm_id': cmID,
      'starttime': startTime,
      'endtime': endTime,
      'pre_images': pre_images?.map((image) => image?.toJson()).toList(),
       'post_images': post_images?.map((image) => image?.toJson()).toList(),
      'observation': observation,
      'rootcause_id': rootCauseID,
      'rootcause_name': rootCauseName,
      'assigned_emp': assignedEmp?.map((emp) => emp?.toJson()).toList(),
      'occupant_name': occupantName,
      'occupant_mobile': occupantMobile,
      'occupant_sign': occupantSign,
      'tech_remarks': tecRemarks,
      'tech_sign': tecSign,
      'createdBy': createdBy,
    };
  }


}