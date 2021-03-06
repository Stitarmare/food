import 'package:flutter/material.dart';

abstract class EnterOtpContractor {
  void requestforloginOTP(
      String mobno, String countryCode, BuildContext context);
  void requestforUpdateNoOtp(
      String mobno, String countryCode, BuildContext context);
  void onBackPresed();
}

abstract class EnterOTPModelView {
  void onRequestOtpSuccess();
  void onRequestOtpFailed();
  void requestforloginotpsuccess();
  void requestforloginotpfailed();
  void requestforUpdateNoOtpSuccess();
  void requestforUpdateNoOtpFailed();
  void onProvideOtpSuccess();
  void onProvideOtpFailed();
}
