import 'dart:collection';
import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:foodzi/AddItemPageDelivery/AddItemDeliveryContractor.dart';
import 'package:foodzi/AddItemPageDelivery/AddItemDeliveryPresenter.dart';
import 'package:foodzi/BottomTabbar/DeliveryBottomTabbar.dart';
import 'package:foodzi/CartDetailsPage/CartDetailsPage.dart';
import 'package:foodzi/Models/AddItemPageModel.dart';
import 'package:foodzi/Models/AddMenuToCartModel.dart';
import 'package:foodzi/Models/GetTableListModel.dart';
import 'package:foodzi/Models/UpdateOrderModel.dart';
import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/Utils/constant.dart';
import 'package:foodzi/Utils/dialogs.dart';
import 'package:foodzi/Utils/globle.dart';
import 'package:foodzi/Utils/shared_preference.dart';
import 'package:foodzi/network/ApiBaseHelper.dart';
import 'package:foodzi/theme/colors.dart';
import 'package:foodzi/widgets/AppTextfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddItemDeliveryPageView extends StatefulWidget {
  String title;
  String description;
  int itemId;
  int restId;
  String restName;
  String itemImage;
  bool isFromOrder = false;
  String lat;
  String long;

  AddItemDeliveryPageView(
      {this.title,
      this.description,
      this.itemId,
      this.restId,
      this.restName,
      this.lat,
      this.long,
      this.itemImage,
      this.isFromOrder});
  _AddItemDeliveryPageViewState createState() =>
      _AddItemDeliveryPageViewState();
}

