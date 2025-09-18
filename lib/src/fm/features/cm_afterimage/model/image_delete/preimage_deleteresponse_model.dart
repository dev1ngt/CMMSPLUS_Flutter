class RemovalPostResponse {
  String status;
  String message;

  RemovalPostResponse({required this.status, required this.message});

  factory RemovalPostResponse.fromJson(Map<String, dynamic> json) {
    return RemovalPostResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}