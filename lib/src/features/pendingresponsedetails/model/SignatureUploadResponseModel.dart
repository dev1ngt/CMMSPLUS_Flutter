

class SignatureUploadResponseModel {
  String? error;
  String? message;
  bool? status;
  String? uploadedpath;

  SignatureUploadResponseModel(
      {this.error, this.message, this.status, this.uploadedpath});

  SignatureUploadResponseModel.fromJson(Map<String, dynamic> json) {
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