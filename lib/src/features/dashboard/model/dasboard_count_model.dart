class DashboardMenuVisibleResponseModel {
  final bool isError;
  final String message;
  final List<ScreenMappingMobile> screenMappingMobile;
  int notificationCount;
  int resetPassword;
  int forcedLogin;
  int fromWebLogout;
  int notificationStatus;

  DashboardMenuVisibleResponseModel({
    required this.isError,
    required this.message,
    required this.screenMappingMobile,
    required this.notificationCount,
    required this.resetPassword,
    required this.forcedLogin,
    required this.fromWebLogout,
    required this.notificationStatus,
  });

  factory DashboardMenuVisibleResponseModel.fromJson(Map<String, dynamic> json) {
    return DashboardMenuVisibleResponseModel(
      isError: json['IsError'],
      message: json['Message'],
      screenMappingMobile: (json['ScreenMapping_Mobile'] as List)
          .map((item) => ScreenMappingMobile.fromJson(item))
          .toList(),
      notificationCount: json['notification_count'],
      resetPassword: json['reset_password'],
      forcedLogin: json['forced_login'],
      fromWebLogout: json['from_web_logout'],
      notificationStatus: json['notification_status'],
    );
  }

  @override
  String toString() {
    return 'DashboardMenuVisibleResponseModel(isError: $isError, message: $message, notificationCount: $notificationCount, '
        'resetPassword: $resetPassword, forcedLogin: $forcedLogin, fromWebLogout: $fromWebLogout, notificationStatus: $notificationStatus'
        'screenMappingMobile: ${screenMappingMobile.map((item) => item.toString()).join(', ')})';
  }
}

class ScreenMappingMobile {
  final int menuID;
  final String features;
  final String groupName;
  final int status;
  final int isEdit;
  final int count;

  ScreenMappingMobile({
    required this.menuID,
    required this.features,
    required this.groupName,
    required this.status,
    required this.isEdit,
    required this.count,
  });

  factory ScreenMappingMobile.fromJson(Map<String, dynamic> json) {
    return ScreenMappingMobile(
      menuID: json['MenuID'],
      features: json['Features'],
      groupName: json['GroupName'],
      status: json['status'],
      isEdit: json['isEdit'],
      count: json['Count'],
    );
  }

  @override
  String toString() {
    return 'ScreenMappingMobile(menuID: $menuID, features: $features, groupName: $groupName, status: $status, isEdit: $isEdit, count: $count)';
  }
}