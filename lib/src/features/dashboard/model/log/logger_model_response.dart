class LoggerModelResponse{

  final bool status;
  final String message;

  LoggerModelResponse({
    required this.status,
    required this.message,
  });

  factory LoggerModelResponse.fromJson(Map<String, dynamic> json) {
    return LoggerModelResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}



class LoggerInput {
  int? user_id;
  String? model_name;
  String? contract_code;
  String? action_data;
  String? action_field;
  String? error_field;

  LoggerInput({
    this.user_id,
    this.model_name,
    this.contract_code,
    this.action_data,
    this.action_field,
    this.error_field,
  });

  factory LoggerInput.fromJson(Map<String, dynamic> json) => LoggerInput(
    user_id: json["user_id"],
    model_name: json["model_name"],
    contract_code: json["contract_code"],
    action_data: json["action_data"],
    action_field: json["action_field"],
    error_field: json["error_field"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": user_id,
    "model_name": model_name,
    "contract_code": contract_code,
    "action_data": action_data,
    "action_field": action_field,
    "error_field": error_field,
  };
}