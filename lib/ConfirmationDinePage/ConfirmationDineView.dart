import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodzi/CartDetailsPage/CartDetailsPage.dart';
import 'package:foodzi/ConfirmationDinePage/ConfirmationDineViewContractor.dart';
import 'package:foodzi/ConfirmationDinePage/ConfirmationDineviewPresenter.dart';
import 'package:foodzi/LandingPage/LandingView.dart';
import 'package:foodzi/Models/GetPeopleListModel.dart';
import 'package:foodzi/Models/InvitePeopleModel.dart';
import 'package:foodzi/Models/MenuCartDisplayModel.dart';
import 'package:foodzi/Models/OrderStatusModel.dart';
import 'package:foodzi/Models/PlaceOrderModel.dart';
import 'package:foodzi/Models/error_model.dart';
import 'package:foodzi/PaymentTipAndPay/PaymentTipAndPay.dart';
import 'package:foodzi/PaymentTipAndPay/PaymentTipAndPayContractor.dart';
import 'package:foodzi/PaymentTipAndPay/PaymentTipAndPayPresenter.dart';
import 'package:foodzi/StatusTrackPage/StatusTrackViewContractor.dart';
import 'package:foodzi/StatusTrackPage/StatusTrackViewPresenter.dart';
import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/Utils/constant.dart';
import 'package:foodzi/Utils/dialogs.dart';
import 'package:foodzi/Utils/globle.dart';
import 'package:foodzi/Utils/shared_preference.dart';
import 'package:foodzi/theme/colors.dart';
import 'package:foodzi/widgets/GeoLocationTracking.dart';
import 'package:foodzi/widgets/RadioDialogAddPeople.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmationDineView extends StatefulWidget {
  String restName;
  int price;
  int restId;
  int userId;
  String orderType;
  int tableId;
  String tablename;
  List<int> items;
  double totalAmount;
  String latitude;
  String longitude;
  String currencySymbol;
  String imgUrl;
  List<MenuCartList> itemdata;
  ConfirmationDineView(
      {this.userId,
      this.price,
      this.items,
      this.restId,
      this.latitude,
      this.tablename,
      this.longitude,
      this.orderType,
      this.tableId,
      this.totalAmount,
      this.itemdata,
      this.restName,
      this.currencySymbol,
      this.imgUrl});
  @override
  _ConfirmationDineViewState createState() => _ConfirmationDineViewState();
}

