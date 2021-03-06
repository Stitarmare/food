import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodzi/CartDetailsPage/CartDetailsPage.dart';
import 'package:foodzi/Models/CurrentOrderModel.dart';
import 'package:foodzi/Models/DeliveryBoyInfoModel.dart';
import 'package:foodzi/Models/GetMyOrdersBookingHistory.dart';
import 'package:foodzi/MyOrdersDelivery/MyOrdersDeliveryContractor.dart';
import 'package:foodzi/MyOrdersDelivery/MyOrdersDeliveryPresenter.dart';
import 'package:foodzi/PaymentReceiptDelivery/PaymentReceiptDelivery.dart';
import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/Utils/constant.dart';
import 'package:foodzi/Utils/globle.dart';
import 'package:foodzi/Utils/shared_preference.dart';
import 'package:foodzi/network/ApiBaseHelper.dart';
import 'package:foodzi/theme/colors.dart';
import 'package:foodzi/widgets/DriverDetailDialog.dart';
import 'package:intl/intl.dart';

class MyOrdersDelivery extends StatefulWidget {
  String title;
  String ordertype;
  String tableName;
  MyOrdersDelivery({this.title, this.ordertype, this.tableName});
  _MyOrdersDeliveryState createState() => _MyOrdersDeliveryState();
}

class _MyOrdersDeliveryState extends State<MyOrdersDelivery>
    implements MyOrderDeliveryModelView {
  ScrollController _controller = ScrollController();
  MyOrdersDeliveryPresenter _myOrdersPresenter;
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
    _myOrdersPresenter = MyOrdersDeliveryPresenter(this);
    _myOrdersPresenter.getOrderDetails(STR_SMALL_DELIVERY, context);
    _myOrdersPresenter.getmyOrderBookingHistory(STR_SMALL_DELIVERY, context);
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
                  : Center(child: Container(child: _currentOrders(context)))
              : getLenghtOfHistoryOrder() == 0
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                          ),
                          Text("No Booking History")
                        ],
                      ),
                    )
                  : Center(
                      child: Container(child: _bookingHistoryList(context))),
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
          "${_listitem[i].quantity} x ${capitalizeFirst(_listitem[i].items.itemName)}, ";
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
                            ? '${Globle().currencySymb} ' +
                                '${_orderDetailList[index].totalAmount}'
                            : STR_R_CURRENCY_SYMBOL +
                                '${_orderDetailList[index].totalAmount}',
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
                    Row(
                      children: <Widget>[
                        // Center(
                        //   child:
                        Expanded(
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.5,
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),

                            height: 40,
                            child: RaisedButton(
                              color: ((Globle().colorscode) != null)
                                  ? getColorByHex(Globle().colorscode)
                                  : orangetheme,
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
                                              restId: _orderDetailList[index]
                                                  .restId,
                                              orderId:
                                                  _orderDetailList[index].id,
                                              isFromOrder: true,
                                              orderType: STR_DELIVERY,
                                            )));
                              },
                            ),
                          ),
                        ),

                        // ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            // width: MediaQuery.of(context).size.width * 0.5,
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            height: 40,
                            child: RaisedButton(
                              color: ((Globle().colorscode) != null)
                                  ? getColorByHex(Globle().colorscode)
                                  : orangetheme,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                STR_VIEW_DRIVER_DETAILS,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: FONTSIZE_13,
                                    fontFamily: Constants.getFontType(),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                callApiDriverInfo(_orderDetailList[index].id);
                              },
                            ),
                          ),
                        ),
                      ],
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

  void callApiDriverInfo(int orderId) async {
    _myOrdersPresenter.getDeliveryBoyInfo(orderId, context);
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
      itemname +=
          "${_listitem[i].qty} x ${capitalizeFirst(_listitem[i].items.itemName)}, ";
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
                              '${getTotalAmount(getmyOrderBookingHistory[index].totalAmount)}'
                          : STR_R_CURRENCY_SYMBOL +
                              '${getTotalAmount(getmyOrderBookingHistory[index].totalAmount)}',
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
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      ClipOval(
                        child: Container(
                          height: 10,
                          width: 10,
                          color: Colors.green,
                        ),
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
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          color: Colors.blue,
                          child: Text(
                            "Payment Receipt",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentReceiptDeliveryView(
                                          getmyOrderBookingHistory:
                                              getmyOrderBookingHistory[index],
                                          list: getmyOrderBookingHistory[index]
                                              .list,
                                        )));
                          },
                        ),
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

  String capitalizeFirst(String str) {
    return StringUtils.capitalize(str);
  }

  String getDateForOrderHistory(String dateString) {
    var date = DateTime.parse(dateString);
    var dateStr = DateFormat("dd MMM yyyy").format(date.toLocal());
    DateFormat format = new DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime time1 = format.parse(dateString, true);
    var time = DateFormat("hh:mm a").format(time1.toLocal());

    // var time = DateFormat("hh:mm a").format(date);
    return "$dateStr at $time";
  }

  driverDetailsDialog(DeliveryBoyInfoData data) {
    showDialog(
        context: context,
        barrierDismissible: true,
        child: DriverDetailsView(
          firstName: data.firstName,
          lastName: data.lastName,
          mobNo: data.mobileNumber,
          countryCode: data.countryCode,
          profilePic: data.userDetails.profileImage,
        ));
  }

  String getTotalAmount(String str) {
    String str1 = double.parse(str).toStringAsFixed(2);
    return str1;
  }

  @override
  void getOrderDetailsFailed() {}

  @override
  void getOrderDetailsSuccess(List<CurrentOrderList> _orderdetailsList) {
    if (_orderdetailsList.length == 0) {
      return;
    }

    setState(() {
      if (_orderdetailsList.length != null) {
        _orderDetailList = _orderdetailsList;

        for (int i = 0; i < _orderdetailsList.length; i++) {
          _orderDetailList.sort((b, a) => a.id.compareTo(b.id));
        }
      }
    });
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
    Preference.setPersistData<int>(
        _orderDetailList[0].id, PreferenceKeys.currentOrderId);
    Preference.setPersistData<int>(
        _orderDetailList[0].restId, PreferenceKeys.currentRestaurantId);
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
      getmyOrderBookingHistory = _getmyOrderBookingHistory;
      for (int i = 0; i < _getmyOrderBookingHistory.length; i++) {
        getmyOrderBookingHistory.sort((b, a) => a.id.compareTo(b.id));
      }
    });
    Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
  }

  @override
  void getDeliveryBoyDetailFailed() {}

  @override
  void getDeliveryBoyDetailSuccess(DeliveryBoyInfoData data) {
    driverDetailsDialog(data);
  }
}
