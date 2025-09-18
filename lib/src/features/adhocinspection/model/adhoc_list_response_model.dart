class AdhocListResponseModel {
  bool? isError;
  String? message;
  List<InspectionList>? inspectionList;
  List<StatusArrays>? statusArrays;

  AdhocListResponseModel(
      {this.isError, this.message, this.inspectionList, this.statusArrays});

  AdhocListResponseModel.fromJson(Map<String, dynamic> json) {
    isError = json['IsError'];
    message = json['Message'];
    if (json['InspectionList'] != null) {
      inspectionList = <InspectionList>[];
      json['InspectionList'].forEach((v) {
        inspectionList!.add(new InspectionList.fromJson(v));
      });
    }
    if (json['statusArrays'] != null) {
      statusArrays = <StatusArrays>[];
      json['statusArrays'].forEach((v) {
        statusArrays!.add(new StatusArrays.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsError'] = this.isError;
    data['Message'] = this.message;
    if (this.inspectionList != null) {
      data['InspectionList'] =
          this.inspectionList!.map((v) => v.toJson()).toList();
    }
    if (this.statusArrays != null) {
      data['statusArrays'] = this.statusArrays!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InspectionList {
  int? inspectionId;
  String? templateId;
  String? templateTitle;
  String? webViewUrl;
  String? status;

  InspectionList(
      {this.inspectionId,
        this.templateId,
        this.templateTitle,
        this.webViewUrl,
        this.status});

  InspectionList.fromJson(Map<String, dynamic> json) {
    inspectionId = json['Inspection_id'];
    templateId = json['template_id'];
    templateTitle = json['template_title'];
    webViewUrl = json['web_view_url'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Inspection_id'] = this.inspectionId;
    data['template_id'] = this.templateId;
    data['template_title'] = this.templateTitle;
    data['web_view_url'] = this.webViewUrl;
    data['Status'] = this.status;
    return data;
  }
}

class StatusArrays {
  int? pending;
  int? completed;

  StatusArrays({this.pending, this.completed});

  StatusArrays.fromJson(Map<String, dynamic> json) {
    pending = json['Pending'];
    completed = json['Completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Pending'] = this.pending;
    data['Completed'] = this.completed;
    return data;
  }
}
