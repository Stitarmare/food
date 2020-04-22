import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:foodzi/EnterMobileNoOTP/EnterOTPScreenPresenter.dart';
import 'package:foodzi/EnterMobileNoOTP/EnterOtpContractor.dart';
import 'package:foodzi/Otp/OtpView.dart';
import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/Utils/dialogs.dart';
import 'package:foodzi/theme/colors.dart';
import 'package:foodzi/widgets/AppTextfield.dart';
import 'package:keyboard_actions/keyboard_action.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:progress_dialog/progress_dialog.dart';

class EnterOTPScreen extends StatefulWidget {
  int flag = 0;
  EnterOTPScreen({this.flag});
  @override
  State<StatefulWidget> createState() {
    return EnterOTPScreenState();
  }
}

class EnterOTPScreenState extends State<EnterOTPScreen>
    implements EnterOTPModelView {
  static String mobno = KEY_MOBILE_NUMBER;

  final GlobalKey<FormState> _enterOTPFormKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  DialogsIndicator dialogs = DialogsIndicator();
  final FocusNode _nodeText1 = FocusNode();
  ProgressDialog progressDialog;

  bool _validate = false;
  final Map<String, dynamic> _enterOTP = {
    mobno: null,
  };
  var _mobileNumber;
  var countrycode = '+91';
  var enterOTPScreenPresenter;
  @override
  void initState() {
    enterOTPScreenPresenter = EnterOTPScreenPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white70,
        ),
        body: Center(
          child: KeyboardActions(
            config: _buildConfig(context),
            child: SingleChildScrollView(
              child: mainview(),
            ),
          ),
        ));
  }

  Widget mainview() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[_buildStackView()],
      ),
    );
  }

  Widget _buildStackView() {
    return Stack(
      children: <Widget>[
        _buildmainview(),
      ],
    );
  }

  Future<void> onsubmitButtonClicked() async {
    if (_enterOTPFormKey.currentState.validate()) {
      if (widget.flag == 1) {
        //DialogsIndicator.showLoadingDialog(context, _keyLoader, "");
        await progressDialog.show();
        this.enterOTPScreenPresenter.requestForOTP(_mobileNumber,countrycode, context);
      } else if (widget.flag == 2) {
        //DialogsIndicator.showLoadingDialog(context, _keyLoader, "");
        await progressDialog.show();
        this.enterOTPScreenPresenter.requestforloginOTP(_mobileNumber,countrycode, context);
        _enterOTPFormKey.currentState.save();
      }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  Widget _buildmainview() {
    return LimitedBox(
      child: Container(
        child: Column(
          children: <Widget>[
            Form(
              key: _enterOTPFormKey,
              autovalidate: _validate,
              child: Column(
                children: <Widget>[
                  _buildImagelogo(),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Text(
                      KEY_GET_OTP_ENTER_NO,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          fontFamily: KEY_FONT_SEGOEUI,
                          fontWeight: FontWeight.w400,
                          fontSize: FONTSIZE_18,
                          color: greytheme200),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(150, 0, 150, 0),
                  ),
                  SizedBox(height: 45),
                  Row(children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: greentheme100),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: CountryCodePicker(
                          onChanged: (text) {
                            countrycode = text.toString();
                          },
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: '+91',
                          favorite: ['+91', 'IN'],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: false,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        ),
                      ),
                      // AppTextField(
                      //   icon: Icon(
                      //     Icons.language,
                      //     color: greentheme100,
                      //   ),
                      //   keyboardType: TextInputType.phone,
                      //   placeHolderName: STR_CODE,
                      //   onChanged: (text) {
                      //     if (text.contains('+')) {
                      //       countrycode = text;
                      //     } else {
                      //       countrycode = "+" + text;
                      //     }
                      //   },
                      //   validator: validatecountrycode,
                      // ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 4,
                      child: AppTextField(
                        onChanged: (text) {
                          this._mobileNumber = text;
                        },
                        keyboardType: TextInputType.phone,
                        focusNode: _nodeText1,
                        icon: Icon(
                          Icons.call,
                          color: greentheme100,
                        ),
                        placeHolderName: KEY_MOBILE_NUMBER,
                        validator: validatemobno,
                        onSaved: (String value) {
                          _enterOTP[mobno] =   value;
                        },
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 90,
                  ),
                  _submitButtonClicked(),
                ],
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget _buildImagelogo() {
    return Column(
      children: <Widget>[
        Image.asset(OTP_LOGO_PATH),
      ],
    );
  }

  String validatemobno(String value) {
    String pattern = STR_VALIDATE_MOB_NO;
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return KEY_MOBILE_NUMBER_REQUIRED;
    } else if (!regExp.hasMatch(value)) {
      return KEY_MOBILE_NUMBER_TEXT;
    } else if (value.length > 13) {
      return KEY_MOBILE_NUMBER_LIMIT;
    }
    if (value.isEmpty) {
      return KEY_THIS_SHOULD_NOT_BE_EMPTY;
    }
    return null;
  }

  String validatecountrycode(String value) {
    String pattern = STR_VALIDATE_COUNTRY_CODE;
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      return KEY_COUNTRYCODE_REQUIRED;
    } else if (value.length > 4) {
      return KEY_COUNTRY_CODE_LIMIT;
    } else if (!value.startsWith('+')) {
      if (!regExp.hasMatch(value)) {
        return KEY_COUNTRY_CODE_TEXT;
      }
    }
    return null;
  }

  Widget _submitButtonClicked() {
    return ButtonTheme(
      minWidth: 280,
      height: 54,
      child: RaisedButton(
        color: greentheme100,
        onPressed: () => onsubmitButtonClicked(),
        child: Text(
          KEY_SUBMIT_BUTTON,
          style: TextStyle(
              fontSize: FONTSIZE_16,
              fontFamily: KEY_FONTFAMILY,
              fontWeight: FontWeight.w700),
        ),
        textColor: Colors.white,
        textTheme: ButtonTextTheme.normal,
        splashColor: Color.fromRGBO(72, 189, 111, 0.80),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(32.0),
            side: BorderSide(color: Color.fromRGBO(72, 189, 111, 0.80))),
      ),
    );
  }

  @override
  Future<void> onRequestOtpFailed() async {
    await progressDialog.hide();
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  @override
  Future<void> onRequestOtpSuccess() async {
    await progressDialog.hide();
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => OTPScreen(
              mobno: _mobileNumber,
              countryCode:countrycode,
              isFromFogetPass: false,
              value: 0,
            )));
  }

  @override
  Future<void> requestforloginotpfailed() async {
    await progressDialog.hide();
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
  }

  @override
  Future<void> requestforloginotpsuccess() async {
    await progressDialog.hide();
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => OTPScreen(
          countryCode:countrycode,
              mobno: _mobileNumber,
              isFromFogetPass: true,
              value: 1,
            )));
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: false,
      actions: [
        KeyboardAction(
          focusNode: _nodeText1,
          closeWidget: Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(STR_DONE),
          ),
        ),
      ],
    );
  }
}
