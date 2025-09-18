import '../../../pendingresponsedetails/model/TechnicianInitiateRequestModel.dart';

class InprogressSubmitRequestModel {
  int? requestId;
  int? faultId;
  int? userId;
  String? companyName;
  String? nameOfPersonnel;
  String? dateOfArrival;
  String? timeOfArrival;
  String? causeOfFault;
  String? actionTaken;
  int? photoTaken;
  List<AfterFixPhoto>? photo;
  int? partsReplacement;
  String? itemReplaced;
  int? responseTime;
  int? downTime;
  int? status;
  String? estTimeCompletion;
  int? followUpAction;
  int? quoteAmount;
  String? pendingItemReplaced;
  String? pendingDateOfCompletion;
  String? pendingStartTime;
  String? pendingEndTime;
  int? pendingDownTime;
  String? userName;
  String? userDesignation;
  String? userSignature;
  String? contractorName;
  String? designation;
  String? signature;
  String? quoteRefNo;
  String? quoteDownTime;
  String? quoteDate;
  String? assetId;
  String? vendor;
  String? clientSignature;
  String? completedRemarks;
  int? statusAction;
  String? additionalSpace;

  // status_action

  InprogressSubmitRequestModel({
    this.requestId,
    this.faultId,
    this.userId,
    this.companyName,
    this.nameOfPersonnel,
    this.dateOfArrival,
    this.timeOfArrival,
    this.causeOfFault,
    this.actionTaken,
    this.photoTaken,
    this.photo,
    this.partsReplacement,
    this.itemReplaced,
    this.responseTime,
    this.downTime,
    this.status,
    this.estTimeCompletion,
    this.followUpAction,
    this.quoteAmount,
    this.pendingItemReplaced,
    this.pendingDateOfCompletion,
    this.pendingStartTime,
    this.pendingEndTime,
    this.pendingDownTime,
    this.userName,
    this.userDesignation,
    this.userSignature,
    this.contractorName,
    this.designation,
    this.signature,
    this.quoteRefNo,
    this.quoteDownTime,
    this.quoteDate,
    this.assetId,
    this.vendor,
    this.clientSignature,
    this.completedRemarks,
    this.statusAction,
    this.additionalSpace,
  });


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['request_id'] = requestId;
    data['fault_id'] = faultId;
    data['user_id'] = userId;
    data['company_name'] = companyName;
    data['name_of_personnel'] = nameOfPersonnel;
    data['date_of_arrival'] = dateOfArrival;
    data['time_of_arrival'] = timeOfArrival;
    data['cause_of_fault'] = causeOfFault;
    data['action_taken'] = actionTaken;
    data['photo_taken'] = photoTaken;
    data['photo'] = photo?.map((e) => e.toJson()).toList();
    data['parts_replacement'] = partsReplacement;
    data['item_replaced'] = itemReplaced;
    data['response_time'] = responseTime;
    data['down_time'] = downTime;
    data['status'] = status;
    data['est_time_completion'] = estTimeCompletion;
    data['follow_up_action'] = followUpAction;
    data['quote_amount'] = quoteAmount;
    data['pending_item_replaced'] = pendingItemReplaced;
    data['pending_date_of_completion'] = pendingDateOfCompletion;
    data['pending_start_time'] = pendingStartTime;
    data['pending_end_time'] = pendingEndTime;
    data['pending_down_time'] = pendingDownTime;
    data['user_name'] = userName;
    data['user_designation'] = userDesignation;
    data['user_signature'] = userSignature;
    data['contractor_name'] = contractorName;
    data['designation'] = designation;
    data['signature'] = signature;
    data['quote_ref_no'] = quoteRefNo;
    data['quote_down_time'] = quoteDownTime;
    data['quote_date'] = quoteDate;
    data['asset_id'] = assetId;
    data['vendor']  = vendor;
    data['client_signature'] = clientSignature;
    data['completed_remarks'] = completedRemarks;
    data['status_action']  = statusAction;
    data['additional_space']  = additionalSpace;
    return data;
  }
}

class AfterFixPhoto {
  int id;
  String afterImage;
  String beforeImage;

  AfterFixPhoto({
    required this.id,
    required this.afterImage,
    required this.beforeImage,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['after_image'] = this.afterImage;
    data['before_image'] = this.beforeImage;
    return data;
  }


}