import 'package:cmms/src/features/faultreport/submit/model/priority_response_model.dart';
import 'package:flutter/cupertino.dart';

import 'fault_report_save_model.dart';
import 'fault_report_save_model_old.dart';

class UploadViewModel with ChangeNotifier {
// Private constructor
  UploadViewModel._private();

  // Static instance
  static final UploadViewModel _instance = UploadViewModel._private();

  // Factory constructor to provide access to the instance
  factory UploadViewModel() {
    return _instance;
  }

  FaultReportSaveModel? _faultReportSaveModel;
  FaultReportOldSaveModel? _faultReportoldSaveModel;

  FaultReportSaveModel get faultReportSaveModel {
    _faultReportSaveModel ??= FaultReportSaveModel();
    return _faultReportSaveModel!;
  }

  FaultReportOldSaveModel get faultReportoldSaveModel {
    _faultReportoldSaveModel ??= FaultReportOldSaveModel();
    return _faultReportoldSaveModel!;
  }

  void updateFaultReportSaveModel1(int typeId, String typeName) {
    faultReportSaveModel.type = typeId;
    faultReportSaveModel.typeName = typeName;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updateFaultReportSaveModel11(int typeId, String typeName) {
    faultReportoldSaveModel.type = typeId;
    faultReportoldSaveModel.typeName = typeName;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updateFaultReportSaveModelSubType(int subtypeId, String subTypeName) {
    faultReportSaveModel.subTypeID = subtypeId;
    faultReportSaveModel.subTypeName = subTypeName;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updateFaultReportSaveModelSubType1(int subtypeId, String subTypeName) {
    faultReportoldSaveModel.subTypeID = subtypeId;
    faultReportoldSaveModel.subTypeName = subTypeName;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void updateFaultReportSaveModel2(String priorityName) {
    faultReportSaveModel.priority = priorityName;
    notifyListeners();
  }

  void updateFaultReportSaveModel21(String priorityName) {
    faultReportoldSaveModel.priority = priorityName;
    notifyListeners();
  }

  void updateFaultReportSaveModel3(String description) {
    faultReportSaveModel.description = description;
    notifyListeners();
  }

  void updateFaultReportSaveModel31(String description) {
    faultReportoldSaveModel.description = description;
    notifyListeners();
  }

  void updateFaultReportSaveModel4(int propertyid, String property_name) {
    faultReportSaveModel.propertyId = propertyid;
    faultReportSaveModel.propertyName = property_name;
    notifyListeners();
  }

  void updateFaultReportSaveModel41(int propertyid, String property_name) {
    faultReportoldSaveModel.propertyId = propertyid;
    faultReportoldSaveModel.propertyName = property_name;
    notifyListeners();
  }

  void updateFaultReportSaveModel5(int roomid) {
    faultReportSaveModel.levelId = roomid;
    notifyListeners();
  }

  void updateFaultReportSaveModel51(int roomid) {
    faultReportoldSaveModel.levelId = roomid;
    notifyListeners();
  }

  void updateFaultReportSaveModel6(String username, String email, String phone,
      String datetime, int userid, List<MultipleImage> imagepath) {
    faultReportSaveModel.requestorName = username;
    faultReportSaveModel.requestorEmail = email;
    faultReportSaveModel.requestedPhone = phone;
    faultReportSaveModel.requestDate = datetime;
    faultReportSaveModel.createdBy = userid;
    faultReportSaveModel.multipleImage = imagepath;
    notifyListeners();
  }

  void updateFaultReportSaveModel61(String username, String email, String phone,
      String datetime, int userid, List<MultipleImage> imagepath) {
    faultReportoldSaveModel.requestorName = username;
    faultReportoldSaveModel.requestorEmail = email;
    faultReportoldSaveModel.requestedPhone = phone;
    faultReportoldSaveModel.requestDate = datetime;
    faultReportoldSaveModel.createdBy = userid;
    faultReportoldSaveModel.multipleImage = imagepath;
    notifyListeners();
  }

  void resetFaultReportData() {
    faultReportSaveModel.type = 0;
    faultReportSaveModel.typeName = "";
    faultReportSaveModel.priority = "";
    faultReportSaveModel.description = "";
    faultReportSaveModel.propertyId = 0;
    faultReportSaveModel.propertyName = "";
    faultReportSaveModel.levelId = 0;
    faultReportSaveModel.requestorName = "";
    faultReportSaveModel.requestorEmail = "";
    faultReportSaveModel.requestedPhone = "";
    faultReportSaveModel.requestDate = "";
    faultReportSaveModel.createdBy = 0;
    faultReportSaveModel.imagePath = "";
    faultReportSaveModel.additionalSpace = "";
    notifyListeners();
  }

  void resetFaultReportData1() {
    faultReportoldSaveModel.type = 0;
    faultReportoldSaveModel.typeName = "";
    faultReportoldSaveModel.priority = "";
    faultReportoldSaveModel.description = "";
    faultReportoldSaveModel.propertyId = 0;
    faultReportoldSaveModel.propertyName = "";
    faultReportoldSaveModel.levelId = 0;
    faultReportoldSaveModel.requestorName = "";
    faultReportoldSaveModel.requestorEmail = "";
    faultReportoldSaveModel.requestedPhone = "";
    faultReportoldSaveModel.requestDate = "";
    faultReportoldSaveModel.createdBy = 0;
    faultReportoldSaveModel.imagePath = "";
    faultReportoldSaveModel.additionalSpace = "";
    notifyListeners();
  }
}
