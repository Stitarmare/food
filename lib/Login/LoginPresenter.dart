import 'package:flutter/material.dart';
import 'package:foodzi/Login/LoginContractor.dart';
import 'package:foodzi/network/ApiBaseHelper.dart';
import 'package:foodzi/network/url_constant.dart';
import 'package:foodzi/Utils/globle.dart';
import 'package:foodzi/Utils/shared_preference.dart';

class LoginPresenter extends LoginContract {
  LoginModelView mLoginView;

  LoginPresenter(LoginModelView mView) {
    this.mLoginView = mView;
  }

  @override
  void onBackPresed() {}

  @override
  void performLogin(String mobno, String password, BuildContext context) {
    ApiBaseHelper().post(UrlConstant.loginApi, context,
        body: {'mobile_number': mobno, 'password': password}).then((value) {
     if (value['status_code']==200) {
        mLoginView.loginSuccess();
     }
      mLoginView.loginSuccess();
    });
//ApiCall
    //;
  }
}
