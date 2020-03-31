import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:foodzi/ConfirmationDinePage/ConfirmationDineviewPresenter.dart';
import 'package:foodzi/Models/CurrentOrderModel.dart';
import 'package:foodzi/Models/GetMyOrdersBookingHistory.dart';
import 'package:foodzi/Models/GetPeopleListModel.dart';
import 'package:foodzi/Models/OrderStatusModel.dart';
import 'package:foodzi/MyOrders/MyOrderContractor.dart';
import 'package:foodzi/MyOrders/MyOrdersPresenter.dart';
import 'package:foodzi/StatusTrackviewTakeAway.dart/StatTrackTakeContractor.dart';
import 'package:foodzi/StatusTrackviewTakeAway.dart/StatTrackTakePresenter.dart';
import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/Utils/globle.dart';
import 'package:foodzi/theme/colors.dart';

class StatusTakeAwayView extends StatefulWidget {
  int tableId;
  int orderID;
  int flag;
  int restId;
  String restname;
  String title;
  StatusTakeAwayView(
      {this.orderID,
      this.flag,
      this.restId,
      this.title,
      this.restname,
      this.tableId});
  @override
  State<StatefulWidget> createState() {
    return _StatusTakeAwayViewState();
  }
}

class _StatusTakeAwayViewState extends State<StatusTakeAwayView>
    implements StatTrackTakeModelView, MyOrderModelView {
  List<Data> peopleList = [];
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  List<CurrentOrderList> _orderDetailList;
  MyOrdersPresenter _myOrdersPresenter;
  StatTrackTakePresenter statusTrackViewPresenter;
  Duration _duration = Duration(seconds: 30);
  Timer _timer;
  StatusData statusInfo;
  ConfirmationDineviewPresenter confirmationDineviewPresenter;

  @override
  void initState() {
    super.initState();
    _myOrdersPresenter = MyOrdersPresenter(this);
    statusTrackViewPresenter = StatTrackTakePresenter(this);
    statusTrackViewPresenter.getOrderStatus(widget.orderID, context);

    _timer = Timer.periodic(_duration, (Timer t) {
      statusTrackViewPresenter.getOrderStatus(widget.orderID, context);
    });

    print(widget.tableId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      top: false,
      right: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(STR_ORDER_STATUS),
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
        body: _getmainview(),
      ),
    );
  }

  Widget _getmainview() {
    return LimitedBox(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 5.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${widget.title}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: FONTSIZE_20,
                          fontFamily: KEY_FONTFAMILY,
                          fontWeight: FontWeight.w600,
                          color: greytheme700),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    _getstatus(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              endIndent: 15,
              indent: 15,
              color: Colors.black,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                  child: Text(
                    'View Order Details',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'gotham',
                        decoration: TextDecoration.underline,
                        decorationColor: ((Globle().colorscode) != null)
                            ? getColorByHex(Globle().colorscode)
                            : orangetheme,
                        color: ((Globle().colorscode) != null)
                            ? getColorByHex(Globle().colorscode)
                            : orangetheme,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    //print(widget.tableId);
                    //DialogsIndicator.showLoadingDialog(context, _keyLoader, "");
                    _myOrdersPresenter.getOrderDetails(STR_TAKE_AWAY, context);
                    itemListDialog();
                    // showDialog(
                    //     context: context,
                    //     child:
                    //     RadioDialogAddPeople(
                    //         widget.tableId, widget.rest_id, widget.orderID));

                    // SizedBox(
                    //   height: 50,
                    // ),
                    // _billPayment(),
                  }),
            )
          ],
        ),
      ),
    );
  }

  itemListDialog() {
    return showDialog(
      context: context,
      child: Container(
        width: MediaQuery.of(context).size.height * 0.7,
        height: MediaQuery.of(context).size.height * 0.5,
        child: AlertDialog(
          title: Text("LIST OF ITEMS"),
          content: itemList(),
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
      ),
    );
  }

  Widget itemList() {
    return (_orderDetailList[0].list.isEmpty)
        ? Container(
            child: Center(
              child: Text("No items found."),
            ),
          )
        : Container(
            //margin: EdgeInsets.only(top: 15),
            width: MediaQuery.of(context).size.height * 0.7,
            height: MediaQuery.of(context).size.height * 0.35,
            child: ListView.builder(
              itemCount: getlength(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: (_orderDetailList[0]
                                          .list[index]
                                          .items
                                          .menuType ==
                                      'veg')
                                  ? Image.asset(
                                      IMAGE_VEG_ICON_PATH,
                                      height: 20,
                                      width: 20,
                                    )
                                  : Image.asset(
                                      IMAGE_VEG_ICON_PATH,
                                      height: 20,
                                      width: 20,
                                      color: redtheme,
                                    ),
                            ),
                            SizedBox(width: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Text(
                                    _orderDetailList[0]
                                            .list[index]
                                            .items
                                            .itemName ??
                                        STR_ITEM_NAME,
                                    style: TextStyle(
                                        fontSize: FONTSIZE_18,
                                        color: greytheme700),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 180,
                                  child: AutoSizeText(
                                    _orderDetailList[0]
                                            .list[index]
                                            .items
                                            .itemDescription ??
                                        STR_ITEM_DESC,
                                    style: TextStyle(
                                      color: greytheme1000,
                                      fontSize: FONTSIZE_14,
                                    ),
                                    maxFontSize: FONTSIZE_12,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                              ),
                              flex: 2,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 5, top: 15),
                              child: Text(
                                // (getTotalAmount(index) != null)
                                //     ? '\$ ${myOrderData.list[index].totalAmount}'
                                //     : STR_SEVENTEEN_TITLE,
                                _orderDetailList[0].list[index].items.price,
                                style: TextStyle(
                                    color: greytheme700,
                                    fontSize: FONTSIZE_16,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ]),
                      SizedBox(height: 6),
                      Divider(
                        height: 2,
                        thickness: 2,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
            // ),
          );
  }

  getlength() {
    if (_orderDetailList != null) {
      if (_orderDetailList[0].list != null) {
        return _orderDetailList[0].list.length;
      }
    }
    return 0;
  }

  Widget _getstatus() {
    return LimitedBox(
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: <Widget>[
              AutoSizeText(STR_PLEASE_WAIT_NOTIFI,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FONTSIZE_18,
                      fontFamily: KEY_FONTFAMILY,
                      fontWeight: FontWeight.w500,
                      color: greytheme700)),
              SizedBox(
                height: 15,
              ),
              AutoSizeText((STR_STATUS + "${getStatus()}"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FONTSIZE_18,
                      fontFamily: KEY_FONTFAMILY,
                      fontWeight: FontWeight.w500,
                      color: greytheme700)),
            ],
          ),
        ),
      ),
    );
  }

  String getStatus() {
    if (statusInfo != null) {
      if (statusInfo.status != null) {
        return statusInfo.status;
      }
    }
    return STR_STATUS_NOTIFIED;
  }

  @override
  void getOrderStatusfailed() {}

  @override
  void getOrderStatussuccess(StatusData statusData) {
    if (statusData != null) {
      setState(() {
        statusInfo = statusData;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void getOrderDetailsFailed() {
    // TODO: implement getOrderDetailsFailed
  }

  @override
  void getOrderDetailsSuccess(List<CurrentOrderList> _orderdetailsList) {
    // TODO: implement getOrderDetailsSuccess
  }

  @override
  void getmyOrderHistoryFailed() {
    // TODO: implement getmyOrderHistoryFailed
  }

  @override
  void getmyOrderHistorySuccess(
      List<GetMyOrderBookingHistoryList> _getmyOrderBookingHistory) {
    // TODO: implement getmyOrderHistorySuccess
  }
}