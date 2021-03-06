import 'package:auto_size_text/auto_size_text.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodzi/Models/GetTableListModel.dart';
import 'package:foodzi/Models/MenuCartDisplayModel.dart';
import 'package:foodzi/MyCartDelivery/MyCartDeliveryContractor.dart';
import 'package:foodzi/MyCartDelivery/MyCartDeliveryPresenter.dart';
import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/Utils/constant.dart';
import 'package:foodzi/Utils/dialogs.dart';
import 'package:foodzi/Utils/globle.dart';
import 'package:foodzi/Utils/shared_preference.dart';
import 'package:foodzi/map_view/map_view.dart';
import 'package:foodzi/theme/colors.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MyCartDeliveryView extends StatefulWidget {
  int restId;
  int userID;
  String lat;
  String long;
  String orderType;
  double total;
  String restName;
  String imgUrl;

  MyCartDeliveryView(
      {this.restId,
      this.userID,
      this.orderType,
      this.lat,
      this.long,
      this.total,
      this.restName,
      this.imgUrl});
  @override
  State<StatefulWidget> createState() {
    return _MyCartDeliveryViewState();
  }
}

class _MyCartDeliveryViewState extends State<MyCartDeliveryView>
    with TickerProviderStateMixin
    implements
        MyCartDeliveryModelView,
        GetTableListModelView,
        AddTablenoModelView {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  DialogsIndicator dialogs = DialogsIndicator();
  List<TableList> _dropdownItemsTable = [];

  bool isTableList = false;

  bool isloading = false;

  int _dropdownTableNumber;
  bool isLoader = false;

  String tableno;
  int count;

  GetTableList getTableListModel;

  MycartDeliveryPresenter _myCartpresenter;
  List<MenuCartList> _cartItemList;
  int cartId;
  MenuCartDisplayModel myCart;
  int page = 1;
  int indx;
  int id;
  List<int> itemList = [];

  List<MenuCartList> itemData;

  TableList tableList;
  ProgressDialog progressDialog;
  bool isIgnoreTouch = false;

  @override
  void initState() {
    // progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    // progressDialog.style(message: STR_LOADING);
    setState(() {
      isloading = true;
    });
    _myCartpresenter = MycartDeliveryPresenter(this, this, this);
    _myCartpresenter.getCartMenuList(
        widget.restId, context, Globle().loginModel.data.id);
    _myCartpresenter.getTableListno(widget.restId, context);
    super.initState();
  }

  int gettablelist(List<GetTableList> getlist) {
    List<TableList> _tablelist = [];
    for (int i = 0; i < getlist.length; i++) {
      _tablelist.add(TableList(
        id: getlist[i].id,
        restid: widget.restId,
        name: getlist[i].tableName,
      ));
    }
    setState(() {
      _dropdownItemsTable = _tablelist;
    });
    getlistoftable();
    return _tablelist.length;
  }

  getlistoftable() {
    if (_dropdownItemsTable != null) {
      if (_dropdownItemsTable.length >= 0) {
        setState(() {
          isTableList = true;
        });
        return;
      }
      setState(() {
        isTableList = false;
      });
    }
    setState(() {
      isTableList = false;
    });
  }

  Widget totalamounttext() {
    return Container(
      // color: Colors.grey,
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              '${"Total "}' + '${getCurrency()}' + '${getGrandTotal()}',
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

  Widget steppercount(MenuCartList menuCartList, int index) {
    return Container(
      height: 24,
      width: 150,
      child: Row(children: <Widget>[
        InkWell(
          onTap:
              // (menuCartList.quantity == 1)
              //     ? () {}
              //     :
              () async {
            if (menuCartList.quantity > 0) {
              setState(() {
                menuCartList.quantity -= 1;
                print(menuCartList.quantity);
              });
              // DialogsIndicator.showLoadingDialog(
              //     context, _keyLoader, STR_LOADING);
              if (menuCartList.quantity > 0) {
                setState(() {
                  isIgnoreTouch = true;
                  isLoader = true;
                });
                // await progressDialog.show();
                _myCartpresenter.updateQauntityCount(
                    menuCartList.id,
                    menuCartList.quantity,
                    (double.parse(menuCartList.totalAmount)) /
                        menuCartList.quantity,
                    context);
              }
              if (menuCartList.quantity == 0) {
                // DialogsIndicator.showLoadingDialog(
                //     context, _keyLoader, STR_LOADING);
                setState(() {
                  isIgnoreTouch = true;
                });
                await progressDialog.show();
                _myCartpresenter.removeItemfromCart(
                    menuCartList.id, Globle().loginModel.data.id, context);
                setState(() {
                  _cartItemList.removeAt(index);
                });
              }
            }
          },
          splashColor: Colors.redAccent.shade200,
          child: Container(
            decoration: BoxDecoration(
                color: getColorByHex(Globle().colorscode),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            alignment: Alignment.center,
            child: Icon(
              Icons.remove,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 13, right: 13),
          child: Text(
            menuCartList.quantity.toString(),
            style: TextStyle(
                fontSize: FONTSIZE_16,
                fontFamily: Constants.getFontType(),
                fontWeight: FontWeight.w600,
                color: greytheme700),
          ),
        ),
        InkWell(
          onTap: () async {
            if (menuCartList.quantity < 100) {
              setState(() {
                menuCartList.quantity += 1;
                print(menuCartList.quantity);
                isIgnoreTouch = true;
                isLoader = true;
              });
              // DialogsIndicator.showLoadingDialog(
              //     context, _keyLoader, STR_LOADING);
              // await progressDialog.show();
              _myCartpresenter.updateQauntityCount(
                  menuCartList.id,
                  menuCartList.quantity,
                  (double.parse(menuCartList.totalAmount)) /
                      menuCartList.quantity,
                  context);
            }
          },
          splashColor: Colors.lightBlue,
          child: Container(
            decoration: BoxDecoration(
                color: getColorByHex(Globle().colorscode),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    progressDialog.style(message: STR_LOADING);
    Widget _getmainviewTableno() {
      return Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    STR_DELIVERY_TITLE,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: FONTSIZE_20,
                        fontFamily: Constants.getFontType(),
                        fontWeight: FontWeight.w600,
                        color: getColorByHex(Globle().colorscode)),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 2.0,
              ),
              SizedBox(
                height: 5,
              ),
              // isTableList
              //     ? getTableNumber()
              //     : Container(
              //         child: Row(
              //         children: <Widget>[
              //           SizedBox(width: 20),
              //           Text(STR_NO_TABLE,
              //               style: TextStyle(
              //                   fontSize: FONTSIZE_14,
              //                   fontFamily: Constants.getFontType(),
              //                   fontWeight: FontWeight.w600,
              //                   color: getColorByHex(Globle().colorscode))),
              //         ],
              //       )),
              // SizedBox(
              //   height: 10,
              // )
            ],
          ),
        ),
        // ),
      );
    }

    return SafeArea(
      left: false,
      top: false,
      right: false,
      child: IgnorePointer(
        ignoring: isIgnoreTouch,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            title: Text(STR_MYCART),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Stack(alignment: Alignment.center, children: <Widget>[
            Column(
              children: <Widget>[
                _getmainviewTableno(),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 2,
                ),
                SizedBox(
                  height: 10,
                ),
                isloading
                    ? Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: FONTSIZE_15,
                                    fontFamily: KEY_FONTFAMILY,
                                    fontWeight: FontWeight.w500,
                                    color: greytheme1200),
                              ),
                            ),
                            // CircularProgressIndicator()
                            SpinKitFadingCircle(
                              color: Globle().colorscode != null
                                  ? getColorByHex(Globle().colorscode)
                                  : orangetheme300,
                              size: 50.0,
                              controller: AnimationController(
                                  vsync: this,
                                  duration: const Duration(milliseconds: 1200)),
                            )
                          ],
                        ),
                      )
                    : _getAddedListItem()
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
                height: MediaQuery.of(context).size.height * 0.21,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: totalamounttext(),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        child: Text(
                          STR_ADD_MORE_ITEM,
                          style: TextStyle(
                              fontSize: FONTSIZE_16,
                              fontFamily: Constants.getFontType(),
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  getColorByHex(Globle().colorscode),
                              color: getColorByHex(Globle().colorscode),
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Globle().takeAwayCartItemCount = 0;
                        Preference.setPersistData<int>(
                            0, PreferenceKeys.takeAwayCartCount);
                        if (_cartItemList != null) {
                          if (double.parse(myCart.grandTotal) < 1.0) {
                            Constants.showAlert(
                                "Amount",
                                "Total Amount should be greater than ${getCurrency()} 1.00",
                                context);
                            return;
                          }
                        }

                        (_cartItemList != null)
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapView(
                                          flag: 1,
                                          restName: widget.restName,
                                          restId: widget.restId,
                                          userId: _cartItemList[indx].userId,
                                          // price: int.parse(
                                          //     _cartItemList[indx].price),
                                          items: itemList,
                                          totalAmount:
                                              double.parse(myCart.grandTotal),
                                          orderType: widget.orderType,
                                          latitude: widget.lat,
                                          longitude: widget.long,
                                          itemdata: _cartItemList,
                                          currencySymbol: myCart.currencySymbol,
                                          tableId: _cartItemList[indx].tableId,
                                        )))
                            : Constants.showAlert(
                                STR_MYCART, STR_ADD_ITEM_CART, context);
                      },
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                            color: getColorByHex(Globle().colorscode),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        child: Center(
                          child: Text(
                            STR_PLACE_ORDER,
                            style: TextStyle(
                                fontFamily: Constants.getFontType(),
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
      ),
    );
  }

  Widget getTableNumber() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      height: 50,
      width: MediaQuery.of(context).size.width * 0.8,
      child: FormField(builder: (FormFieldState state) {
        return DropdownButtonFormField(
          items: _dropdownItemsTable.map((tableNumber) {
            return new DropdownMenuItem(
                value: tableNumber.id,
                child: Row(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(
                          "${tableNumber.name}",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  getColorByHex(Globle().colorscode),
                              fontSize: FONTSIZE_14,
                              fontFamily: Constants.getFontType(),
                              fontWeight: FontWeight.w600,
                              color: getColorByHex(Globle().colorscode)),
                        )),
                  ],
                ));
          }).toList(),
          onChanged: (newValue) async {
            setState(() {
              _dropdownTableNumber = newValue;
            });
            for (int i = 0; i < _dropdownItemsTable.length; i++) {
              if (newValue == _dropdownItemsTable[i].id) {
                print(_dropdownItemsTable[i].name);
                tableno = _dropdownItemsTable[i].name;
              }
            }
            // await progressDialog.show();
            //DialogsIndicator.showLoadingDialog(context, _keyLoader, STR_BLANK);
            _myCartpresenter.addTablenoToCart(Globle().loginModel.data.id,
                widget.restId, _dropdownTableNumber, context);
          },
          value: _dropdownTableNumber,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 5, 0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: greentheme100, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: greytheme900, width: 2)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
            filled: false,
            hintText: STR_CHOOSE_TABLE,
            labelText:
                _dropdownTableNumber == null ? STR_ADD_TABLE : STR_TABLE_NO,
            labelStyle: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Colors.black,
                fontSize: FONTSIZE_14,
                fontFamily: Constants.getFontType(),
                fontWeight: FontWeight.w600,
                color: greytheme100),
          ),
        );
      }),
    );
  }

  Widget _getAddedListItem() {
    return (_cartItemList != null)
        ? Expanded(
            child: ListView.builder(
              itemCount: _cartItemList.length,
              itemBuilder: (BuildContext context, int index) {
                id = _cartItemList[index].itemId;
                cartId = _cartItemList[index].id;
                indx = index;
                return Dismissible(
                  key: UniqueKey(),
                  background: refreshBg(),
                  onDismissed: (direction) async {
                    int cartIdnew = _cartItemList[index].id;
                    // DialogsIndicator.showLoadingDialog(
                    //     context, _keyLoader, STR_LOADING);
                    // await progressDialog.show();
                    setState(() {
                      isLoader = true;
                    });
                    _myCartpresenter.removeItemfromCart(
                        cartIdnew, Globle().loginModel.data.id, context);
                    setState(() {
                      _cartItemList.removeAt(index);
                    });
                  },
                  child: Container(
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
                                child: (_cartItemList[index].items.menuType ==
                                        STR_VEG)
                                    ? Image.asset(
                                        IMAGE_VEG_ICON_PATH,
                                        height: 25,
                                        width: 25,
                                      )
                                    : Image.asset(
                                        IMAGE_VEG_ICON_PATH,
                                        color: redtheme,
                                        width: 25,
                                        height: 25,
                                      ),
                              ),
                              SizedBox(width: 5),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.63,
                                    child: Text(
                                      _cartItemList[index].items.itemName !=
                                              null
                                          ? StringUtils.capitalize(
                                              _cartItemList[index]
                                                  .items
                                                  .itemName)
                                          : STR_ITEM_NAME,
                                      style: TextStyle(
                                          fontFamily: Constants.getFontType(),
                                          fontSize: FONTSIZE_16,
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
                                      getExtra(_cartItemList[index]),
                                      style: TextStyle(
                                        color: greytheme1000,
                                        fontSize: FONTSIZE_14,
                                      ),
                                      maxFontSize: 12,
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  steppercount(_cartItemList[index], index),
                                ],
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: 0,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5, top: 30),
                                child: Text(
                                  "${getCurrency()} " +
                                          "${_cartItemList[index].totalAmount}" ??
                                      '',
                                  style: TextStyle(
                                      color: greytheme700,
                                      fontSize: FONTSIZE_16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ]),
                        SizedBox(height: 12),
                        Divider(
                          height: 2,
                          thickness: 2,
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Expanded(
            child: Center(
              child: Text(
                STR_NOTHING_CART,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: FONTSIZE_22,
                    fontFamily: Constants.getFontType(),
                    fontWeight: FontWeight.w500,
                    color: greytheme1200),
              ),
            ),
          );
  }

  Widget refreshBg() {
    return Container(
      alignment: Alignment.centerRight,
      color: getColorByHex(Globle().colorscode),
      padding: EdgeInsets.only(right: 20),
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  String getCurrency() {
    if (myCart != null) {
      if (myCart.currencySymbol != null) {
        return myCart.currencySymbol;
      }
    }
    return "";
  }

  String getGrandTotal() {
    if (myCart != null) {
      if (myCart.currencySymbol != null) {
        return myCart.grandTotal;
      }
    }
    return "0";
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

      if (menuCartList.cartExtraItems[i].subspreads.length > 0) {
        if (extras.isNotEmpty) {
          extras = removeLastChar(extras);
          extras = removeLastChar(extras);
        }
        for (int j = 0;
            j < menuCartList.cartExtraItems[i].subspreads.length;
            j++) {
          extras += " - ${menuCartList.cartExtraItems[i].subspreads[j].name}, ";
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
          if (menuCartList.cartExtraItems[i].switchOption != null) {
            extras +=
                "${menuCartList.cartExtraItems[i].switches[j].name} - ${menuCartList.cartExtraItems[i].switchOption}, ";
          } else {
            extras += "${menuCartList.cartExtraItems[i].switches[j].name},";
          }
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

  @override
  Future<void> getCartMenuListfailed() async {
    setState(() {
      _cartItemList = null;
      isIgnoreTouch = false;
      isloading = false;
      isLoader = false;
    });
    // await progressDialog.hide();
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  @override
  Future<void> getCartMenuListsuccess(
      List<MenuCartList> menulist, MenuCartDisplayModel model) async {
    setState(() {
      isIgnoreTouch = false;
      isloading = false;
      isLoader = false;
    });
    if (menulist.length == 0) {
      Globle().dinecartValue = menulist.length;
      Preference.setPersistData<int>(
          Globle().dinecartValue, PreferenceKeys.dineCartItemCount);
      // await progressDialog.hide();
      //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      return;
    }
    Globle().dinecartValue = menulist.length;
    Preference.setPersistData<int>(
        Globle().dinecartValue, PreferenceKeys.dineCartItemCount);

    setState(() {
      _cartItemList = menulist;
      myCart = model;

      for (var i = 0; i < _cartItemList.length; i++) {
        itemList.add(_cartItemList[i].id);
        print(itemList);
      }
      // else {
      //   _cartItemList.addAll(menulist);
      //   myCart = model;
      // }
      page++;
    });
    // await progressDialog.hide();
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  @override
  Future<void> removeItemFailed() async {
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
    Preference.setPersistData(null, PreferenceKeys.restaurantID);
    Preference.setPersistData(null, PreferenceKeys.isAlreadyINCart);
    Preference.setPersistData(null, PreferenceKeys.restaurantName);
    await progressDialog.hide();
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  @override
  Future<void> removeItemSuccess() async {
    await progressDialog.hide();
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });

    if (_cartItemList != null) {
      if (_cartItemList.length == 0) {
        Preference.setPersistData<int>(null, PreferenceKeys.restaurantID);
        Preference.setPersistData<bool>(false, PreferenceKeys.isAlreadyINCart);
        Preference.setPersistData<String>(null, PreferenceKeys.restaurantName);
        Globle().dinecartValue = 0;
        Preference.setPersistData<int>(0, PreferenceKeys.dineCartItemCount);
        setState(() {
          myCart = null;
        });
      }
    }

    // _cartItemList = null;
    Globle().dinecartValue -= 1;
    Preference.setPersistData<int>(
        Globle().dinecartValue, PreferenceKeys.dineCartItemCount);
    _myCartpresenter.getCartMenuList(
        widget.restId, context, Globle().loginModel.data.id);
  }

  @override
  Future<void> addTablebnoSuccces() async {
    // await progressDialog.hide();
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
  }

  @override
  Future<void> addTablenofailed() async {
    // await progressDialog.hide();
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
  }

  @override
  void getTableListFailed() {
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
  }

  @override
  void getTableListSuccess(List<GetTableList> _getlist) {
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
    getTableListModel = _getlist[0];
    if (_getlist.length > 0) {
      gettablelist(_getlist);
    }
  }

  @override
  Future<void> updatequantitySuccess() async {
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
    // await progressDialog.hide();

    // _cartItemList = null;
    // Globle().dinecartValue -= 1;
    _myCartpresenter.getCartMenuList(
        widget.restId, context, Globle().loginModel.data.id);
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  @override
  Future<void> updatequantityfailed() async {
    // await progressDialog.hide();
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }
}

class ItemInfo {
  String itemName;
  String itemDescription;
  int itemId;
  String menutype;
  ItemInfo({this.itemName, this.itemDescription, this.itemId, this.menutype});
}

class TableList {
  //geolocation(){}
  String name;
  int restid;
  int id;
  TableList({this.restid, this.id, this.name});
}

class AddTableno {
  int userId;
  int tableId;
  int restId;

  AddTableno({this.restId, this.tableId, this.userId});
}
