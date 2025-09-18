class NotificationClearResponse {
  final bool status;
  final String message;

  NotificationClearResponse({required this.status, required this.message});

  factory NotificationClearResponse.fromJson(Map<String, dynamic> json) {
    return NotificationClearResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
