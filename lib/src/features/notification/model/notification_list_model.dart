class NotificationList {
  final bool status;
  final String message;
  final Map<String, List<NotificationItem>> notification;
  final int notificationsCount;

  NotificationList({
    required this.status,
    required this.message,
    required this.notification,
    required this.notificationsCount,
  });

  factory NotificationList.fromJson(Map<String, dynamic> json) {
    final rawNotification = json['notification'];

    // Safely convert only if it's a Map
    final parsedNotification = (rawNotification is Map<String, dynamic>)
        ? rawNotification.map((key, value) {
      return MapEntry(
        key,
        (value as List)
            .map((item) => NotificationItem.fromJson(item))
            .toList(),
      );
    })
        : <String, List<NotificationItem>>{}; // Empty map fallback

    return NotificationList(
      status: json['status'],
      message: json['message'],
      notification: parsedNotification,
      notificationsCount: json['notifications_count'],
    );
  }

}

class NotificationItem {
  final int id;
  final int type;
  final int notifyType;
  final int notifiableId;
  final String data;
  final int nread;
  final int countRead;
  final String readby;
  final String createdAt;
  final String updatedAt;

  // Extra fields for UI display
  final bool isHeader;
  final String header;

  NotificationItem({
    required this.id,
    required this.type,
    required this.notifyType,
    required this.notifiableId,
    required this.data,
    required this.nread,
    required this.countRead,
    required this.readby,
    required this.createdAt,
    required this.updatedAt,
    this.isHeader = false,
    this.header = '',
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      type: json['type'],
      notifyType: json['notify_type'],
      notifiableId: json['notifiable_id'],
      data: json['data'],
      nread: json['nread'],
      countRead: json['count_read'],
      readby: json['readby'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  NotificationItem.asHeader(String title)
      : id = -1,
        type = 0,
        notifyType = 0,
        notifiableId = 0,
        data = '',
        nread = 1,
        countRead = 0,
        readby = '',
        createdAt = '',
        updatedAt = '',
        isHeader = true,
        header = title;

  /// Enables cloning the object with selective changes
  NotificationItem copyWith({
    int? id,
    int? type,
    int? notifyType,
    int? notifiableId,
    String? data,
    int? nread,
    int? countRead,
    String? readby,
    String? createdAt,
    String? updatedAt,
    bool? isHeader,
    String? header,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      type: type ?? this.type,
      notifyType: notifyType ?? this.notifyType,
      notifiableId: notifiableId ?? this.notifiableId,
      data: data ?? this.data,
      nread: nread ?? this.nread,
      countRead: countRead ?? this.countRead,
      readby: readby ?? this.readby,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isHeader: isHeader ?? this.isHeader,
      header: header ?? this.header,
    );
  }
}

