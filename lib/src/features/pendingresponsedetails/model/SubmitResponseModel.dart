


class SubmitResponseModel {
  String? error;
  String? message;
  bool? status;


  SubmitResponseModel(
      {this.error, this.message, this.status});

  SubmitResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    status = json['status'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}