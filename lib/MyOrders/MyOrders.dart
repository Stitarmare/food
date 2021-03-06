import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodzi/CartDetailsPage/CartDetailsPage.dart';
import 'package:foodzi/Models/CurrentOrderModel.dart';
import 'package:foodzi/Models/GetMyOrdersBookingHistory.dart';
import 'package:foodzi/MyOrders/MyOrderContractor.dart';
import 'package:foodzi/MyOrders/MyOrdersPresenter.dart';
import 'package:foodzi/PaymentReceiptDine/PaymentReceiptView.dart';
import 'package:foodzi/PaymentTipAndPayDine/PaymentTipAndPayDi.dart';
import 'package:foodzi/StatusTrackPage/StatusTrackView.dart';
import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/Utils/constant.dart';
import 'package:foodzi/Utils/dialogs.dart';
import 'package:foodzi/Utils/globle.dart';
import 'package:foodzi/Utils/shared_preference.dart';
import 'package:foodzi/network/ApiBaseHelper.dart';
import 'package:foodzi/theme/colors.dart';
import 'package:intl/intl.dart';

class MyOrders extends StatefulWidget {
  String title;
  String ordertype;
  String tableName;
  MyOrders({this.title, this.ordertype, this.tableName});
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> implements MyOrderModelView {
  ScrollController _controller = ScrollController();
  MyOrdersPresenter _myOrdersPresenter;
  bool isCurrentOrders = true;
  bool isBookingHistory = false;
  int i;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  List<CurrentOrderList> _orderDetailList;
  List<GetMyOrderBookingHistoryList> getmyOrderBookingHistory;

  var imageurl;
  @override
  void initState() {
    super.initState();
    _myOrdersPresenter = MyOrdersPresenter(this);
    _myOrdersPresenter.getOrderDetails(STR_SMALL_DINEIN, context);
    _myOrdersPresenter.getmyOrderBookingHistory(
        STR_SMALL_DINEIN, context, true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          title: Column(
            children: <Widget>[
              // Image.asset(FOODZI_LOGO_PATH, height: 40),
              Text(
                STR_YOUR_ORDERS,
                style: TextStyle(
                    fontSize: FONTSIZE_18,
                    fontFamily: Constants.getFontType(),
                    fontWeight: FontWeight.w500,
                    color: greytheme1200),
              ),
            ],
          ),
        ),
        body: customTabbar(),
      ),
    );
  }

  Widget customTabbar() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          Card(
            borderOnForeground: true,
            elevation: 5.0,
            child: Container(
              constraints: BoxConstraints.expand(height: 40),
              child: TabBar(
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        STR_CURRENT_ORDER,
                        style: TextStyle(
                            fontFamily: Constants.getFontType(),
                            fontSize: FONTSIZE_15),
                      ),
                    ),
                    Tab(
                      child: Text(
                        STR_BOOKING_HISTORY,
                        style: TextStyle(
                          fontFamily: Constants.getFontType(),
                          fontSize: FONTSIZE_15,
                        ),
                      ),
                    )
                  ],
                  indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      insets: EdgeInsets.symmetric(horizontal: 30)),
                  labelColor: Colors.red,
                  unselectedLabelColor: greytheme1000,
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        setState(() {
                          isCurrentOrders = true;
                          isBookingHistory = false;
                        });

                        break;
                      case 1:
                        setState(() {
                          isCurrentOrders = false;
                          isBookingHistory = true;
                        });
                        break;
                    }
                  }),
            ),
          ),
          isCurrentOrders
              ? getLenghtOfCurrentOrder() == 0
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                          ),
                          Text("No Current Orders")
                        ],
                      ),
                    )
                  : Container(child: _currentOrders(context))
              : Container(
                  child: getLenghtOfHistoryOrder() == 0
                      ? Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                              ),
                              Text("No Booking History")
                            ],
                          ),
                        )
                      : _bookingHistoryList(context)),
        ],
      ),
    );
  }

  int getLenghtOfCurrentOrder() {
    if (_orderDetailList != null) {
      return _orderDetailList.length;
    }
    return 0;
  }

  String getitemname(List<ListElement> _listitem) {
    var itemname = '';
    for (i = 0; i < _listitem.length; i++) {
      itemname +=
          "${_listitem[i].qty} x ${capitalizeFirst(_listitem[i].items.itemName)}, ";
    }
    if (itemname.isNotEmpty) {
      itemname = removeLastChar(itemname);
      itemname = removeLastChar(itemname);
    }
    return itemname;
  }

  static String removeLastChar(String str) {
    return str.substring(0, str.length - 1);
  }

  String capitalizeFirst(String str) {
    return StringUtils.capitalize(str);
  }

  Widget _currentOrders(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.70,
        child: ListView.builder(
          itemCount: getLenghtOfCurrentOrder(),
          controller: _controller,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: null,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(4),
                ),
                elevation: 5,
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(left: 15, top: 8),
                          child: ClipRRect(
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              imageUrl: BaseUrl.getBaseUrlImages() +
                                  '${_orderDetailList[index].restaurant.coverImage}',
                              errorWidget: (context, url, error) => Image.asset(
                                RESTAURANT_IMAGE_PATH,
                                fit: BoxFit.fill,
                              ),
                            ),
                            borderRadius:
                                new BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                '${_orderDetailList[index].restaurant.restName}',
                                style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 0.32,
                                    color: greytheme700,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 15),
                      child: Text(
                        STR_ITEMS,
                        style: TextStyle(
                          fontSize: FONTSIZE_14,
                          color: greytheme1000,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        '${getitemname(_orderDetailList[index].list)}',
                        style: TextStyle(
                          fontSize: FONTSIZE_16,
                          fontWeight: FontWeight.w500,
                          color: greytheme700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 15),
                      child: Text(
                        STR_ORDERED_ON,
                        style: TextStyle(
                          fontSize: FONTSIZE_14,
                          color: greytheme1000,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        getDateForOrderHistory(
                            _orderDetailList[index].createdAt),
                        style: TextStyle(
                          fontSize: FONTSIZE_16,
                          fontWeight: FontWeight.w500,
                          color: greytheme700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 15),
                      child: Text(
                        STR_ORDER_TYPE,
                        style: TextStyle(
                          fontSize: FONTSIZE_14,
                          color: greytheme1000,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        '${capitalizeFirst(_orderDetailList[index].orderType)}',
                        style: TextStyle(
                          fontSize: FONTSIZE_16,
                          fontWeight: FontWeight.w500,
                          color: greytheme700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 15),
                      child: Text(
                        STR_TOTAL_AMOUNT,
                        style: TextStyle(
                          fontSize: FONTSIZE_14,
                          color: greytheme1000,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        Globle().currencySymb != null
                            ?
                            // '${Globle().currencySymb} ' +
                            //     '${_orderDetailList[index].totalAmount}'
                            '${Globle().currencySymb} ' +
                                strCurrentAmount(
                                    _orderDetailList[index].totalAmount)
                            : STR_R_CURRENCY_SYMBOL +
                                // '${_orderDetailList[index].totalAmount}',
                                strCurrentAmount(
                                    _orderDetailList[index].totalAmount),
                        style: TextStyle(
                          fontSize: FONTSIZE_16,
                          fontWeight: FontWeight.w500,
                          color: greytheme700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 40,
                        child: RaisedButton(
                          color: ((Globle().colorscode) != null)
                              ? getColorByHex(Globle().colorscode)
                              : greentheme300,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            STR_VIEW_ORDER_DETAILS,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: FONTSIZE_13,
                                fontFamily: Constants.getFontType(),
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartDetailsPage(
                                          restId:
                                              _orderDetailList[index].restId,
                                          orderId: _orderDetailList[index].id,
                                          isFromOrder: true,
                                          title: _orderDetailList[index]
                                              .restaurant
                                              .restName,
                                        )));
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  String strCurrentAmount(String str) {
    double doublePrice = double.parse(str);
    String strPrice = doublePrice.toStringAsFixed(2);
    // String str1 = Globle().currencySymb + " " + s;
    return strPrice;
  }

  int getLenghtOfHistoryOrder() {
    if (getmyOrderBookingHistory != null) {
      return getmyOrderBookingHistory.length;
    }
    return 0;
  }

  String getBookingHistoryitemname(List<GetMyOrderBookingList> _listitem) {
    var itemname = '';
    for (i = 0; i < _listitem.length; i++) {
      itemname += "${_listitem[i].qty} x ${_listitem[i].items.itemName}, ";
    }
    if (itemname.isNotEmpty) {
      itemname = removeLastChar(itemname);
      itemname = removeLastChar(itemname);
    }
    return itemname;
  }

  static String removeLastChars(String str) {
    return str.substring(0, str.length - 1);
  }

  Widget _bookingHistoryList(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.70,
        child: ListView.builder(
          itemCount: getLenghtOfHistoryOrder(),
          controller: _controller,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(4),
              ),
              elevation: 5,
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.only(left: 15, top: 8),
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(),
                            ),
                            imageUrl: BaseUrl.getBaseUrlImages() +
                                '${getmyOrderBookingHistory[index].restaurant.coverImage}',
                            errorWidget: (context, url, error) => Image.asset(
                              RESTAURANT_IMAGE_PATH,
                              fit: BoxFit.fill,
                            ),
                          ),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              '${getmyOrderBookingHistory[index].restaurant.restName}',
                              style: TextStyle(
                                  fontSize: FONTSIZE_18,
                                  letterSpacing: 0.32,
                                  color: greytheme700,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Divider(
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15),
                    child: Text(
                      STR_ITEMS,
                      style: TextStyle(
                        fontSize: FONTSIZE_14,
                        color: greytheme1000,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      '${getBookingHistoryitemname(getmyOrderBookingHistory[index].list)}',
                      style: TextStyle(
                        fontSize: FONTSIZE_16,
                        fontWeight: FontWeight.w500,
                        color: greytheme700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: Text(
                      STR_ORDERED_ON,
                      style: TextStyle(
                        fontSize: FONTSIZE_14,
                        color: greytheme1000,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      getDateForOrderHistory(
                          getmyOrderBookingHistory[index].createdAt),
                      style: TextStyle(
                        fontSize: FONTSIZE_16,
                        fontWeight: FontWeight.w500,
                        color: greytheme700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: Text(
                      STR_ORDER_TYPE,
                      style: TextStyle(
                        fontSize: FONTSIZE_14,
                        color: greytheme1000,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      '${capitalizeFirst(getmyOrderBookingHistory[index].orderType)}',
                      style: TextStyle(
                        fontSize: FONTSIZE_16,
                        fontWeight: FontWeight.w500,
                        color: greytheme700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15),
                    child: Text(
                      STR_TOTAL_AMOUNT,
                      style: TextStyle(
                        fontSize: FONTSIZE_14,
                        color: greytheme1000,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      Globle().currencySymb != null
                          ? '${Globle().currencySymb} ' +
                              // '${getmyOrderBookingHistory[index].totalAmount}'
                              strHistoryAmount(
                                  getmyOrderBookingHistory[index].totalAmount)
                          : STR_R_CURRENCY_SYMBOL +
                              // '${getmyOrderBookingHistory[index].totalAmount}',
                              strHistoryAmount(
                                  getmyOrderBookingHistory[index].totalAmount),
                      style: TextStyle(
                        fontSize: FONTSIZE_16,
                        fontWeight: FontWeight.w500,
                        color: greytheme700,
                      ),
                    ),
                  ),
                  getmyOrderBookingHistory[index]
                              .splitbilltransactions
                              .length !=
                          0
                      ? getMethod(getmyOrderBookingHistory[index]
                              .splitbilltransactions)
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10, left: 15),
                              child: Text(
                                STR_SPLIT_AMOUNT,
                                style: TextStyle(
                                  fontSize: FONTSIZE_14,
                                  color: greytheme1000,
                                ),
                              ),
                            )
                          : Container()
                      : Container(),
                  // : Container(),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: getmyOrderBookingHistory[index]
                                .splitbilltransactions
                                .length !=
                            0
                        ? getMethod(getmyOrderBookingHistory[index]
                                .splitbilltransactions)
                            ? Text(
                                Globle().currencySymb != null
                                    ? '${Globle().currencySymb} ' +
                                        // '${getmyOrderBookingHistory[index].splitAmount}'
                                        getSplitAmount(
                                            getmyOrderBookingHistory[index]
                                                .splitbilltransactions)
                                    : STR_R_CURRENCY_SYMBOL +
                                        '${getmyOrderBookingHistory[index].splitAmount}',
                                style: TextStyle(
                                  fontSize: FONTSIZE_16,
                                  fontWeight: FontWeight.w500,
                                  color: greytheme700,
                                ),
                              )
                            : Text("")
                        : Text(""),
                    // : Text(""),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      ClipOval(
                        child: Container(
                            height: 10,
                            width: 10,
                            color: getmyOrderBookingHistory[index].status ==
                                    STR_PAID_SMALL
                                ? Colors.green
                                : Colors.red),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${capitalizeFirst(getmyOrderBookingHistory[index].status)}',
                        style: TextStyle(color: greytheme400, fontSize: 18),
                      ),
                      Spacer(),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      //   child: GestureDetector(
                      //     onTap: () {},
                      //     child: Text(STR_REPEAT_ORDER),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: getmyOrderBookingHistory[index].status !=
                                STR_CANCELLED
                            ? RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                color: Colors.blue,
                                child: Text(
                                  "Payment Receipt",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentReceiptDineView(
                                                getmyOrderBookingHistory:
                                                    getmyOrderBookingHistory[
                                                        index],
                                                list: getmyOrderBookingHistory[
                                                        index]
                                                    .list,
                                              )));
                                },
                              )
                            : Text(""),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            );
          },
        ));
  }

  bool getMethod(List<Splitbilltransactions> list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].userId == Globle().loginModel.data.id) {
        return true;
      } else {}
    }
    return false;
  }

  String getSplitAmount(List<Splitbilltransactions> list) {
    String str = "";
    for (int i = 0; i < list.length; i++) {
      if (list[i].userId == Globle().loginModel.data.id) {
        str = double.parse(list[i].amount).toStringAsFixed(2);
        return str;
      }
    }
    return "";
  }

  String strHistoryAmount(String str) {
    double doublePrice = double.parse(str);
    String strPrice = doublePrice.toStringAsFixed(2);
    // String str1 = Globle().currencySymb + " " + s;
    return strPrice;
  }

  String getDateForOrderHistory(String dateString) {
    var date = DateTime.parse(dateString);
    var dateStr = DateFormat("dd MMM yyyy").format(date.toLocal());

    DateFormat format = new DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime time1 = format.parse(dateString, true);
    var time = DateFormat("hh:mm a").format(time1.toLocal());

    return "$dateStr at $time";
  }

  @override
  void getOrderDetailsFailed() {
    setDefaultData();
  }

  @override
  void getOrderDetailsSuccess(List<CurrentOrderList> _orderdetailsList) {
    if (_orderdetailsList.length == 0) {
      setDefaultData();
      return;
    }

    setState(() {
      if (_orderdetailsList.length != null) {
        _orderDetailList = _orderdetailsList;
      }
    });
    Globle().isTabelAvailable = true;
    Globle().tableID = _orderDetailList[0].tableId;
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
    Preference.setPersistData<int>(
        _orderDetailList[0].id, PreferenceKeys.currentOrderId);
    Preference.setPersistData<int>(
        _orderDetailList[0].restId, PreferenceKeys.currentRestaurantId);

    Preference.setPersistData<int>(
        _orderDetailList[0].restId, PreferenceKeys.restaurantID);
    Preference.setPersistData<int>(
        _orderDetailList[0].id, PreferenceKeys.orderId);
    Globle().orderID = _orderDetailList[0].id;
    Preference.setPersistData<bool>(true, PreferenceKeys.isDineIn);
    Preference.setPersistData<int>(0, PreferenceKeys.dineCartItemCount);
    Globle().dinecartValue = 0;
    Preference.setPersistData<int>(0, PreferenceKeys.dineCartItemCount);
    Globle().takeAwayCartItemCount = 0;
    Preference.setPersistData<int>(0, PreferenceKeys.takeAwayCartCount);
    Preference.setPersistData<bool>(true, PreferenceKeys.isAlreadyINCart);
  }

  setDefaultData() {
    Preference.setPersistData<int>(null, PreferenceKeys.orderId);
    Globle().orderID = 0;
    Preference.removeForKey(PreferenceKeys.orderId);
    Globle().dinecartValue = 0;
    Globle().takeAwayCartItemCount = 0;
    Globle().isTabelAvailable = false;
    Globle().tableID = 0;
    Preference.setPersistData<int>(0, PreferenceKeys.takeAwayCartCount);
    Preference.setPersistData<bool>(null, PreferenceKeys.isDineIn);
    Preference.setPersistData<int>(0, PreferenceKeys.dineCartItemCount);
    Preference.setPersistData<int>(null, PreferenceKeys.currentOrderId);
    Preference.setPersistData<bool>(null, PreferenceKeys.isAlreadyINCart);
    Preference.setPersistData<int>(null, PreferenceKeys.restaurantID);
  }

  @override
  void getmyOrderHistoryFailed() {}

  @override
  void getmyOrderHistorySuccess(
      List<GetMyOrderBookingHistoryList> _getmyOrderBookingHistory) {
    if (_getmyOrderBookingHistory.length == 0) {
      return;
    }
    setState(() {
      // getmyOrderBookingHistory = _getmyOrderBookingHistory;

      // Iterable<GetMyOrderBookingHistoryList> orderIterableList =
      //     getmyOrderBookingHistory.reversed;
      // List<GetMyOrderBookingHistoryList> list1 = [];
      // for (int i = 0; i < orderIterableList.length; i++) {
      //   GetMyOrderBookingHistoryList list = orderIterableList.elementAt(i);
      //   list1.add(list);
      //   getmyOrderBookingHistory = list1;
      // }
      for (int i = 0; i < _getmyOrderBookingHistory.length; i++) {
        _getmyOrderBookingHistory.sort((b, a) => a.id.compareTo(b.id));
      }

      getmyOrderBookingHistory = _getmyOrderBookingHistory;
    });
    Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
  }
}