class _ConfirmationDineViewState extends State<ConfirmationDineView>
    with TickerProviderStateMixin
    implements
        PaymentTipAndPayModelView,
        ConfirmationDineViewModelView,
        StatusTrackViewModelView {
  int i;
  bool isselected = false;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  DialogsIndicator dialogs = DialogsIndicator();
  List<RadioButtonOrderOptions> _orderOptions = [
    RadioButtonOrderOptions(
        index: 1, title: STR_DINEIN_TITLE, subtitle: STR_SERVED_RESTAUTRANT),
    RadioButtonOrderOptions(
        index: 2, title: STR_COLLECTION, subtitle: STR_ORDER_TO_COLLECT),
  ];
  StatusTrackViewPresenter statusTrackViewPresenter;
  List<PeopleData> peopleList = [];
  List<InvitePeopleList> invitePeopleList = [];
  ConfirmationDineviewPresenter confirmationDineviewPresenter;
  List<RadioButtonOptions> _radioOptions = [
    RadioButtonOptions(index: 1, title: STR_ASAP),
    RadioButtonOptions(index: 2, title: STR_WITHIN_1_HOUR),
    RadioButtonOptions(index: 3, title: STR_WITHIN_2_HOUR),
    RadioButtonOptions(index: 4, title: STR_WITHIN_3_HOUR),
  ];
  PaymentTipAndPayPresenter _paymentTipAndPayPresenter;
  ScrollController _controller = ScrollController();
  int id = 1;
  int radioId = 1;
  int radioOrderId = 1;
  String radioItem;
  String radioOrderItem;
  String radioOrderItemsub;
  int cartId;
  OrderData myOrderData;
  PlaceOrderModel placeOrderModel;
  ProgressDialog progressDialog;
  Position _position;
  var getttingLocation = false;
  StreamController<Position> _controllerPosition = new StreamController();
  String strTotalAmount = "";
  GlobalKey _scaffold = GlobalKey();
  bool isLoader = false;

  @override
  void initState() {
    _paymentTipAndPayPresenter = PaymentTipAndPayPresenter(this);
    confirmationDineviewPresenter = ConfirmationDineviewPresenter(this);
    statusTrackViewPresenter = StatusTrackViewPresenter(this);
    statusTrackViewPresenter.getInvitedPeople(
        Globle().loginModel.data.id, widget.tableId, context);
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog.style(message: STR_LOADING);
    print(widget.tableId);

    strTotalAmount = (widget.totalAmount).toStringAsFixed(2);
    Preference.getPrefValue<String>("tableName").then((tableName) {
      if (tableName != null) {
        if (widget.tablename == null) {
          setState(() {
            widget.tablename = tableName;
          });
        }
      }
    });
    //_getLocation();
    super.initState();
  }

  _getLocation() async {
    setState(() {
      getttingLocation = false;
    });
    //await progressDialog.show();
    GeoLocationTracking.load(context, _controllerPosition);
    _controllerPosition.stream.listen((position) async {
      print(position);
      _position = position;
      if (_position != null) {
        setState(() {
          getttingLocation = true;
        });
        widget.latitude = _position.latitude.toString();
        widget.longitude = _position.longitude.toString();
      } else {
        setState(() {
          getttingLocation = false;
        });
      }
      //await progressDialog.hide();
    }, onError: (error) {
      setState(() {
        getttingLocation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      top: false,
      right: false,
      child: Scaffold(
        key: _scaffold,
        appBar: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          title: Text(widget.restName),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(children: <Widget>[
          CustomScrollView(
            controller: _controller,
            slivers: <Widget>[
              // _getorderOptions(),
              _gettableText(),
              // radioId == 1 ? _gettableText() : _gettimeOptions(),
            ],
          ),
          isLoader
              ? SpinKitFadingCircle(
                  color: Globle().colorscode != null
                      ? getColorByHex(Globle().colorscode)
                      : orangetheme300,
                  size: 50.0,
                  controller: AnimationController(
                      vsync: this,
                      duration: const Duration(milliseconds: 1200)),
                )
              : Text("")
        ]),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.1,
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // Container(
                //   height: 10,
                // ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 54,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      STR_CONFIRM_PLACE_ORDER,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: FONTSIZE_16,
                          fontFamily: Constants.getFontType(),
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    color: getColorByHex(Globle().colorscode),
                    onPressed: () {
                      onPressConfirmButton();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onPressConfirmButton() async {
    if (radioOrderId == 2) {
      Globle().takeAwayCartItemCount = 0;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentTipAndPay(
                    flag: 2,
                    restName: widget.restName,
                    restId: widget.restId,
                    userId: Globle().loginModel.data.id,
                    items: widget.items,
                    totalAmount: widget.totalAmount,
                    orderType: STR_TAKE_AWAY,
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                    itemdata: widget.itemdata,
                    currencySymbol: widget.currencySymbol,
                  )));
    } else if (radioOrderId == 1) {
      // DialogsIndicator.showLoadingDialog(
      //     context, _keyLoader, STR_LOADING);
      //showAlertSuccess(STR_ORDER_PLACED, STR_ORDER_SUCCESS, context);
      callapiPLaceorder();
    }
  }

  callapiPLaceorder() {
    // progressDialog.show();
    setState(() {
      isLoader = true;
    });
    _paymentTipAndPayPresenter.placeOrder(
        widget.restId,
        Globle().loginModel.data.id,
        widget.orderType,
        widget.tableId,
        widget.items,
        widget.totalAmount,
        widget.latitude,
        widget.longitude,
        context);
  }

  String getExtra(MenuCartList menuCartList) {
    var extras = STR_BLANK;
    for (int i = 0; i < menuCartList.cartExtraItems.length; i++) {
      if (menuCartList.cartExtraItems[i].spreads.length > 0) {
        for (int j = 0;
            j < menuCartList.cartExtraItems[i].spreads.length;
            j++) {
          extras += "${menuCartList.cartExtraItems[i].spreads[j].name}, ";
        }
      }

      if (menuCartList.cartExtraItems[i].extras.length > 0) {
        for (int j = 0; j < menuCartList.cartExtraItems[i].extras.length; j++) {
          extras += "${menuCartList.cartExtraItems[i].extras[j].name}, ";
        }
      }
      if (menuCartList.cartExtraItems[i].switches.length > 0) {
        for (int j = 0;
            j < menuCartList.cartExtraItems[i].switches.length;
            j++) {
          extras += "${menuCartList.cartExtraItems[i].switches[j].name}, ";
        }
      }
    }
    if (extras.isNotEmpty) {
      extras = removeLastChar(extras);
      extras = removeLastChar(extras);
    }
    return extras;
  }

  static String removeLastChar(String str) {
    return str.substring(0, str.length - 1);
  }

  Widget _gettableText() {
    return SliverToBoxAdapter(
      child: Container(
        // color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 10),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(STR_TABLE_NUMBER,
                      style: TextStyle(fontSize: FONTSIZE_18)),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "${widget.tablename}",
                    style: TextStyle(fontSize: FONTSIZE_18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Stack(
              fit: StackFit.passthrough,
              overflow: Overflow.visible,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add),
                    RaisedButton(
                        onPressed: () async {
                          int orderId = await Preference.getPrefValue<int>(
                              PreferenceKeys.orderId);
                          showDialog(
                              context: context,
                              child: RadioDialogAddPeople(
                                  widget.tableId, widget.restId, orderId));
                        },
                        child: Text(STR_ADD_MORE_PEOPLE)),
                  ],
                ),
                (invitePeopleList.length != null)
                    ? invitePeopleList.length > 0
                        ? Positioned(
                            top: -10,
                            right: -10,
                            child: Badge(
                                badgeColor: redtheme,
                                badgeContent: Text(
                                    "${invitePeopleList.length} ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white))))
                        : Text(
                            STR_BLANK,
                          )
                    : Text(
                        STR_BLANK,
                      ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            totalamounttext(),
          ],
        ),
      ),
    );
  }

  Widget totalamounttext() {
    return Container(
      // color: Colors.grey,
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              '${"Total  "}' + '${widget.currencySymbol}' + strTotalAmount,
              // '${widget.totalAmount}',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal),
            )
          ],
        ),
      ),
    );
  }

  Widget _gettimeOptions() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            totalamounttext(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 26, top: 10),
              child: Text(
                STR_HOW_SOON_WANT,
                style: TextStyle(
                    fontFamily: Constants.getFontType(),
                    fontSize: FONTSIZE_16,
                    color: greytheme700),
              ),
            ),
            _getRadioOptions(),
          ],
        ),
      ),
    );
  }

  Widget _getorderOptions() {
    return SliverToBoxAdapter(
      child: Container(
          margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[_getorderOption()])),
    );
  }

  _getRadioOptions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: _radioOptions
          .map((radionBtn) => Padding(
                padding: const EdgeInsets.only(top: 0),
                child: RadioListTile(
                  title: Text("${radionBtn.title}",
                      style: TextStyle(
                          fontSize: FONTSIZE_14,
                          fontFamily: Constants.getFontType(),
                          fontWeight: FontWeight.w500,
                          color: greytheme700)),
                  groupValue: id,
                  value: radionBtn.index,
                  dense: true,
                  activeColor: getColorByHex(Globle().colorscode),
                  onChanged: (val) {
                    setState(() {
                      radioItem = radionBtn.title;
                      id = radionBtn.index;
                    });
                  },
                ),
              ))
          .toList(),
    );
  }

  void getTableAlert() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          STR_SELECT_TABLE_TITLE,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: FONTSIZE_18,
              fontFamily: Constants.getFontType(),
              fontWeight: FontWeight.w600,
              color: greytheme700),
        ),
        actions: <Widget>[
          Divider(
            endIndent: 15,
            indent: 15,
            color: Colors.black,
          ),
          FlatButton(
            child: Text(STR_OK),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  _getorderOption() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: _orderOptions
          .map((radionOrderBtn) => Padding(
                padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: RadioListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 16),
                      child: Text("${radionOrderBtn.title}",
                          style: TextStyle(
                              fontSize: FONTSIZE_20,
                              fontFamily: Constants.getFontType(),
                              fontWeight: FontWeight.w600,
                              color: getColorByHex(Globle().colorscode))),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text("${radionOrderBtn.subtitle}",
                          style: TextStyle(
                              fontSize: FONTSIZE_14,
                              fontFamily: Constants.getFontType(),
                              fontWeight: FontWeight.w500,
                              color: greytheme100)),
                    ),
                    groupValue: radioOrderId,
                    value: radionOrderBtn.index,
                    dense: true,
                    activeColor: getColorByHex(Globle().colorscode),
                    onChanged: (val) {
                      setState(() {
                        radioOrderItem = radionOrderBtn.title;
                        radioOrderItemsub = radionOrderBtn.subtitle;
                        radioOrderId = radionOrderBtn.index;
                        radioId = val;
                      });
                    },
                  ),
                ),
              ))
          .toList(),
    );
  }

  void showAlertSuccess(String title, String message, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontFamily: Constants.getFontType(),
                fontWeight: FontWeight.w600,
                color: greytheme700),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Image.asset(
              SUCCESS_IMAGE_PATH,
              width: 75,
              height: 75,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: FONTSIZE_15,
                  fontFamily: Constants.getFontType(),
                  fontWeight: FontWeight.w500,
                  color: greytheme700),
            )
          ]),
          actions: <Widget>[
            Divider(
              endIndent: 15,
              indent: 15,
              color: Colors.black,
            ),
            FlatButton(
              child: Text(STR_OK,
                  style: TextStyle(
                      fontSize: FONTSIZE_16,
                      fontFamily: Constants.getFontType(),
                      fontWeight: FontWeight.w600,
                      color: greytheme700)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CartDetailsPage(
                          orderId: myOrderData.id,
                          flag: 3,
                          isFromOrder: false,
                        )));
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
                // Navigator.of(context).pop();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //         BottomTabbarHome(
                //           title: widget.restName,
                //           restId: widget.restId,
                //           lat:widget.latitude,
                //           long: widget.longitude,
                //           tableName: widget.tablename,
                //           imageUrl:widget.imgUrl ,
                //         )
                //         // BottomTabbarHome(
                //         //       title: _restaurantList[i].restName,
                //         //       restId: _restaurantList[i].id,
                //         //       lat: _restaurantList[i].latitude,
                //         //       long: _restaurantList[i].longitude,
                //         //       imageUrl: _restaurantList[i].coverImage,
                //         //       tableName: widget.tableName,
                //         //     )
                //         // StatusTrackView(
                //         //       tableId: widget.tableId,
                //         //       orderID: myOrderData.id,
                //         //       title: widget.restName,
                //         //       tableName: widget.tablename,
                //         //       flag: 1,
                //         //     )
                //             ));
              },
            )
          ],
        ),
      ),
    );
  }

  void showAlertTableStatus(
      String title, String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  Divider(
                    endIndent: 15,
                    indent: 15,
                    color: Colors.black,
                  ),
                  FlatButton(
                    child: Text(STR_OK_TITLE),
                    onPressed: () {
                      Navigator.of(context).pop();
                      confirmationDineviewPresenter.sentInvitRequest(
                          widget.tableId,
                          widget.restId,
                          _scaffold.currentContext);
                    },
                  ),
                  FlatButton(
                    child: Text(STR_CANCEL),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await progressDialog.hide();
                    },
                  ),
                ],
              ),
            ));
  }

  @override
  Future<void> placeOrderfailed() async {
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
    await progressDialog.hide();
    Preference.setPersistData(null, PreferenceKeys.restaurantID);
    Preference.setPersistData(null, PreferenceKeys.isAlreadyINCart);
    //await progressDialog.hide();
    setState(() {
      isLoader = false;
    });
  }

  @override
  void placeOrdersuccess(OrderData orderData, PlaceOrderModel model) async {
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
    await progressDialog.hide();
    await progressDialog.hide();
    setState(() {
      isLoader = false;
    });

    if (model != null) {
      setState(() {
        placeOrderModel = model;
      });
      if (placeOrderModel.userId == null && placeOrderModel.tableBook == true) {
        Constants.showAlert("Table Status", placeOrderModel.message, context);
      } else if (placeOrderModel.tableBook == true) {
        String message = placeOrderModel.message + STR_REQUEST_TBL_MSG;
        // Constants.showAlert("Table Status", placeOrderModel.message, context);
        showAlertTableStatus(STR_TABLE_STATUS_TITLE, message, context);
      } else {
        setState(() {
          if (myOrderData == null) {
            myOrderData = orderData;
          }
        });
        Globle().isTabelAvailable = true;
        Globle().tableID = widget.tableId;
        Preference.setPersistData<int>(widget.tableId, PreferenceKeys.tableId);
        Preference.setPersistData<int>(
            widget.restId, PreferenceKeys.restaurantID);
        Preference.setPersistData<bool>(false, PreferenceKeys.isAlreadyINCart);
        Preference.setPersistData<int>(orderData.id, PreferenceKeys.orderId);
        Globle().orderID = orderData.id;
        Preference.setPersistData<int>(0, PreferenceKeys.dineCartItemCount);
        Globle().orderNumber = orderData.orderNumber;
        Globle().dinecartValue = 0;
        Preference.removeForKey(PreferenceKeys.dineCategoryId);
        Preference.removeForKey(PreferenceKeys.dineSubCatId);
        Preference.removeForKey(PreferenceKeys.categoryDineRestId);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CartDetailsPage(
                  orderId: myOrderData.id,
                  flag: 3,
                  isFromOrder: false,
                )));
        // showAlertSuccess(STR_ORDER_PLACED, STR_ORDER_SUCCESS, context);
      }
    }
  }

  @override
  void addPeopleFailed() {}

  @override
  void addPeopleSuccess() {}

  @override
  void getPeopleListonFailed() {}

  @override
  void getPeopleListonSuccess(List<PeopleData> data) {}

  @override
  void getInvitedPeopleFailed() {}

  @override
  void getInvitedPeopleSuccess(List<InvitePeopleList> list) {
    if (list.length == 0) {
      return;
    }

    setState(() {
      if (invitePeopleList == null) {
        invitePeopleList = list;
      } else {
        invitePeopleList.addAll(list);
      }
    });
    print(invitePeopleList[0].toUser.firstName);
  }

  @override
  void getOrderStatusfailed() {}

  @override
  void getOrderStatussuccess(StatusData statusData) {}

  @override
  void inviteRequestFailed(ErrorModel model) async {
    await progressDialog.hide();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainWidget()),
        ModalRoute.withName("/MainWidget"));
  }

  @override
  void inviteRequestSuccess(String message) async {
    await progressDialog.hide();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainWidget()),
        ModalRoute.withName("/MainWidget"));

    // Constants.showAlertSuccess("Success", message, context);
  }
}

class RadioButtonOptions {
  int index;
  String title;
  RadioButtonOptions({this.index, this.title});
}

class RadioButtonOrderOptions {
  int index;
  String title;
  String subtitle;
  RadioButtonOrderOptions({this.index, this.title, this.subtitle});
}
