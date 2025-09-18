

import 'package:flutter/cupertino.dart';

import '../../cm_additional_emp/model/cm_add_emp_response_model.dart';
import '../../common/photosupload/model/uploadfile_after_response_model.dart';
import '../../common/photosupload/model/uploadfile_response_model.dart';
import 'cm_submit_request_model.dart';

class CMSubmitSaveModel with ChangeNotifier {
// Private constructor
  CMSubmitSaveModel._private();

  // Static instance
  static final CMSubmitSaveModel _instance = CMSubmitSaveModel._private();

  // Factory constructor to provide access to the instance
  factory CMSubmitSaveModel() {
    return _instance;
  }

  CMSubmitRequestModel? _cmSubmitRequestModel;

  CMSubmitRequestModel get cmSubmitRequestModel {
    _cmSubmitRequestModel ??= CMSubmitRequestModel();
    return _cmSubmitRequestModel!;
  }

  void updateCMWorkOrderID(int workid){
    cmSubmitRequestModel.cmID = workid;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updateCMWorkOrderStartTime(String starttime) {
    cmSubmitRequestModel.startTime = starttime;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updateCMWorkOrderPreImages(List<UploadedImageData> pre_images){
    cmSubmitRequestModel.pre_images = pre_images;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updateCMWorkOrderPostImages(List<UploadedAfterImageData> post_images){
    cmSubmitRequestModel.post_images = post_images;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updateCMWorkOrderObservationRootcause(String observation , String RootCauseName , int RootCauseID){
    cmSubmitRequestModel.observation = observation;
    cmSubmitRequestModel.rootCauseID = RootCauseID;
    cmSubmitRequestModel.rootCauseName = RootCauseName;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updateCMWorkAdditionalEmp(List<AssignedEmployeeList> additional_emp){
    cmSubmitRequestModel.assignedEmp = additional_emp;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updateCMWorkOccupantInfo(String name , String phone , String sign){
    cmSubmitRequestModel.occupantName = name;
    cmSubmitRequestModel.occupantMobile = phone;
    cmSubmitRequestModel.occupantSign = sign;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updateCMTechRemarks(String remarks , String tech_sign , String endtime , int userid){

    cmSubmitRequestModel.tecRemarks = remarks;
    cmSubmitRequestModel.tecSign  = tech_sign;
    cmSubmitRequestModel.endTime  = endtime;
    cmSubmitRequestModel.createdBy = userid;
  }

  void updateCMTechRemarksAndSign(String remarks , String tech_sign ){
    cmSubmitRequestModel.tecRemarks = remarks;
    cmSubmitRequestModel.tecSign  = tech_sign;
  }



  void resetCMData(){

    cmSubmitRequestModel.cmID =  0;
    cmSubmitRequestModel.startTime =  "";
    cmSubmitRequestModel.pre_images =  [];
    cmSubmitRequestModel.post_images =  [];
    cmSubmitRequestModel.observation = "";
    cmSubmitRequestModel.rootCauseID = 0;
    cmSubmitRequestModel.rootCauseName = "";

    cmSubmitRequestModel.tecRemarks = "";
    cmSubmitRequestModel.tecSign  = "";
    cmSubmitRequestModel.endTime  = "";
    cmSubmitRequestModel.createdBy = 0;

    cmSubmitRequestModel.occupantName = "";
    cmSubmitRequestModel.occupantMobile = "";
    cmSubmitRequestModel.occupantSign = "";

    notifyListeners();
  }

}