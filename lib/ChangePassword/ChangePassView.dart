import 'package:flutter/material.dart';
//import 'package:foodzi/ResetPassword/ResetPassPresenter.dart';
//import 'package:foodzi/ResetPassword/ResetpassContractor.dart';
import 'dart:math' as math;

import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/theme/colors.dart';
import 'package:foodzi/widgets/AppTextfield.dart';

class ChangePasswordview extends StatefulWidget {
  var mobno;
  ChangePasswordview({this.mobno});
  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordview();
  }
}

class _ChangePasswordview extends State<ChangePasswordview> {
  static String enterOldPass = KEY_ENTER_OLD_PASSWORD;
  static String enterNewPass = KEY_ENTER_NEW_PASSWORD;
  static String enterConfirmPass = KEY_CONFIRM_PASSWORD;

  final GlobalKey<FormState> _changepasswordFormKey = GlobalKey<FormState>();

  bool _validate = false;

  // final Map<String, dynamic> _signInData = {
  //   enterOldPass:null,
  //   enterNewPass: null,
  //   enterConfirmPass: null,
  // };

  var resetpasswordPresenter;
  var _oldPassword;
  var _newPassword;
  var _confirmPassword;

  @override
  void initState() {
    // TODO: implement initState
    // resetpasswordPresenter = ResetpasswordPresenter(this);
    // super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white70,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: mainview(),
          ),
        ));
  }

  Widget mainview() {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
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

  void onsubmitButtonClicked() {
    // if (_resetpasswordFormKey.currentState.validate()) {
    //   //resetpasswordPresenter.perfromresetpassword(
    //       //widget.mobno, _password, context);
    //   //_resetpasswordFormKey.currentState.save();
    //   //Navigator.pushNamed(context, '/Landingview');
    // } else {
    //   setState(() {
    //     _validate = true;
    //   });
    // }
  }

  Widget _buildmainview() {
    return LimitedBox(
      child: Container(
        child: Column(
          children: <Widget>[
            Form(
              key: _changepasswordFormKey,
              autovalidate: _validate,
              child: Column(
                children: <Widget>[
                  _buildImagelogo(),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Change Your Password',
                    style: TextStyle(
                        fontFamily: 'gotham',
                        color: greytheme300,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildTextField(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(150, 0, 150, 0),
                  ),
                  SizedBox(
                    height: 78,
                  ),
                  _submitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagelogo() {
    return Column(
      children: <Widget>[
        Image.asset('assets/LockImage/Group_1560.png'
            //height: 100,
            ),
      ],
    );
  }

  Widget _buildTextField() {
    const pi = 3.14;
    return Column(
      children: <Widget>[
        AppTextField(
          onChanged: (text) {
            _oldPassword = text;
          },
          obscureText: true,
          placeHolderName: KEY_ENTER_OLD_PASSWORD,
          icon: Transform.rotate(
            angle: 360 * pi / 95,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Icon(
                Icons.vpn_key,
                color: greentheme100,
              ),
            ),
          ),
          validator: validatepassword,
          onSaved: (String value) {
            //_signInData[enterPass] = value;
          },
        ),
        SizedBox(height: 15),
        AppTextField(
          onChanged: (text) {
            _newPassword = text;
          },
          obscureText: true,
          placeHolderName: KEY_ENTER_NEW_PASSWORD,
          icon: Transform.rotate(
            angle: 360 * pi / 95,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Icon(
                Icons.vpn_key,
                color: greentheme100,
              ),
            ),
          ),
          validator: validatepassword,
          onSaved: (String value) {
            //_signInData[enterPass] = value;
          },
        ),
        SizedBox(height: 15),
        AppTextField(
          onChanged: (text) {
            _confirmPassword = text;
          },
          obscureText: true,
          placeHolderName: KEY_CONFIRM_PASSWORD,
          icon: Transform.rotate(
            angle: 360 * pi / 95,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Icon(
                Icons.vpn_key,
                color: greentheme100,
              ),
            ),
          ),
          validator: validatConfirmPassword,
          onSaved: (String value) {
            // _signInData[enterPass] = value;
            // print('Details are : $_signInData');
          },
        ),
      ],
    );
  }

  String validatepassword(String value) {
    if (value.length == 0) {
      return KEY_PASSWORD_REQUIRED;
    } else if (value.length < 8) {
      return KEY_THIS_SHOULD_BE_MIN_8_CHAR_LONG;
    }
    return null;
  }

  String validatConfirmPassword(String value) {
    // if (value == _newPassword) {
      if (value.length == 0) {
        return KEY_PASSWORD_REQUIRED;
      } else if (value.length < 8) {
        return KEY_THIS_SHOULD_BE_MIN_8_CHAR_LONG;
      }
    // }
    return null;
  }

  Widget _submitButton() {
    return ButtonTheme(
      minWidth: 280,
      height: 54,
      child: RaisedButton(
        color: greentheme100,
        onPressed: () {
          if (_changepasswordFormKey.currentState.validate()) {
             showDialogBox(context);
            //resetpasswordPresenter.perfromresetpassword(
            //widget.mobno, _password, context);
            //_resetpasswordFormKey.currentState.save();
            //Navigator.pushNamed(context, '/Landingview');
          } else {
            setState(() {
              _validate = true;
            });
          }
        },
        child: Text(
          KEY_SUBMIT_BUTTON,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'gotham'),
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

  // @override
  // void resetpassfailed() {
  //   // TODO: implement resetpassfailed
  // }

  // @override
  // void resetpasssuccess() {
  //   Navigator.of(context).pushReplacementNamed('/LoginView');
  // }
    showDialogBox(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Change Password",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: greentheme100,
              fontWeight: FontWeight.w600,
              fontFamily: 'gotham',
              fontSize: 22),
        ),
        content: Text(
          _newPassword == _confirmPassword
              ? 'Your password has been successfully change. '
              : 'Password does not match with confirm password.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: greytheme100,
              fontWeight: FontWeight.w500,
              fontFamily: 'gotham',
              fontSize: 20),
        ),
        actions: [
          FlatButton(
            child: const Text(
              "OK",
              style: TextStyle(
                  color: greentheme100,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'gotham',
                  fontSize: 20),
            ),
            onPressed: () {
              _newPassword == _confirmPassword
                  ? Navigator.of(context).pushReplacementNamed('/MainWidget')
                  : Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
