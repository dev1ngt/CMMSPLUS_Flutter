


import 'package:flutter/cupertino.dart';
import '../../../cm_additional_emp/model/cm_add_emp_response_model.dart';
import '../../ppm_additional_emp/model/ppm_add_emp_response_model.dart';
import '../../ppm_checkpoint/model/ppm_checklist_response_model.dart';
import '../../ppm_postimage/model/image_upload/ppm_post_uploadfile_response_model.dart';
import '../../ppm_preimage/model/image_upload/ppm_uploadfile_response_model.dart';
import 'ppm_submit_request_model.dart';

class PPMSubmitSaveModel with ChangeNotifier {
// Private constructor
  PPMSubmitSaveModel._private();

  // Static instance
  static final PPMSubmitSaveModel _instance = PPMSubmitSaveModel._private();

  // Factory constructor to provide access to the instance
  factory PPMSubmitSaveModel() {
    return _instance;
  }

  PPMSubmitRequestModelOne? _ppmSubmitRequestModel;

  PPMSubmitRequestModelOne get ppmSubmitRequestModel {
    _ppmSubmitRequestModel ??= PPMSubmitRequestModelOne();
    return _ppmSubmitRequestModel!;
  }


  void updatePPMWorkOrderID(int workid){
    ppmSubmitRequestModel.ppmID = workid;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updatePPMWorkOrderStartTime(String starttime , int ppmid , String assetNo , String assetTagno , String assetName , bool isScanQr) {
    ppmSubmitRequestModel.startTime = starttime;
    ppmSubmitRequestModel.ppmID = ppmid;
    ppmSubmitRequestModel.assetNo = assetNo;
    ppmSubmitRequestModel.assetTagNo = assetTagno;
    ppmSubmitRequestModel.assetName = assetName;
    ppmSubmitRequestModel.isQrcode = isScanQr;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updatePPMWorkOrderPreImages(List<PPMUploadedImageData> pre_images){
    ppmSubmitRequestModel.pre_images = pre_images;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updatePPMWorkOrderPostImages(List<PPMPostUploadedImageData> post_images){
    ppmSubmitRequestModel.post_images = post_images;
    notifyListeners(); // Notify listeners when the model is updated
  }


  void updatePPmCheckpointList(List<PPMCheckList> checkpoints){
    ppmSubmitRequestModel.ppmCheckpoints = checkpoints;
    notifyListeners();
  }

  void updateAdditionalEmployee(List<PPMAssignedEmployeeList> employee){
    ppmSubmitRequestModel.assignedEmp = employee;
    notifyListeners();
  }


  void updatePPMTechRemarks(String remarks , String tech_sign , String endtime , int userid){
    ppmSubmitRequestModel.tecRemarks = remarks;
    ppmSubmitRequestModel.tecSign  = tech_sign;
    ppmSubmitRequestModel.endTime  = endtime;
    ppmSubmitRequestModel.createdBy = userid;
  }


  void resetPPMData(){

    ppmSubmitRequestModel.startTime = "";
    ppmSubmitRequestModel.ppmID = 0;
    ppmSubmitRequestModel.assetNo = "";
    ppmSubmitRequestModel.assetTagNo = "";
    ppmSubmitRequestModel.assetName = "";
    ppmSubmitRequestModel.isQrcode = false;

    ppmSubmitRequestModel.tecRemarks = "";
    ppmSubmitRequestModel.tecSign  = "";
    ppmSubmitRequestModel.endTime  = "";
    ppmSubmitRequestModel.createdBy = 0;

    ppmSubmitRequestModel.assignedEmp = [];
    ppmSubmitRequestModel.ppmCheckpoints = [];
    ppmSubmitRequestModel.post_images = [];
    ppmSubmitRequestModel.pre_images = [];
    notifyListeners();
  }


}