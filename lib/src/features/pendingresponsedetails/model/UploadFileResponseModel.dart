


class UploadFileResponseModel {
  String? error;
  String? message;
  bool? status;
  String? uploadedpath;

  UploadFileResponseModel(
      {this.error, this.message, this.status, this.uploadedpath});

  UploadFileResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    status = json['status'];
    uploadedpath = json['uploadedpath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['status'] = this.status;
    data['uploadedpath'] = this.uploadedpath;
    return data;
  }
}