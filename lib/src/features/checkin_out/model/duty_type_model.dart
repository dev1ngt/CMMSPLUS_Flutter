class DutyTypeModel {
  bool? status;
  List<DutyTypeList>? dutyTypeList;
  String? message;
  String? error;

  DutyTypeModel({this.status, this.dutyTypeList, this.message, this.error});

  DutyTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['duty_type_list'] != null) {
      dutyTypeList = <DutyTypeList>[];
      json['duty_type_list'].forEach((v) {
        dutyTypeList!.add(new DutyTypeList.fromJson(v));
      });
    }
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.dutyTypeList != null) {
      data['duty_type_list'] =
          this.dutyTypeList!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['error'] = this.error;
    return data;
  }
}

class DutyTypeList {
  int? id;
  String? duty;

  DutyTypeList({this.id, this.duty});

  DutyTypeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    duty = json['duty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['duty'] = this.duty;
    return data;
  }
}
