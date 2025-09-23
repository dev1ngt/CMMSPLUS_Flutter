class LoginResponseModelFM {
  final String? status;
  final String? message;
  final UserDatas? data;

  LoginResponseModelFM({ this.status,  this.message,  this.data});

  factory LoginResponseModelFM.fromJson(Map<String, dynamic> json) {
    return LoginResponseModelFM(
      status: json['status'],
      message: json['message'],
      data: UserDatas.fromJson(json['data']),
    );
  }
}

class UserDatas {
  final String token;
  final int userId;
  final String userName;
  final String xAuthClient;
  final int employeeId;

  UserDatas({
    required this.token,
    required this.userId,
    required this.userName,
    required this.xAuthClient,
    required this.employeeId,
  });

  factory UserDatas.fromJson(Map<String, dynamic> json) {
    return UserDatas(
      token: json['token'],
      userId: json['userId'],
      userName: json['userName'],
      xAuthClient: json['x-auth-client'],
      employeeId: json['employee_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    "token": token,
    "userId": userId,
    "userName": userName,
    "x-auth-client": xAuthClient,
    "employee_id": employeeId,
  };
}
class LoginInputFM {
  String? username;
  String? password;
  String? token;
  String? isAndriod;

  LoginInputFM({
    this.username,
    this.password,
    this.token,
    this.isAndriod,
  });

  factory LoginInputFM.fromJson(Map<String, dynamic> json) => LoginInputFM(
    username: json["username"],
    password: json["password"],
    token: json["token"],
    isAndriod: json["IsAndriod"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "token": token,
    "IsAndriod": isAndriod,
  };
}
