class InprogressResponseModel {
  int submitFlag;
  String completedRemarks;
  LoginOfRequestView loginOfRequestView;
  FaultResponseView faultResponseView;
  FollowUp followUp;
  List<MyImage> images;
  bool status;
  String message;

  InprogressResponseModel({
    required this.submitFlag,
    required this.completedRemarks,
    required this.loginOfRequestView,
    required this.faultResponseView,
    required this.followUp,
    required this.images,
    required this.status,
    required this.message,
  });

  factory InprogressResponseModel.fromJson(Map<String, dynamic> json) {
    return InprogressResponseModel(
      submitFlag: json['submit_flag'],
      completedRemarks: json['completed_remarks'],
      loginOfRequestView: LoginOfRequestView.fromJson(json['login_of_request_view']),
      faultResponseView: FaultResponseView.fromJson(json['fault_response_view']),
      followUp: FollowUp.fromJson(json['follow_up']),
      images: List<MyImage>.from(json['images'].map((x) => MyImage.fromJson(x))),
      status: json['status'],
      message: json['message'],
    );
  }
}

class LoginOfRequestView {
  int id;
  String caseId;
  String requestorName;
  String description;
  String dateOfRequest;
  String timeOfRequest;
  String property;
  String propertyId;
  String block;
  String blockId;
  String level;
  String levelId;
  String type;
  String typeId;
  String subType;
  String subTypeId;
  String assignedTech;
  String asset;
  String assetId;
  int fmmInformed;
  String typesOfService;
  String severityOfFault;
  String areaOfLocation;
  String fmm;
  String workStatusId;
  String workStatusName;
  int statusAction;

  LoginOfRequestView({
    required this.id,
    required this.caseId,
    required this.requestorName,
    required this.description,
    required this.dateOfRequest,
    required this.timeOfRequest,
    required this.property,
    required this.propertyId,
    required this.block,
    required this.blockId,
    required this.level,
    required this.levelId,
    required this.type,
    required this.typeId,
    required this.subType,
    required this.subTypeId,
    required this.assignedTech,
    required this.asset,
    required this.assetId,
    required this.fmmInformed,
    required this.typesOfService,
    required this.severityOfFault,
    required this.areaOfLocation,
    required this.fmm,
    required this.workStatusId,
    required this.workStatusName,
    required this.statusAction,
  });

  factory LoginOfRequestView.fromJson(Map<String, dynamic> json) {
    return LoginOfRequestView(
      id: json['id'],
      caseId: json['case_id'],
      requestorName: json['requestor_name'],
      description: json['description'],
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
      assignedTech: json['assigned_tech'],
      asset: json['asset'],
      assetId: json['asset_id'],
      fmmInformed: json['fmm_informed'],
      typesOfService: json['types_of_service'],
      severityOfFault: json['severity_of_fault'],
      areaOfLocation: json['area_of_location'],
      fmm: json['fmm'],
      workStatusId: json['work_status_id'],
      workStatusName: json['work_status_name'],
      statusAction: json['status_action'],
    );
  }
}

class FaultResponseView {
  int id;
  String companyName;
  String nameOfPersonnel;
  String causeOfFault;
  String actionTaken;
  String dateOfArrival;
  String timeOfArrival;
  int photoTaken;
  String photo;
  int partsReplacement;
  String itemReplaced;
  String estTimeCompletion;
  int status;
  int followUpAction;
  String contractorName;
  String designation;
  String signature;
  String quoteAmount;
  String vendor;
  String clientSignature;

  FaultResponseView({
    required this.id,
    required this.companyName,
    required this.nameOfPersonnel,
    required this.causeOfFault,
    required this.actionTaken,
    required this.dateOfArrival,
    required this.timeOfArrival,
    required this.photoTaken,
    required this.photo,
    required this.partsReplacement,
    required this.itemReplaced,
    required this.estTimeCompletion,
    required this.status,
    required this.followUpAction,
    required this.contractorName,
    required this.designation,
    required this.signature,
    required this.quoteAmount,
    required this.vendor,
    required this.clientSignature,
  });

  factory FaultResponseView.fromJson(Map<String, dynamic> json) {
    return FaultResponseView(
      id: json['id'],
      companyName: json['company_name'],
      nameOfPersonnel: json['name_of_personnel'],
      causeOfFault: json['cause_of_fault'],
      actionTaken: json['action_taken'],
      dateOfArrival: json['date_of_arrival'],
      timeOfArrival: json['time_of_arrival'],
      photoTaken: json['photo_taken'],
      photo: json['photo'],
      partsReplacement: json['parts_replacement'],
      itemReplaced: json['item_replaced'],
      estTimeCompletion: json['est_time_completion'],
      status: json['status'],
      followUpAction: json['follow_up_action'],
      contractorName: json['contractor_name'],
      designation: json['designation'],
      signature: json['signature'],
      quoteAmount: json['quote_amount'],
      vendor: json['vendor'],
      clientSignature: json['client_signature'],
    );
  }
}

class FollowUp {
  int status;
  String pendingItemReplaced;
  String pendingDateOfCompletion;
  String pendingStartTime;
  String pendingEndTime;
  String quoteRefNo;
  String quoteDate;
  String userName;
  String userDesignation;
  String userSignature;
  String downTimeHours;

  FollowUp({
    required this.status,
    required this.pendingItemReplaced,
    required this.pendingDateOfCompletion,
    required this.pendingStartTime,
    required this.pendingEndTime,
    required this.quoteRefNo,
    required this.quoteDate,
    required this.userName,
    required this.userDesignation,
    required this.userSignature,
    required this.downTimeHours,
  });

  factory FollowUp.fromJson(Map<String, dynamic> json) {
    return FollowUp(
      status: json['status'],
      pendingItemReplaced: json['pending_item_replaced'],
      pendingDateOfCompletion: json['pending_date_of_completion'],
      pendingStartTime: json['pending_start_time'],
      pendingEndTime: json['pending_end_time'],
      quoteRefNo: json['quote_ref_no'],
      quoteDate: json['quote_date'],
      userName: json['user_name'],
      userDesignation: json['user_designation'],
      userSignature: json['user_signature'],
      downTimeHours: json['down_time_hours'],
    );
  }
}

class MyImage {
  String? beforeImage;
  String? afterImage;
  int id;

  MyImage({
    required this.beforeImage,
    required this.afterImage,
    required this.id,
  });

  factory MyImage.fromJson(Map<String, dynamic> json) {
    return MyImage(
      beforeImage: json['before_image'],
      afterImage: json['after_image'],
      id: json['id'],
    );
  }
}