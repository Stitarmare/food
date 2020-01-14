import 'dart:async';

import 'dart:convert';

class LoginModel {
  String status;
  String token;
  int statusCode;
  Data data;

  LoginModel({
    this.status,
    this.token,
    this.statusCode,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        token: json["token"],
        statusCode: json["status_code"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "token": token,
        "status_code": statusCode,
        "data": data.toJson(),
      };
}

class Data {
  int id;
  String firstName;
  String lastName;
  dynamic email;
  String mobileNumber;
  String status;
  String userType;
  dynamic accessToken;
  String deviceToken;
  String deviceType;
  int otp;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  String colourCode;

  Data({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.mobileNumber,
    this.status,
    this.userType,
    this.accessToken,
    this.deviceToken,
    this.deviceType,
    this.otp,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.colourCode,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        status: json["status"],
        userType: json["user_type"],
        accessToken: json["access_token"],
        deviceToken: json["device_token"],
        deviceType: json["device_type"],
        otp: json["otp"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
//colourCode: json["colour_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "mobile_number": mobileNumber,
        "status": status,
        "user_type": userType,
        "access_token": accessToken,
        "device_token": deviceToken,
        "device_type": deviceType,
        "otp": otp,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
//"colour_code": colourCode,
      };
}

class RegisterModel {
  String first_name;
  String password;
  String mobno;
  String device_token;
  String device_type;
  String user_type;
  String last_name;

  RegisterModel(
      {this.mobno,
      this.password,
      this.first_name,
      this.device_token,
      this.device_type,
      this.last_name,
      this.user_type});

  factory RegisterModel.fromMap(Map<String, dynamic> json) {
    return RegisterModel(
        mobno: json["mobile_number"],
        password: json["password"],
        first_name: json['first_name']);
  }
}

class Otpviewmodel {
  String mobile_number;
  String otp;
  String device_token;
  String user_type;
  String device_type;

  Otpviewmodel({
    this.user_type,
    this.device_type,
    this.device_token,
    this.mobile_number,
  });

  factory Otpviewmodel.fromMap(Map<String, dynamic> json) {
    return Otpviewmodel(
      mobile_number: json["mobile_number"],
    );
  }
}
