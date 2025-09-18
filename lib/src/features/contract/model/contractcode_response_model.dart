class ContractCodeResponseModel {
  ContractCodeResponseModel({
    required this.isError,
    required this.message,
    required this.data,
  });

  final bool? isError;
  final String? message;
  final Data? data;

  factory ContractCodeResponseModel.fromJson(Map<String, dynamic> json){
    return ContractCodeResponseModel(
      isError: json["IsError"],
      message: json["Message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.status,
    required this.contractCode,
    required this.contractorName,
    required this.url,
    required this.webRoute,
    required this.apiRoute,
    required this.database,
  });

  final int? status;
  final String? contractCode;
  final String? contractorName;
  final String? url;
  final String? webRoute;
  final String? apiRoute;
  final String? database;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      status: json["status"],
      contractCode: json["contract_code"],
      contractorName: json["contractor_name"],
      url: json["url"],
      webRoute: json["web_route"],
      apiRoute: json["api_route"],
      database: json["database"],
    );
  }

}

/*
class ContractCodeResponseModel {
  final String msg;
  final int status;
  final Data data;

  ContractCodeResponseModel({required this.msg, required this.status, required this.data});

  factory ContractCodeResponseModel.fromJson(Map<String, dynamic> json) {
    return ContractCodeResponseModel(
      msg: json['msg'] as String,
      status: json['status'] as int,
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'status': status,
      'data': data.toJson(),
    };
  }
}

class Data {
  final String endpoint;

  Data({required this.endpoint});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      endpoint: json['endpoint'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'endpoint': endpoint,
    };
  }
}*/
