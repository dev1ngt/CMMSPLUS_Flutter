


import '../../../cm_additional_emp/model/cm_add_emp_response_model.dart';
import '../../ppm_additional_emp/model/ppm_add_emp_response_model.dart';
import '../../ppm_checkpoint/model/ppm_checklist_response_model.dart';
import '../../ppm_postimage/model/image_upload/ppm_post_uploadfile_response_model.dart';
import '../../ppm_preimage/model/image_upload/ppm_uploadfile_response_model.dart';

class PPMSubmitRequestModelOne {
  int? ppmID;
  String? startTime;
  String? endTime;
  String? assetName;
  String? assetTagNo ;
  String? assetNo;
  bool? isQrcode;
  List<PPMUploadedImageData>? pre_images;
  List<PPMCheckList>? ppmCheckpoints;
  List<PPMPostUploadedImageData>? post_images;
  List<PPMAssignedEmployeeList>? assignedEmp;
  String? tecRemarks;
  String? tecSign;
  int? createdBy;

  PPMSubmitRequestModelOne({
   this.ppmID,
   this.startTime,
   this.endTime,
   this.assetName,
   this.assetTagNo,
   this.assetNo,
   this.isQrcode,
   this.pre_images,
   this.ppmCheckpoints,
   this.post_images,
   this.assignedEmp,
   this.tecRemarks,
   this.tecSign,
   this.createdBy,
});



  // Create a factory constructor for JSON deserialization
  factory PPMSubmitRequestModelOne.fromJson(Map<String, dynamic> json) {
    return PPMSubmitRequestModelOne(
      ppmID: json['ppmID'],
      startTime: json['starttime'],
      endTime: json['endtime'],
      assetName: json['assetname'],
      assetTagNo: json['assettagno'],
      assetNo: json['assetno'],
      isQrcode: json['isqrcode'],
      pre_images: json['pre_images'],
      ppmCheckpoints: json['ppm_checkpoints'],
      post_images: json['post_images'],
      assignedEmp: json['assigned_emp'],
      tecRemarks: json['tech_remarks'],
      tecSign: json['tech_sign'],
      createdBy: json['createdBy'],
    );
  }

  // Create a method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'ppmid': ppmID,
      'starttime': startTime,
      'endtime': endTime,
      'assetname': assetName,
      'assettagno': assetTagNo,
      'assetno': assetNo,
      'isqrcode': isQrcode,
      'tech_remarks': tecRemarks,
      'tech_sign': tecSign,
      'createdBy': createdBy,
      'pre_images': pre_images?.map((image) => image?.toJson()).toList(),
       'ppm_checkpoints': ppmCheckpoints?.map((checkpoint) => checkpoint?.toJson()).toList(),
       'post_images': post_images?.map((image) => image?.toJson()).toList(),
      'assigned_emp': assignedEmp?.map((emp) => emp?.toJson()).toList(),

    };
  }


}