class _AddItemDeliveryPageViewState extends State<AddItemDeliveryPageView>
    with TickerProviderStateMixin
    implements
        AddItemDeliveryModelView,
        AddmenuToCartModelview,
        AddTablenoModelView,
        GetTableListModelView,
        ClearCartModelView,
        UpdateCartModelView {
  List<bool> isSelected;
  int tableId;
  AddItemsToCartModel addMenuToCartModel;
  GetTableList getTableListModel;
  AddItemPageModelList _addItemPageModelList;
  Item items;
  List<Extras> extra;
  UpdateOrderModel _updateOrderModel;
  Spreads spread;
  Sizes size;
  List<Sizes> sizes;
  bool isAddBtnClicked = false;
  SharedPreferences prefs;
  List<int> listItemIdList = [];
  List<Switches> switches;
  bool isTableList = false;
  List<String> listStrItemId = [];
  List<int> listIntItemId = [];
  int itemIdValue;
  bool getttingLocation = false;
  AddItemModelList _addItemModelList;
  int itemId;
  int restId;
  List<Extras> extras;
  List<Sizes> sizess;
  List<Switches> switchess;
  ScrollController _controller = ScrollController();
  AddItemDeliverypresenter _addItemDeliverypresenter;
  List<TableList> _dropdownItemsTable = [];
  int _dropdownTableNumber;
  int tableID;
  bool alreadyAdded = false;
  int restaurant;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  int sizesid = 1;

  bool isLoding = false;
  ProgressDialog progressDialog;
  String price;

  String specialReq;

  Spreads defaultSpread;
  bool isIgnoreTouch = false;
  bool isLoader = false;

  List<Extras> defaultExtra;

  Sizes defaultSize;
  List<Switches> defaultSwitch;
  @override
  void didChangeDependencies() {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _addItemDeliverypresenter =
        AddItemDeliverypresenter(this, this, this, this, this, this);
    isSelected = [true, false];
    setState(() {
      isLoding = true;
    });

    _addItemPageModelList = AddItemPageModelList();

    _addItemDeliverypresenter.performAddItem(
        widget.itemId, widget.restId, context);
    // _addItemPagepresenter.getTableListno(widget.restId, context);
    itemIdValue = widget.itemId;
    print("${widget.itemImage}");
    // getRequiredSpread(_addItemModelList.spreads.length);
    // getRequiredExtra(_addItemModelList.extras.length);
    // getRequiredSize(_addItemModelList.sizePrizes.length);

    super.initState();
  }

  int radioBtnId;
  int count = 1;
  String radioItem;
  String radioItemsize;
  int subOptionId;
  List<RadioButtonOptions> _subOptionList = [];

  List<RadioButtonOptions> _radioOptions = [];
  List<RadioButtonOptionsSizes> _radioOptionsSizes = [];
  List<CheckBoxOptions> _checkBoxOptions = [];
  List<SwitchesItems> _switchOptions = [];

  int selectedIndex = 0;

  int getradiobtn(int length) {
    List<RadioButtonOptions> radiolist = [];
    for (int i = 1; i <= length; i++) {
      radiolist.add(RadioButtonOptions(
        id: _addItemModelList.spreads[i - 1].id,
        index: i - 1,
        title: _addItemModelList.spreads[i - 1].name ?? STR_BLANK,
        spreadDefault:
            _addItemModelList.spreads[i - 1].spreadDefault ?? STR_BLANK,
      ));
    }

    setState(() {
      var index = 0;
      _radioOptions = radiolist;
      for (var item in radiolist) {
        if (item.spreadDefault == "yes") {
          radioBtnId = item.id;
          index = item.index;
        }
      }

      if (radioBtnId == null) {
        if (_addItemModelList.spreads.length > 0) {
          radioBtnId = _addItemModelList.spreads[0].id;
        }
      }
      selectedIndex = index;
      getSubOption(index);
    });

    return radiolist.length;
  }

  void getSubOption(int index) {
    if (_addItemModelList.spreads.length > 0) {
      if (_addItemModelList.spreads[index].suboptions.length > 0) {
        List<RadioButtonOptions> subOptionRadiolist = [];
        for (var value in _addItemModelList.spreads[index].suboptions) {
          subOptionRadiolist.add(RadioButtonOptions(
            index: value.id,
            title: value.name ?? STR_BLANK,
          ));
        }
        if (subOptionRadiolist.length > 0) {
          _subOptionList = subOptionRadiolist;
          subOptionId = _subOptionList[0].index;
        }
      }
    }
  }

  int getradiobtnsize(int length) {
    List<RadioButtonOptionsSizes> radiolistsize = [];
    for (int i = 1; i <= length; i++) {
      radiolistsize.add(RadioButtonOptionsSizes(
        index: _addItemModelList.sizePrizes[i - 1].id ?? 0,
        title: _addItemModelList.sizePrizes[i - 1].size ?? STR_BLANK,
        secondary: _addItemModelList.sizePrizes[i - 1].price ?? STR_BLANK,
      ));
    }

    setState(() {
      _radioOptionsSizes = radiolistsize;
    });
    return radiolistsize.length;
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

  int checkboxbtn(int length) {
    List<CheckBoxOptions> _checkboxlist = [];
    for (int i = 1; i <= length; i++) {
      _checkboxlist.add(CheckBoxOptions(
        price: _addItemModelList.extras[i - 1].price ?? STR_BLANK,
        isChecked: (_addItemModelList.extras[i - 1].extraDefault == "yes")
            ? true
            : false,
        index: _addItemModelList.extras[i - 1].id ?? 0,
        title: _addItemModelList.extras[i - 1].name ?? STR_BLANK,
        defaultAddition: _addItemModelList.extras[i - 1].extraDefault,
      ));
      // if (_addItemModelList.extras[i - 1].extraDefault == "yes") {
      //   extra.add(_addItemModelList.extras[i - 1] as Extras);
      // }
    }
    setState(() {
      _checkBoxOptions = _checkboxlist;
    });

    return _checkboxlist.length;
  }

  int switchbtn(int length) {
    List<SwitchesItems> _switchlist = [];
    for (int i = 1; i <= length; i++) {
      _switchlist.add(SwitchesItems(
        option1: _addItemModelList.switches[i - 1].option1 ?? STR_BLANK,
        option2: _addItemModelList.switches[i - 1].option2 ?? STR_BLANK,
        index: _addItemModelList.switches[i - 1].id ?? 0,
        title: _addItemModelList.switches[i - 1].name ?? STR_BLANK,
        defaultOption: _addItemModelList.switches[i - 1].switchDefault,
        isSelected: [true, false],
      ));
    }
    setState(() {
      _switchOptions = _switchlist;
    });
    return _switchlist.length;
  }

  Widget steppercount() {
    return Container(
      height: 24,
      width: 150,
      child: Row(children: <Widget>[
        InkWell(
          onTap: () {
            if (count > 1) {
              setState(() {
                --count;
                print(count);
              });
              if (items == null) {
                items = Item();
              }
              items.quantity = count;
            }
          },
          splashColor: ((Globle().colorscode) != null)
              ? getColorByHex(Globle().colorscode)
              : orangetheme300,
          child: Container(
            decoration: BoxDecoration(
                color: ((Globle().colorscode) != null)
                    ? getColorByHex(Globle().colorscode)
                    : orangetheme300,
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
            count.toString(),
            style: TextStyle(
                fontSize: FONTSIZE_16,
                fontFamily: Constants.getFontType(),
                fontWeight: FontWeight.w600,
                color: greytheme700),
          ),
        ),
        InkWell(
          onTap: () {
            if (count < 10) {
              setState(() {
                ++count;
                print(count);
              });
              if (items == null) {
                items = Item();
              }
              items.quantity = count;
            }
          },
          splashColor: Colors.lightBlue,
          child: Container(
            decoration: BoxDecoration(
                color: ((Globle().colorscode) != null)
                    ? getColorByHex(Globle().colorscode)
                    : orangetheme300,
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
    return SafeArea(
      left: false,
      top: false,
      right: false,
      bottom: true,
      child: IgnorePointer(
        ignoring: isIgnoreTouch,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: isLoding
              ? Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Loading",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: FONTSIZE_15,
                              fontFamily: Constants.getFontType(),
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
              : Stack(children: <Widget>[
                  CustomScrollView(
                    controller: _controller,
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
                      : Text(""),
                ]),
          bottomNavigationBar: BottomAppBar(
            child: Container(
              height: 91,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: totalamounttext(),
                  ),
                  GestureDetector(
                    onTap: () async {
                      var alreadyAdde = await Preference.getPrefValue<bool>(
                          PreferenceKeys.isAlreadyINCart);
                      var restauran = await (Preference.getPrefValue<int>(
                          PreferenceKeys.restaurantID));
                      var restaurantName =
                          await (Preference.getPrefValue<String>(
                              PreferenceKeys.restaurantName));
                      var orderId = await Preference.getPrefValue<int>(
                          PreferenceKeys.orderId);

                      if (orderId != null) {
                        if (restauran == widget.restId) {
                          if (_updateOrderModel == null) {
                            _updateOrderModel = UpdateOrderModel();
                          }
                          _updateOrderModel.orderId = orderId;
                          _updateOrderModel.userId =
                              Globle().loginModel.data.id;
                          if (items == null) {
                            items = Item();
                          }
                          List<Extras> extras;
                          if (extra != null) {
                            extras = extra;
                          } else {
                            extras = defaultExtra ?? null;
                          }

                          List<Switches> switchess;
                          if (switches != null) {
                            switchess = switches;
                          } else {
                            switchess = defaultSwitch ?? null;
                          }
                          List<Sizes> sizess;
                          if (size != null) {
                            sizess = [size];
                          } else if (defaultSize != null) {
                            if (defaultSize.sizeid != null) {
                              sizess = [defaultSize];
                            }
                          }

                          _updateOrderModel.items = [items];
                          if (sizess.length > 0) {
                            _updateOrderModel.items[0].sizePriceId =
                                sizess[0].sizeid;
                          }
                          _updateOrderModel.items[0].quantity = count;
                          _updateOrderModel.items[0].itemId = widget.itemId;
                          _updateOrderModel.items[0].preparationNote =
                              specialReq;
                          _updateOrderModel.items[0].extra = extras;
                          _updateOrderModel.items[0].spreads = spread == null
                              ? (defaultSpread != null) ? [defaultSpread] : null
                              : [spread];
                          _updateOrderModel.items[0].switches = switchess;

                          _updateOrderModel.items[0].sizes = sizess;
                          print(_updateOrderModel.toJson());

                          // DialogsIndicator.showLoadingDialog(
                          //     context, _keyLoader, STR_BLANK);
                          // await progressDialog.show();
                          setState(() {
                            isLoader = true;
                          });
                          _addItemDeliverypresenter.updateOrder(
                              _updateOrderModel, context);
                        } else {
                          Constants.showAlert(
                              KEY_INVALIDORDER, KEY_ORDERFROMREST, context);
                        }
                      } else {
                        checkForItemIsAlreadyInCart(
                            alreadyAdde, restauran, restaurantName);
                      }
                    },
                    child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                            color: ((Globle().colorscode) != null)
                                ? getColorByHex(Globle().colorscode)
                                : orangetheme300,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        child: Center(
                          child: Text(
                            STR_ADDTOCART,
                            style: TextStyle(
                                fontFamily: Constants.getFontType(),
                                fontWeight: FontWeight.w600,
                                fontSize: FONTSIZE_16,
                                color: Colors.white),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget totalamounttext() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Container(
          // color: Colors.grey,

          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  '${"Total "}' + '${getCurrencySymbol()}' + '${setPrice()}',
                  style: TextStyle(
                      fontSize: 20,
                      color: redtheme,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }

  String validatepassword(String value) {
    if (value.length == 0) {
      return KEY_PASSWORD_REQUIRED;
    } else if (value.length < 1000) {
      return KEY_THIS_SHOULD_BE_MIN_8_CHAR_LONG;
    }
    return null;
  }

  Future<void> checkForItemIsAlreadyInCart(
      bool alreadyAdde, int restauran, String restaurantName) async {
    if (addMenuToCartModel == null) {
      addMenuToCartModel = AddItemsToCartModel();
    }
    addMenuToCartModel.userId = Globle().loginModel.data.id;
    addMenuToCartModel.restId = widget.restId;
    addMenuToCartModel.tableId = _dropdownTableNumber;
    if (items == null) {
      items = Item();
    }

    if (extra != null) {
      extras = extra;
    } else {
      extras = defaultExtra ?? null;
    }

    if (switches != null) {
      switchess = switches;
    } else {
      switchess = defaultSwitch ?? null;
    }
    if (size != null) {
      sizess = [size];
    } else if (defaultSize != null) {
      if (defaultSize.sizeid != null) {
        sizess = [defaultSize];
      }
    }

    if (extras == null) {
      addItemData(alreadyAdde, restauran, restaurantName);
    } else if (extras.length != 0 &&
        _addItemModelList.extrasrequired == "yes") {
      addItemData(alreadyAdde, restauran, restaurantName);
    } else if (extras.length == 0) {
      DialogsIndicator.showAlert(
          context, "Required Field", "Please select required field");
    }
  }

  void addItemData(
      bool alreadyAdde, int restauran, String restaurantName) async {
    List<SubSpread> subSpread;
    if (subOptionId != null) {
      subSpread = [];
      var sub = SubSpread();
      sub.subspreadId = subOptionId;
      subSpread.add(sub);
    }

    // if (_addItemModelList.spreadsrequired == "yes") {
    //   addMenuToCartModel.items[0].spreads = [];
    // } else {
    //   addMenuToCartModel.items[0].spreads = spread == null ? [] : [spread];
    // }
    addMenuToCartModel.items = [items];
    if (sizess != null) {
      if (sizess.length > 0) {
        addMenuToCartModel.items[0].sizePriceId = sizess[0].sizeid;
      }
    }
    addMenuToCartModel.items[0].itemId = widget.itemId;
    addMenuToCartModel.items[0].preparationNote = specialReq;
    addMenuToCartModel.items[0].extra = extras;
    addMenuToCartModel.items[0].subspreads = subSpread;
    addMenuToCartModel.items[0].spreads = spread == null
        ? (defaultSpread != null) ? [defaultSpread] : null
        : [spread];
    if (sizess != null) {
      if (sizess.length > 0) {
        addMenuToCartModel.items[0].sizePriceId = sizess[0].sizeid;
      }
    }
    addMenuToCartModel.items[0].switches = switchess;
    addMenuToCartModel.items[0].quantity = count;
    addMenuToCartModel.items[0].sizes = sizess;
    print(addMenuToCartModel.toJson());
    if (alreadyAdde != null && restauran != null) {
      if ((widget.restId != restauran) && (alreadyAdde)) {
        cartAlert(
            STR_STARTNEWORDER,
            (restaurantName != null)
                ? STR_YOUR_UNFINIHED_ORDER + "$restaurantName " + STR_WILLDELETE
                : STR_UNFINISHEDORDER,
            context);
      } else {
        //DialogsIndicator.showLoadingDialog(context, _keyLoader, STR_BLANK);
        setState(() {
          isIgnoreTouch = true;
          isLoader = true;
        });
        // await progressDialog.show();
        _addItemDeliverypresenter.performaddMenuToCart(
            addMenuToCartModel, context);
      }
    } else {
      //DialogsIndicator.showLoadingDialog(context, _keyLoader, STR_BLANK);
      setState(() {
        isIgnoreTouch = true;
        isLoader = true;
      });
      // await progressDialog.show();
      _addItemDeliverypresenter.performaddMenuToCart(
          addMenuToCartModel, context);
    }
  }

  void cartAlert(String title, String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
                content: Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, right: 5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: RaisedButton(
                            color: ((Globle().colorscode) != null)
                                ? getColorByHex(Globle().colorscode)
                                : orangetheme300,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              STR_NEWORDER,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: FONTSIZE_15,
                                  fontFamily: Constants.getFontType(),
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              // DialogsIndicator.showLoadingDialog(
                              //    context, _keyLoader, "");
                              Navigator.of(context).pop();
                              callClearCart();
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.32,
                          height: 40,
                          child: RaisedButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: greytheme100),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              STR_CANCEL,
                              style: TextStyle(
                                  fontSize: FONTSIZE_17,
                                  fontFamily: Constants.getFontType(),
                                  fontWeight: FontWeight.w400,
                                  color: greytheme100),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  Widget _foodItemLogo() {
    return Container(
      child: new Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(25.0),
          ),
          border: Border.all(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: CachedNetworkImage(
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            imageUrl: BaseUrl.getBaseUrlImages() + "${widget.itemImage}",
            errorWidget: (context, url, error) => Image.asset(
              RESTAURANT_IMAGE_PATH,
              fit: BoxFit.fill,
            ),
            imageBuilder: (context, imageProvider) => Container(
              height: 195,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10.0),
                  topRight: const Radius.circular(10.0),
                  bottomLeft: const Radius.circular(10.0),
                  bottomRight: const Radius.circular(10.0),
                ),
                image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getmainviewTableno() {
    return SliverToBoxAdapter(
      child: _foodItemLogo(),
    );
  }

  callClearCart() async {
    // await progressDialog.show();
    setState(() {
      isLoader = true;
    });
    _addItemDeliverypresenter.clearCart(context);
    Preference.setPersistData<int>(widget.restId, PreferenceKeys.restaurantID);
    Preference.setPersistData<bool>(true, PreferenceKeys.isAlreadyINCart);
    Preference.setPersistData<String>(
        widget.restName, PreferenceKeys.restaurantName);
    Globle().dinecartValue = 0;
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

  Widget _getOptions() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, left: 26),
                child: Text(
                  StringUtils.capitalize(widget.title),
                  style: TextStyle(
                      fontFamily: Constants.getFontType(),
                      fontSize: FONTSIZE_16,
                      fontWeight: FontWeight.w600,
                      color: greytheme700),
                ),
              ),
              // ),
              Padding(
                padding: EdgeInsets.only(left: 26, top: 12),
                child: Text(
                  StringUtils.capitalize(widget.description),
                  style: TextStyle(
                      fontFamily: Constants.getFontType(),
                      fontSize: FONTSIZE_16,
                      color: greytheme1000),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 26),
                    child: Text(
                      STR_QUANTITY,
                      style: TextStyle(
                          fontFamily: Constants.getFontType(),
                          fontSize: FONTSIZE_16,
                          color: greytheme700),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  steppercount()
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 2,
              ),
              _radioOptions.length == 0
                  ? Container()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 35,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            //margin: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.4),
                                Container(
                                  child: Text(
                                    _addItemModelList.spreadsLabel ??
                                        STR_SPREADS,
                                    style: TextStyle(
                                        fontFamily: Constants.getFontType(),
                                        fontSize: FONTSIZE_16,
                                        color: redtheme),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.13),
                                (_addItemModelList.spreadsrequired == "yes")
                                    ? Center(
                                        child: Container(
                                          decoration:
                                              BoxDecoration(color: redtheme),
                                          width: 65,
                                          height: 20,
                                          child: Center(
                                            child: Text(
                                              STR_REQUIRED,
                                              style: TextStyle(
                                                  fontFamily:
                                                      Constants.getFontType(),
                                                  fontSize: FONTSIZE_10,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 26, top: 8),
                          child: Text(
                            STR_SELECT_OPTION,
                            style: TextStyle(
                                fontFamily: Constants.getFontType(),
                                fontSize: FONTSIZE_12,
                                color: greytheme1000),
                          ),
                        ),
                        _getRadioOptions(),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          thickness: 2,
                        ),
                      ],
                    ),

              _checkBoxOptions.length == 0
                  ? Container()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 35,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.4),
                                Container(
                                  child: Text(
                                    _addItemModelList.extrasLabel ??
                                        STR_ADDITIONS,
                                    style: TextStyle(
                                        fontFamily: Constants.getFontType(),
                                        fontSize: FONTSIZE_16,
                                        color: redtheme),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.1),
                                (_addItemModelList.extrasrequired == "yes")
                                    ? Center(
                                        child: Container(
                                          decoration:
                                              BoxDecoration(color: redtheme),
                                          width: 65,
                                          height: 20,
                                          child: Center(
                                            child: Text(
                                              STR_REQUIRED,
                                              style: TextStyle(
                                                  fontFamily:
                                                      Constants.getFontType(),
                                                  fontSize: FONTSIZE_10,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 26, top: 8),
                          child: Text(
                            STR_MULIPLE_OPTIONS,
                            style: TextStyle(
                                fontFamily: Constants.getFontType(),
                                fontSize: FONTSIZE_12,
                                color: greytheme1000),
                          ),
                        ),
                        _getCheckBoxOptions(),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 2,
                        ),
                      ],
                    ),

              _switchOptions.length == 0
                  ? Container()
                  : Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 35,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.4),
                                Container(
                                  child: Text(
                                    _addItemModelList.switchesLabel ??
                                        STR_SWITCHES,
                                    style: TextStyle(
                                        fontFamily: Constants.getFontType(),
                                        fontSize: FONTSIZE_16,
                                        color: redtheme),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.11),
                                (_addItemModelList.switchesrequired == "yes")
                                    ? Center(
                                        child: Container(
                                          decoration:
                                              BoxDecoration(color: redtheme),
                                          width: 65,
                                          height: 20,
                                          child: Center(
                                            child: Text(
                                              STR_REQUIRED,
                                              style: TextStyle(
                                                  fontFamily:
                                                      Constants.getFontType(),
                                                  fontSize: FONTSIZE_10,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                        togglebutton(),
                        Divider(
                          thickness: 2,
                        ),
                      ],
                    ),

              SizedBox(
                height: 10,
              ),
              _radioOptionsSizes.length == 0
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 35,
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4),
                                  Container(
                                    child: Text(
                                      STR_SIZE,
                                      style: TextStyle(
                                          fontFamily: Constants.getFontType(),
                                          fontSize: FONTSIZE_16,
                                          color: redtheme),
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.21),
                                  Center(
                                    child: Container(
                                      decoration:
                                          BoxDecoration(color: redtheme),
                                      width: 65,
                                      height: 20,
                                      child: Center(
                                        child: Text(
                                          STR_REQUIRED,
                                          style: TextStyle(
                                              fontFamily:
                                                  Constants.getFontType(),
                                              fontSize: FONTSIZE_10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 26, top: 8),
                          child: Text(
                            STR_SELECT_OPTION,
                            style: TextStyle(
                                fontFamily: Constants.getFontType(),
                                fontSize: FONTSIZE_12,
                                color: greytheme1000),
                          ),
                        ),
                      ],
                    ),

              _getRadioOptionsSizes(),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: AppTextField(
                  onChanged: (text) {
                    specialReq = text;
                  },
                  placeHolderName: STR_SPLREQ,
                  validator: validatepassword,
                  onSaved: (String value) {
                    print(value);
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ]),
      ),
    );
  }

  _getRadioOptionsSizes() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _radioOptionsSizes.length > 0
            ? _radioOptionsSizes
                .map((radionBtnsize) => Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: RadioListTile(
                        title: radionBtnsize.title != null
                            ? Text(StringUtils.capitalize(
                                "${radionBtnsize.title}"))
                            : Text(STR_DATA),
                        secondary: Text('${getCurrencySymbol()} ' +
                                "${radionBtnsize.secondary}") ??
                            Text(STR_DATA),
                        groupValue: sizesid,
                        value: radionBtnsize.index,
                        dense: true,
                        activeColor: ((Globle().colorscode) != null)
                            ? getColorByHex(Globle().colorscode)
                            : orangetheme300,
                        onChanged: (val) {
                          setState(() {
                            if (size == null) {
                              size = Sizes();
                            }
                            setState(() {
                              radioItemsize = radionBtnsize.title;
                              print(radionBtnsize.title);
                              sizesid = radionBtnsize.index;
                              size.sizeid = sizesid;
                            });
                          });
                        },
                      ),
                    ))
                .toList()
            : [Container()]);
  }

  _getRadioOptions() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _radioOptions.length > 0
            ? _radioOptions
                .map((radionBtn) => Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      children: <Widget>[
                        RadioListTile(
                          title: radionBtn.title != null
                              ? Text(
                                  StringUtils.capitalize("${radionBtn.title}"))
                              : Text(STR_DATA),
                          // groupValue: (radionBtn.spreadDefault == "yes")
                          //     ? radionBtn.index
                          //     : radioBtnId,
                          groupValue: radioBtnId,
                          value: radionBtn.id,
                          dense: true,
                          activeColor: ((Globle().colorscode) != null)
                              ? getColorByHex(Globle().colorscode)
                              : orangetheme300,
                          onChanged: (val) {
                            setState(() {
                              if (spread == null) {
                                spread = Spreads();
                              }
                              radioBtnId = val;
                              radioItem = radionBtn.title;
                              print(radionBtn.title);
                              var index = 0;
                              _radioOptions.forEach((value) {
                                if (radioBtnId == value.id) {
                                  index = value.index;
                                  selectedIndex = index;
                                }
                              });
                              getSubOption(index);
                              // id = radionBtn.index;
                              spread.spreadId = radioBtnId;
                              print(spread.spreadId);
                            });
                          },
                        ),
                        selectedIndex == radionBtn.index
                            ? Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Column(
                                  children: _subOptionList
                                      .map((subOption) => RadioListTile(
                                            title: radionBtn.title != null
                                                ? Text(StringUtils.capitalize(
                                                    "${subOption.title}"))
                                                : Text(STR_DATA),
                                            // groupValue: (radionBtn.spreadDefault == "yes")
                                            //     ? radionBtn.index
                                            //     : radioBtnId,
                                            groupValue: subOptionId,
                                            value: subOption.index,
                                            dense: true,
                                            activeColor:
                                                ((Globle().colorscode) != null)
                                                    ? getColorByHex(
                                                        Globle().colorscode)
                                                    : orangetheme300,
                                            onChanged: (val) {
                                              setState(() {
                                                subOptionId = val;
                                              });
                                            },
                                          ))
                                      .toList(),
                                ),
                              )
                            : Container()
                      ],
                    )))
                .toList()
            : [Container()]);
  }

  String getCurrencySymbol() {
    if (_addItemPageModelList != null) {
      if (_addItemPageModelList.currencySymbol != null) {
        return _addItemPageModelList.currencySymbol;
      }
    }

    return "";
  }

  String getTotalText() {
    if (_addItemModelList != null) {
      if (_addItemModelList.price != "") {
        double d = double.parse((_addItemModelList.price));
        double doublePrice = d * count;
        String strPrice = doublePrice.toStringAsFixed(2);
        return strPrice;
        // return (double.parse(_addItemModelList.price) * count).toString();
      } else if (_addItemModelList.sizePrizes.length > 0) {
        List<Sizes> sizess;
        if (size != null) {
          sizess = [size];
        } else if (defaultSize != null) {
          if (defaultSize.sizeid != null) {
            sizess = [defaultSize];
          }
        }
        if (sizess != null) {
          if (sizess.length > 0) {
            if (_addItemModelList.sizePrizes.length > 0) {
              for (var itemSize in _addItemModelList.sizePrizes) {
                if (sizess[0].sizeid == itemSize.id) {
                  double douPrice = (double.parse(itemSize.price) * count);
                  String strdoubleSizePrice = douPrice.toStringAsFixed(2);
                  return strdoubleSizePrice;
                  // return (double.parse(itemSize.price) * count).toString();
                }
              }
            }
          }
        }
        double douPrice1 =
            (double.parse(_addItemModelList.sizePrizes[0].price) * count);
        String strdoubleSizePrice1 = douPrice1.toStringAsFixed(2);
        return strdoubleSizePrice1;
        // return (double.parse(_addItemModelList.sizePrizes[0].price) * count)
        //     .toString();
      }
    }
    return "";
  }

  String setPrice() {
    List<Extras> extras;
    if (extra != null) {
      extras = extra;
    } else {
      extras = defaultExtra ?? null;
    }
    var price = getTotalText();
    List<CheckBoxOptions> checkBoxOptionsPrice = [];
    if (_checkBoxOptions != null) {
      if (_checkBoxOptions.length > 0) {
        if (extras != null) {
          for (var check in _checkBoxOptions) {
            for (var ext in extras) {
              if (ext.extraId == check.index) {
                checkBoxOptionsPrice.add(check);
              }
            }
          }
        }
      }
    }

    if (checkBoxOptionsPrice.length > 0) {
      List<CheckBoxOptions> result =
          LinkedHashSet<CheckBoxOptions>.from(checkBoxOptionsPrice).toList();
      var extPirce = 0.0;
      for (var chekc in result) {
        extPirce += double.parse(chekc.price);
      }
      double douPrice = double.parse(price) + extPirce;
      String strdoublePrice = douPrice.toStringAsFixed(2);
      return strdoublePrice;
      // return (double.parse(price) + extPirce).toString();
    }
    return price;
  }

  Widget togglebutton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _switchOptions.length > 0
          ? _switchOptions
              .map((switchs) => Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 28),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                switchs.title ?? STR_BLANK,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: FONTSIZE_16,
                                    fontFamily: Constants.getFontType(),
                                    fontWeight: FontWeight.w500,
                                    color: greytheme700),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 40,
                          child: ToggleButtons(
                              borderColor: greytheme1300,
                              fillColor: ((Globle().colorscode) != null)
                                  ? getColorByHex(Globle().colorscode)
                                  : orangetheme300,
                              borderWidth: 2,
                              selectedBorderColor: Colors.transparent,
                              selectedColor: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              children: <Widget>[
                                Container(
                                  width: 85,
                                  child: Text(
                                    "${switchs.option1}" ?? STR_BLANK,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: FONTSIZE_14,
                                        fontFamily: Constants.getFontType(),
                                        fontWeight: FontWeight.w500,
                                        color: (switchs.isSelected[0] == true)
                                            ? Colors.white
                                            : greytheme700),
                                  ),
                                ),
                                Container(
                                  width: 85,
                                  child: Text(
                                    '${switchs.option2}' ?? STR_BLANK,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: FONTSIZE_14,
                                        fontFamily: Constants.getFontType(),
                                        fontWeight: FontWeight.w500,
                                        color: (switchs.isSelected[1] == false)
                                            ? greytheme700
                                            : Colors.white),
                                  ),
                                ),
                              ],
                              onPressed: (int index) {
                                setState(() {
                                  switchs.isSelected[0] =
                                      !switchs.isSelected[0];
                                  switchs.isSelected[1] =
                                      !switchs.isSelected[1];
                                });
                                if (switches == null) {
                                  switches = [];
                                }
                                if (switches.length > 0) {
                                  for (int i = 0; i < switches.length; i++) {
                                    if (switches[i].switchId == switchs.index) {
                                      if (index == 0) {
                                        switches[i].switchOption =
                                            switchs.option1;
                                      }
                                      if (index == 1) {
                                        switches[i].switchOption =
                                            switchs.option2;
                                      }
                                    } else {
                                      var switchItem = Switches();
                                      switchItem.switchId = switchs.index;
                                      if (index == 0) {
                                        switchItem.switchOption =
                                            switchs.option1;
                                      }
                                      if (index == 1) {
                                        switchItem.switchOption =
                                            switchs.option2;
                                      }
                                      switches.add(switchItem);
                                    }
                                  }
                                } else {
                                  var switchItem = Switches();
                                  switchItem.switchId = switchs.index;
                                  if (index == 0) {
                                    switchItem.switchOption = switchs.option1;
                                  }
                                  if (index == 1) {
                                    switchItem.switchOption = switchs.option2;
                                  }
                                  switches.add(switchItem);
                                }
                              },
                              isSelected: switchs.isSelected),
                        )
                      ],
                    ),
                  ))
              .toList()
          : [Container()],
    );
  }

  _getCheckBoxOptions() {
    return Column(
        children: _checkBoxOptions.length > 0
            ? _checkBoxOptions
                .map((checkBtn) => CheckboxListTile(
                    activeColor: ((Globle().colorscode) != null)
                        ? getColorByHex(Globle().colorscode)
                        : orangetheme300,
                    value: checkBtn.isChecked,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (val) {
                      setState(() {
                        if (extra == null) {
                          extra = [];
                        }
                        if (extra.length > 0) {
                          if (val) {
                            var ext = Extras();
                            ext.extraId = checkBtn.index;
                            extra.add(ext);
                          } else {
                            for (int i = 0; i < extra.length; i++) {
                              if (checkBtn.index == extra[i].extraId) {
                                extra.removeAt(i);
                              }
                            }
                          }
                        } else {
                          var ext = Extras();
                          ext.extraId = checkBtn.index;
                          extra.add(ext);
                        }
                        checkBtn.isChecked = val;
                      });
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          checkBtn.title != null
                              ? StringUtils.capitalize(checkBtn.title)
                              : STR_BLANK,
                          style: TextStyle(fontSize: 13, color: greytheme700),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 100,
                          ),
                          flex: 2,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Text(
                              "${getCurrencySymbol()} " +
                                      checkBtn.price.toString() ??
                                  STR_BLANK,
                              style: TextStyle(
                                  fontSize: FONTSIZE_13, color: greytheme700),
                            ),
                          ),
                        ),
                        // ),
                      ],
                    )))
                .toList()
            : [Container()]);
  }

  void showAlertSuccess(String title, String message, BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text(
                  StringUtils.capitalize(title),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FONTSIZE_18,
                      fontFamily: Constants.getFontType(),
                      fontWeight: FontWeight.w600,
                      color: greytheme700),
                ),
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Image.asset(
                    SUCCESS_IMAGE_PATH,
                    width: 75,
                    height: 75,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    StringUtils.capitalize(message),
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
                      Navigator.of(context).pop();
                      // Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeliveryBottomTabbarHome(
                                    title: widget.restName,
                                    restId: widget.restId,
                                    lat: widget.lat,
                                    long: widget.long,
                                    imageUrl: widget.itemImage,
                                  )),
                          ModalRoute.withName(STR_RETAURANT_PAGE));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => DeliveryBottomTabbarHome(
                      //           title: widget.restName,
                      //           restId: widget.restId,
                      //           lat: widget.lat,
                      //           long: widget.long,
                      //           imageUrl: widget.itemImage,
                      //         )));
                    },
                  )
                ],
              ),
            ));
  }

  void showAlertUpdateOrderSuccess(
      String title, String message, BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text(
                  StringUtils.capitalize(title),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: FONTSIZE_18,
                      fontFamily: Constants.getFontType(),
                      fontWeight: FontWeight.w600,
                      color: greytheme700),
                ),
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Image.asset(
                    SUCCESS_IMAGE_PATH,
                    width: 75,
                    height: 75,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    StringUtils.capitalize(message),
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
                      Navigator.of(context).pop();
                      if (widget.isFromOrder) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CartDetailsPage(
                                  orderId: _updateOrderModel.orderId,
                                  flag: 1,
                                  isFromOrder: false,
                                )));
                      }

                      // Navigator.of(context).pop();
                      // Navigator.of(context).pop();
                      //Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ));
  }

  @override
  void addItemfailed() {
    setState(() {
      isLoding = false;
      isIgnoreTouch = false;
      isLoader = false;
    });
  }

  @override
  void addItemsuccess(List<AddItemModelList> _additemlist,
      AddItemPageModelList addItemPageModelList1) {
    setState(() {
      isLoding = false;
      isIgnoreTouch = false;
      isLoader = false;

      _addItemPageModelList = addItemPageModelList1;
    });
    _addItemModelList = _additemlist[0];

    getradiobtn(_addItemModelList.spreads.length);
    getRequiredSpread(_addItemModelList.spreads.length);

    getradiobtnsize(_addItemModelList.sizePrizes.length);
    getRequiredSize(_addItemModelList.sizePrizes.length);

    checkboxbtn(_addItemModelList.extras.length);
    getRequiredExtra(_addItemModelList.extras.length);

    switchbtn(_addItemModelList.switches.length);
    getRequiredSwitch(_addItemModelList.switches.length);
    // setState(() {

    // });
    // Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
  }

  @override
  Future<void> addMenuToCartfailed() async {
    await progressDialog.hide();
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
  }

  @override
  Future<void> addMenuToCartsuccess() async {
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
    specialReq = "";
    if (Globle().dinecartValue == null) {
      Globle().dinecartValue = 0;
    }
    Globle().dinecartValue += 1;
    Preference.setPersistData<int>(
        Globle().dinecartValue, PreferenceKeys.dineCartItemCount);
    Preference.setPersistData(widget.restId, PreferenceKeys.restaurantID);
    Preference.setPersistData(true, PreferenceKeys.isAlreadyINCart);
    Preference.setPersistData(widget.restName, PreferenceKeys.restaurantName);
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
    await progressDialog.hide();
    showAlertSuccess(
        "${widget.title}", "${widget.title} " + STR_CARTADDED, context);
  }

  @override
  Future<void> addTablebnoSuccces() async {
    await progressDialog.hide();
    await progressDialog.hide();
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
  }

  @override
  Future<void> addTablenofailed() async {
    await progressDialog.hide();
    await progressDialog.hide();
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
  }

  @override
  Future<void> getTableListFailed() async {
    await progressDialog.hide();
    await progressDialog.hide();
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
  }

  @override
  Future<void> getTableListSuccess(List<GetTableList> _getlist) async {
    await progressDialog.hide();
    await progressDialog.hide();
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
    // getTableListModel = _getlist[0];
    if (_getlist.length > 0) {
      gettablelist(_getlist);
    }

    //Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
  }

  @override
  void clearCartFailed() {
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
  }

  @override
  Future<void> clearCartSuccess() async {
    await progressDialog.hide();
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
    Preference.setPersistData(null, PreferenceKeys.restaurantID);
    Preference.setPersistData(null, PreferenceKeys.isAlreadyINCart);
    Preference.setPersistData(null, PreferenceKeys.restaurantName);
  }

  @override
  void updateOrderFailed() {
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
  }

  @override
  Future<void> updateOrderSuccess() async {
    setState(() {
      isIgnoreTouch = false;
      isLoader = false;
    });
    specialReq = "";
    Globle().dinecartValue += 1;
    await progressDialog.hide();
    //Navigator.of(_keyLoader.currentContext, rootNavigator: true)..pop();
    showAlertUpdateOrderSuccess(
        "${widget.title}", "${widget.title} " + STR_CARTADDED, context);
  }

  void getRequiredSpread(int length) {
    Spreads defaultSpre;
    for (int i = 1; i <= length; i++) {
      if (_addItemModelList.spreads[i - 1].spreadDefault == "yes") {
        // defaultSpread = _addItemModelList.spreads[i - 1] as Spreads;
        defaultSpre = Spreads();
        defaultSpre.spreadId = _addItemModelList.spreads[i - 1].id;
      }
    }
    if (defaultSpre == null) {
      if (_addItemModelList.spreads.length > 0) {
        defaultSpre = Spreads();
        defaultSpre.spreadId = _addItemModelList.spreads[0].id;
      }
    }

    defaultSpread = defaultSpre;
    defaultSpread = defaultSpre;
  }

  void getRequiredExtra(int length) {
    Extras extradefault = Extras();
    defaultExtra = [];
    for (int i = 1; i <= length; i++) {
      if (_addItemModelList.extras[i - 1].extraDefault == "yes") {
        extradefault.extraId = (_addItemModelList.extras[i - 1].id);
        defaultExtra.add(extradefault);
      }
    }
    if (defaultExtra.length > 0) {
      extra = defaultExtra;
    }
    if (defaultExtra.length == 0) {
      defaultExtra = null;
    }
  }

  void getRequiredSize(int length) {
    if (_addItemModelList.sizePrizes.length > 0) {
      defaultSize = Sizes();
      setState(() {
        //defaultSize = _addItemModelList.sizePrizes[0] as Sizes;
        defaultSize.sizeid = _addItemModelList.sizePrizes[0].id;
      });
      setState(() {
        sizesid = defaultSize.sizeid;
      });
      print(defaultSize);
    }
  }

  void getRequiredSwitch(int length) {
    for (int i = 1; i <= length; i++) {
      Switches requiredSwitch = Switches();
      defaultSwitch = List<Switches>();
      if (_addItemModelList.switches[i - 1].switchDefault == "yes") {
        requiredSwitch.switchId = (_addItemModelList.switches[i - 1].id);
        requiredSwitch.switchOption = _addItemModelList.switches[i - 1].option1;
        defaultSwitch.add(requiredSwitch);
      }
    }
    if (defaultSwitch.length == 0) {
      defaultSwitch = null;
    }
  }
}

class CheckBoxOptions {
  int index;
  String title;
  String price;
  bool isChecked;
  String defaultAddition;

  CheckBoxOptions(
      {this.index,
      this.title,
      this.price,
      this.isChecked,
      this.defaultAddition});
}

class RadioButtonOptions {
  int id;
  int index;
  String title;
  String spreadDefault;
// bool selected;
  RadioButtonOptions({this.index, this.title, this.spreadDefault, this.id});
}

class RadioButtonOptionsSizes {
  int index;
  String title;
  String secondary;

  RadioButtonOptionsSizes({this.index, this.title, this.secondary});
}

class SwitchesItems {
  int index;
  String title;
  String option1;
  List<bool> isSelected;
  String option2;
  String defaultOption;
  SwitchesItems(
      {this.index,
      this.title,
      this.option1,
      this.option2,
      this.isSelected,
      this.defaultOption});
}

class TableList {
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
