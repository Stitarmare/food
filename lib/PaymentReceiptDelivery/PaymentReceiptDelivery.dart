import 'package:auto_size_text/auto_size_text.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodzi/Models/GetMyOrdersBookingHistory.dart';
import 'package:foodzi/PaymentReceiptDine/PaymentReceiptContractor.dart';
import 'package:foodzi/PaymentReceiptDine/PaymentReceiptPresenter.dart';
import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/Utils/constant.dart';
import 'package:foodzi/Utils/globle.dart';
import 'package:foodzi/network/ApiBaseHelper.dart';
import 'package:foodzi/theme/colors.dart';
import 'package:foodzi/widgets/EmailReceiptDialog.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PaymentReceiptDeliveryView extends StatefulWidget {
  GetMyOrderBookingHistoryList getmyOrderBookingHistory;
  List<GetMyOrderBookingList> list;
  PaymentReceiptDeliveryView({this.getmyOrderBookingHistory, this.list});

  @override
  _PaymentReceiptDeliveryViewState createState() =>
      _PaymentReceiptDeliveryViewState();
}

class _PaymentReceiptDeliveryViewState extends State<PaymentReceiptDeliveryView>
    with TickerProviderStateMixin
    implements PaymentReceiptModalView {
  PayementReceiptPresenter payementReceiptPresenter;
  ProgressDialog progressDialog;
  bool isLoader = false;
  double itemTotal = 0;

  @override
  void initState() {
    payementReceiptPresenter = PayementReceiptPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);

    return SafeArea(
      left: false,
      top: false,
      right: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(
            "Payment Receipt",
            style: TextStyle(fontSize: 24),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[_getmainviewTableno(), _getOptions()],
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
              height: 55,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // Container(
                  //   height: 35,
                  // ),
                  GestureDetector(
                    onTap: () async {
                      var value = await showDialog(
                          context: context,
                          barrierDismissible: true,
                          child: EmailReceiptDialogView());
                      if (value != null) {
                        if (value["textValue"] != null) {
                          print(value["textValue"]);
                          // await progressDialog.show();
                          setState(() {
                            isLoader = true;
                          });
                          payementReceiptPresenter.getPaymentReceipt(
                              widget.getmyOrderBookingHistory.id,
                              value["textValue"],
                              context);
                        }
                      }
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                          color: getColorByHex(Globle().colorscode),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: Center(
                        child: Text(
                          "Email Receipt",
                          style: TextStyle(
                              fontFamily: KEY_FONTFAMILY,
                              fontWeight: FontWeight.w600,
                              fontSize: FONTSIZE_16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _getmainviewTableno() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        imageUrl: BaseUrl.getBaseUrlImages() +
                            '${widget.getmyOrderBookingHistory.restaurant.coverImage}',
                        errorWidget: (context, url, error) => Image.asset(
                          RESTAURANT_IMAGE_PATH,
                          fit: BoxFit.fill,
                        ),
                      ),
                      borderRadius: new BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      widget.getmyOrderBookingHistory.restaurant.restName ??
                          null,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: FONTSIZE_22,
                          fontFamily: Constants.getFontType(),
                          fontWeight: FontWeight.w700,
                          color: Globle().colorscode != null
                              ? getColorByHex(Globle().colorscode)
                              : orangetheme300),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Time :",
                        style: TextStyle(
                          fontSize: FONTSIZE_18,
                          fontFamily: Constants.getFontType(),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          getDateForOrderHistory(
                              widget.getmyOrderBookingHistory.createdAt),
                          style: TextStyle(
                              fontSize: FONTSIZE_16,
                              fontFamily: Constants.getFontType(),
                              fontWeight: FontWeight.w500,
                              color: greytheme700),
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Row(
                  children: <Widget>[
                    Text(
                      "Table : ",
                      style: TextStyle(
                        fontSize: FONTSIZE_18,
                        fontFamily: Constants.getFontType(),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: widget.getmyOrderBookingHistory.status ==
                              STR_DELIVERED
                          ? Text(
                              STR_DELIVERY_FOOD ?? "",
                              style: TextStyle(
                                  fontSize: FONTSIZE_17,
                                  fontFamily: Constants.getFontType(),
                                  fontWeight: FontWeight.w500,
                                  color: greytheme700),
                            )
                          : Text(""),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getOptions() {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20),
            child: Text(
              "Your Order",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FONTSIZE_20,
                fontFamily: Constants.getFontType(),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.5,
            ),
          ),
          _getMenuList(),
          _getBillDetails(),
        ],
      ),
    );
  }

  Widget _getMenuList() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
        itemCount: getLenghtOfHistoryOrder(),
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
                        padding: EdgeInsets.only(left: 20),
                        child: (widget.list[index].items.menuType == STR_VEG)
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
                      SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              widget.list[index].items.itemName != null
                                  ? StringUtils.capitalize(
                                      widget.list[index].items.itemName)
                                  : STR_ITEM_NAME,
                              style: TextStyle(
                                  fontSize: FONTSIZE_18,
                                  color: greytheme700,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          SizedBox(
                            height: 30,
                            width: 180,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 20,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.1),
                                        // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: AutoSizeText(
                                    widget.list[index].qty != null
                                        ? widget.list[index].qty.toString()
                                        : null,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: FONTSIZE_15,
                                        fontWeight: FontWeight.w700),
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("X"),
                                SizedBox(width: 10),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "${getItemTotal(widget.list[index])}",
                                      // widget.list[index].totalAmount != null
                                      //     ? widget.list[index].totalAmount
                                      //     : widget.list[index].sizePrice != null
                                      //         ? widget.list[index].sizePrice
                                      //         : "",
                                      style: TextStyle(
                                          fontSize: FONTSIZE_15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                )
                              ],
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
                        padding: EdgeInsets.only(right: 20, top: 15),
                        child: Row(
                          children: <Widget>[
                            Text(
                              Globle().currencySymb != null
                                  ? Globle().currencySymb
                                  : STR_R_CURRENCY_SYMBOL,
                              style: TextStyle(
                                  fontSize: FONTSIZE_15,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '${itemTotal.toStringAsFixed(2)}' ?? "0.00",
                              style: TextStyle(
                                  fontSize: FONTSIZE_16,
                                  fontWeight: FontWeight.w700),
                            ),
                            // Text(
                            //   '${widget.list[index].totalAmount}' ?? "0.00",
                            //   style: TextStyle(
                            //       fontSize: FONTSIZE_16,
                            //       fontWeight: FontWeight.w700),
                            // ),
                          ],
                        ),
                      )
                    ]),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    thickness: 0.5,
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getBillDetails() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.5,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: Text(
          //     STR_BILL_DETAILS,
          //     style: TextStyle(fontSize: FONTSIZE_16, color: greytheme700),
          //   ),
          // ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Item Total",
                  style: TextStyle(
                      fontSize: FONTSIZE_16, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 120,
                ),
                flex: 2,
              ),
              Row(
                children: <Widget>[
                  Text(
                    Globle().currencySymb != null
                        ? Globle().currencySymb
                        : STR_R_CURRENCY_SYMBOL,
                    style: TextStyle(
                        fontSize: FONTSIZE_16, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      double.parse(widget.getmyOrderBookingHistory.totalAmount)
                          .toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: FONTSIZE_16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 18,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Delivery charges",
                  style: TextStyle(
                      fontSize: FONTSIZE_16, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 120,
                ),
                flex: 2,
              ),
              Row(
                children: <Widget>[
                  Text(
                    Globle().currencySymb != null
                        ? Globle().currencySymb
                        : STR_R_CURRENCY_SYMBOL,
                    style: TextStyle(
                        fontSize: FONTSIZE_16, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: widget.getmyOrderBookingHistory.deliveryCharge != ""
                        ? Text(
                            getDeliveryCharge(
                                widget.getmyOrderBookingHistory.deliveryCharge),
                            style: TextStyle(
                                fontSize: FONTSIZE_16,
                                fontWeight: FontWeight.w500),
                          )
                        : Text(
                            "0.00",
                            style: TextStyle(
                                fontSize: FONTSIZE_16,
                                fontWeight: FontWeight.w500),
                          ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 18,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Tax 0%",
                  style: TextStyle(
                      fontSize: FONTSIZE_16, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 120,
                ),
                flex: 2,
              ),
              Row(
                children: <Widget>[
                  Text(
                    Globle().currencySymb != null
                        ? Globle().currencySymb
                        : STR_R_CURRENCY_SYMBOL,
                    style: TextStyle(
                        fontSize: FONTSIZE_16, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        "0.00",
                        style: TextStyle(
                            fontSize: FONTSIZE_16, fontWeight: FontWeight.w500),
                      )),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.5,
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  STR_TOTAL,
                  style: TextStyle(
                    fontSize: FONTSIZE_18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 120,
                ),
                flex: 2,
              ),
              Row(
                children: <Widget>[
                  Text(
                    Globle().currencySymb != null
                        ? Globle().currencySymb
                        : STR_R_CURRENCY_SYMBOL,
                    style: TextStyle(
                        fontSize: FONTSIZE_18, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      getTotalAmount(),
                      style: TextStyle(
                          fontSize: FONTSIZE_18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  int getLenghtOfHistoryOrder() {
    if (widget.list != null) {
      return widget.list.length;
    }
    return 0;
  }

  String getTotalAmount() {
    double dou = double.parse(widget.getmyOrderBookingHistory.totalAmount);
    double dou1 = widget.getmyOrderBookingHistory.deliveryCharge != ""
        ? double.parse(widget.getmyOrderBookingHistory.deliveryCharge)
        : 0;
    double dou2 = dou + dou1;
    String strTotalAmount = dou2.toStringAsFixed(2);
    return strTotalAmount;
  }

  String getDeliveryCharge(String str) {
    String strCharge = double.parse(str).toStringAsFixed(2);
    return strCharge;
  }

  String getItemTotal(GetMyOrderBookingList list) {
    double d1 = 0;
    double d2 = 0;
    double d3 = 0;
    String str;
    if (list.price != null) {
      d1 = double.parse(list.price);
    } else if (list.sizePrice != null) {
      d1 = double.parse(list.sizePrice);
    }

    if (list.cartExtras != null) {
      if (list.cartExtras.length > 0) {
        for (int j = 0; j < list.cartExtras.length; j++) {
          if (list.cartExtras[j].price != null) {
            d2 = d2 + double.parse(list.cartExtras[j].price);
          }
        }
      }
    }

    d3 = d1 + d2;
    str = d3.toStringAsFixed(2);

    itemTotal = list.qty * d3;
    return str;
  }

  String getDateForOrderHistory(String dateString) {
    var date = DateTime.parse(dateString);
    var dateStr = DateFormat("dd MMM yyyy").format(date.toLocal());

    DateFormat format = new DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime time1 = format.parse(dateString, true);
    var time = DateFormat("hh:mm a").format(time1.toLocal());

    return "$dateStr $time";
  }

  @override
  void onFailedPaymentReceipt() async {
    setState(() {
      isLoader = false;
    });
    // await progressDialog.hide();
  }

  @override
  void onSuccessPaymentReceipt(String message) async {
    setState(() {
      isLoader = false;
    });
    // await progressDialog.hide();
    if (message != null) {
      Constants.showAlertSuccess("Email Status", message, context);
    }
  }
}
