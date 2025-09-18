class LoginResponseModel {
  String? token;
  int? id;
  String? userName;
  String? email;
  Userinfo? userinfo;
  String? message;
  int? resetPassword;

  LoginResponseModel({
    this.token,
    this.id,
    this.userName,
    this.email,
    this.userinfo,
    this.message,
    this.resetPassword,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        token: json["token"],
        id: json["id"],
        userName: json["user_name"],
        email: json["email"],
        userinfo: json["userinfo"] == null
            ? null
            : Userinfo.fromJson(json["userinfo"]),
        message: json["message"],
        resetPassword: json["reset_password"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "id": id,
        "user_name": userName,
        "email": email,
        "userinfo": userinfo?.toJson(),
        "message": message,
        "reset_password": resetPassword,
      };
}

class Userinfo {
  String? id;
  String? userId;
  String? roleId;
  String? role;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? addressline1;
  String? addressline2;
  String? addressline3;
  String? city;
  String? state;
  String? country;
  String? zipcode;
  String? avatar;
  String? status;
  int? isTechHead;
  String? uniqueId;

  Userinfo({
    this.id,
    this.userId,
    this.roleId,
    this.role,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.addressline1,
    this.addressline2,
    this.addressline3,
    this.city,
    this.state,
    this.country,
    this.zipcode,
    this.avatar,
    this.status,
    this.isTechHead,
    this.uniqueId,
  });

  factory Userinfo.fromJson(Map<String, dynamic> json) => Userinfo(
        id: json["id"],
        userId: json["user_id"],
        roleId: json["role_id"],
        role: json["role"],
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        addressline1: json["addressline1"],
        addressline2: json["addressline2"],
        addressline3: json["addressline3"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        zipcode: json["zipcode"],
        avatar: json["avatar"],
        status: json["status"],
        isTechHead: json["is_tech_head"],
        uniqueId: json["unique_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "role_id": roleId,
        "role": role,
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "addressline1": addressline1,
        "addressline2": addressline2,
        "addressline3": addressline3,
        "city": city,
        "state": state,
        "country": country,
        "zipcode": zipcode,
        "avatar": avatar,
        "status": status,
        "is_tech_head": isTechHead,
        "unique_id": uniqueId,
      };
}

class LoginInput {
  String? username;
  String? password;
  String? token;
  String? contractCode;
  String? isAndriod;

  LoginInput({
    this.username,
    this.password,
    this.token,
    this.contractCode,
    this.isAndriod,
  });

  factory LoginInput.fromJson(Map<String, dynamic> json) => LoginInput(
        username: json["username"],
        password: json["password"],
        token: json["token"],
        contractCode: json["contract_code"],
        isAndriod: json["IsAndriod"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "token": token,
        "contract_code": contractCode,
        "IsAndriod": isAndriod,
      };
}
