class RemovalResponse {
  String status;
  String message;

  RemovalResponse({required this.status, required this.message});

  factory RemovalResponse.fromJson(Map<String, dynamic> json) {
    return RemovalResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}