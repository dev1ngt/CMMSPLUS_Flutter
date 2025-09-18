

class TechnicianInitiateRequestModel {
  int? caseId;
  int? userId;
  String? companyName;
  String? nameOfPersonnel;
  String? dateOfArrival;
  String? timeOfArrival;
  String? causeOfFault;
  String? actionTaken;
  int? photoTaken;
  List<Photo>? photo;
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
  String? additionalSpace;

  TechnicianInitiateRequestModel({
    this.caseId,
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
    this.additionalSpace,
  });

  factory TechnicianInitiateRequestModel.fromJson(Map<String, dynamic> json) {
    return TechnicianInitiateRequestModel(
      caseId: json['case_id'],
      userId: json['user_id'],
      companyName: json['company_name'],
      nameOfPersonnel: json['name_of_personnel'],
      dateOfArrival: json['date_of_arrival'],
      timeOfArrival: json['time_of_arrival'],
      causeOfFault: json['cause_of_fault'],
      actionTaken: json['action_taken'],
      photoTaken: json['photo_taken'],
      photo: (json['photo'] as List<dynamic>?)
          ?.map((e) => Photo.fromJson(e))
          .toList(),
      partsReplacement: json['parts_replacement'],
      itemReplaced: json['item_replaced'],
      responseTime: json['response_time'],
      downTime: json['down_time'],
      status: json['status'],
      estTimeCompletion: json['est_time_completion'],
      followUpAction: json['follow_up_action'],
      quoteAmount: json['quote_amount'],
      pendingItemReplaced: json['pending_item_replaced'],
      pendingDateOfCompletion: json['pending_date_of_completion'],
      pendingStartTime: json['pending_start_time'],
      pendingEndTime: json['pending_end_time'],
      pendingDownTime: json['pending_down_time'],
      userName: json['user_name'],
      userDesignation: json['user_designation'],
      userSignature: json['user_signature'],
      contractorName: json['contractor_name'],
      designation: json['designation'],
      signature: json['signature'],
      quoteRefNo: json['quote_ref_no'],
      quoteDownTime: json['quote_down_time'],
      quoteDate: json['quote_date'],
      assetId: json['asset_id'],
      vendor: json['vendor'],
      clientSignature: json['client_signature'],
      additionalSpace: json['additional_space'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['case_id'] = caseId;
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
    data['additional_space'] = additionalSpace;
    return data;
  }
}

class Photo {
  String? beforePhoto;
  String? afterPhoto;

  Photo({
    this.beforePhoto,
    this.afterPhoto,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      beforePhoto: json['before_photo'],
      afterPhoto: json['after_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['before_photo'] = beforePhoto;
    data['after_photo'] = afterPhoto;
    return data;
  }
}