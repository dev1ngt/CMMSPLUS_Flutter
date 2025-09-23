class Contract {
  bool isError;
  String message;
  Data data;

  Contract({
    required this.isError,
    required this.message,
    required this.data,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      isError: json['IsError'],
      message: json['Message'],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IsError': isError,
      'Message': message,
      'data': data.toJson(),
    };
  }
}

class Data {
  int status;
  String contractCode;
  String contractorName;
  String url;
  String webRoute;
  String apiRoute;
  String database;

  Data({
    required this.status,
    required this.contractCode,
    required this.contractorName,
    required this.url,
    required this.webRoute,
    required this.apiRoute,
    required this.database,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      status: json['status'],
      contractCode: json['contract_code'],
      contractorName: json['contractor_name'],
      url: json['url'],
      webRoute: json['web_route'],
      apiRoute: json['api_route'],
      database: json['database'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'contract_code': contractCode,
      'contractor_name': contractorName,
      'url': url,
      'web_route': webRoute,
      'api_route': apiRoute,
      'database': database,
    };
  }
}