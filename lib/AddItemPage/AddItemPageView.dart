import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodzi/AddItemPage/ADdItemPagePresenter.dart';
import 'package:foodzi/AddItemPage/AddItemPageContractor.dart';
import 'package:foodzi/Models/AddItemPageModel.dart';
import 'package:foodzi/Models/AddMenuToCartModel.dart';
import 'package:foodzi/Models/GetTableListModel.dart';
import 'package:foodzi/Models/UpdateOrderModel.dart';
import 'package:foodzi/Utils/constant.dart';
import 'package:foodzi/Utils/globle.dart';
import 'package:foodzi/Utils/shared_preference.dart';
import 'package:foodzi/network/ApiBaseHelper.dart';
import 'package:foodzi/theme/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddItemPageView extends StatefulWidget {
  String title;
  String description;
  int item_id;
  int rest_id;
  String restName;
  String itemImage;

  AddItemPageView(
      {this.title,
      this.description,
      this.item_id,
      this.rest_id,
      this.restName,
      this.itemImage});
  _AddItemPageViewState createState() => _AddItemPageViewState();
}

class _AddItemPageViewState extends State<AddItemPageView>
    implements
        AddItemPageModelView,
        AddmenuToCartModelview,
        AddTablenoModelView,
        GetTableListModelView,
        ClearCartModelView,
        UpdateCartModelView {
  List<bool> isSelected;

  int table_id;

  AddItemsToCartModel addMenuToCartModel;

  GetTableList getTableListModel;
  AddItemPageModelList _addItemPageModelList;

  Item items;

  List<Extras> extra;
  UpdateOrderModel _updateOrderModel;

  Spreads spread;
  bool isAddBtnClicked = false;
  SharedPreferences prefs;
  List<int> listItemIdList = [];

  List<Switches> switches;
  bool isTableList = false;
  List<String> listStrItemId = [];
  List<int> listIntItemId = [];
  int itemIdValue;
  //String strDefaultTxt = 'ADD \$24';

  bool getttingLocation = false;
  StreamController<Position> _controllerPosition = new StreamController();

  AddItemModelList _addItemModelList;
  int item_id;
  int rest_id;
  ScrollController _controller = ScrollController();

  AddItemPagepresenter _addItemPagepresenter;
  List<TableList> _dropdownItemsTable = [];
  List<AddTableno> _addtableno = [];

  int _dropdownTableNumber;

  int tableID;
  bool alreadyAdded = false;
  int restaurant;

  @override
  void initState() {
    _addItemPagepresenter =
        AddItemPagepresenter(this, this, this, this, this, this);
    isSelected = [true, false];
    _addItemPageModelList = AddItemPageModelList();
    _addItemPagepresenter.performAddItem(
        widget.item_id, widget.rest_id, context);
    _addItemPagepresenter.getTableListno(widget.rest_id, context);
    itemIdValue = widget.item_id;
    print("${widget.itemImage}");
    super.initState();
  }

  // double _defaultValue = 1;
  int id = 1;
  int count = 1;
  String radioItem;
  String _selectedId;

  // FLCountStepperController _stepperController =
  //     FLCountStepperController(defaultValue: 1, min: 1, max: 10, step: 1);
  List<RadioButtonOptions> _radioOptions = [];
  List<CheckBoxOptions> _checkBoxOptions = [];
  List<SwitchesItems> _switchOptions = [];

  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }

  int getradiobtn(int length) {
    List<RadioButtonOptions> radiolist = [];
    for (int i = 1; i <= length; i++) {
      radiolist.add(RadioButtonOptions(
        index: _addItemModelList.spreads[i - 1].id,
        title: _addItemModelList.spreads[i - 1].name ?? '',
        //price: _addItemModelList.spreads[i - 1].price ?? '0'
      ));
    }
    //radiolist.add(RadioButtonOptions(index:0,title: "None" ,price: '0'));
    // for (int i = length; i <= length+1; i++) {
    //   radiolist.add(RadioButtonOptions(
    //       index: _addItemModelList.spreads[i].id,
    //       title: 'none')
    //       );

    // }
    setState(() {
      _radioOptions = radiolist;
    });
  }

  int gettablelist(List<GetTableList> getlist) {
    List<TableList> _tablelist = [];
    for (int i = 0; i < getlist.length; i++) {
      _tablelist.add(TableList(
        id: getlist[i].id,
        restid: widget.rest_id,
        name: getlist[i].tableName,
      ));
    }
    setState(() {
      _dropdownItemsTable = _tablelist;
    });
    getlistoftable();
  }

  // _getLocationtablelist(int length) async {
  //   setState(() {
  //     getttingLocation = false;
  //   });
  //   var strim = await GeoLocationTracking.load(context, _controllerPosition);
  //   _controllerPosition.stream.listen((position) {
  //     print(position);
  //     _position = position;
  //     if (_position != null) {
  //       setState(() {
  //         getttingLocation = true;
  //       });
  //       // DialogsIndicator.showLoadingDialog(context, _keyLoader, "Please Wait");
  //       _addItemPagepresenter.getTableListno(_position.latitude.toString(),
  //           widget.rest_id, _position.longitude.toString(), context);

  //       List<TableList> _tablelist = [];
  //       for (int i; i < _tablelist.length; i++) {
  //         _tablelist.add(TableList(
  //           restid: widget.rest_id,
  //         ));
  //       }
  //       setState(() {
  //         _tablelist = _dropdownItemsTable;
  //       });
  //     } else {
  //       setState(() {
  //         getttingLocation = false;
  //       });
  //     }
  //   });
  // }

  int checkboxbtn(int length) {
    List<CheckBoxOptions> _checkboxlist = [];
    for (int i = 1; i <= length; i++) {
      _checkboxlist.add(CheckBoxOptions(
          price: _addItemModelList.extras[i - 1].price ?? '',
          isChecked: false,
          index: _addItemModelList.extras[i - 1].id ?? 0,
          title: _addItemModelList.extras[i - 1].name ?? ''));
    }
    setState(() {
      _checkBoxOptions = _checkboxlist;
    });
  }

  int switchbtn(int length) {
    List<SwitchesItems> _switchlist = [];
    for (int i = 1; i <= length; i++) {
      _switchlist.add(SwitchesItems(
          option1: _addItemModelList.switches[i - 1].option1 ?? "",
          option2: _addItemModelList.switches[i - 1].option2 ?? "",
          index: _addItemModelList.switches[i - 1].id ?? 0,
          title: _addItemModelList.switches[i - 1].name ?? '',
          isSelected: [true, false]));
    }

    setState(() {
      _switchOptions = _switchlist;
    });
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
              items.quantity = count;
            }
          },
          splashColor: ((Globle().colorscode) != null)
              ? getColorByHex(Globle().colorscode)
              : orangetheme,
          child: Container(
            decoration: BoxDecoration(
                color: ((Globle().colorscode) != null)
                    ? getColorByHex(Globle().colorscode)
                    : orangetheme,
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
                fontSize: 16,
                fontFamily: 'gotham',
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
              items.quantity = count;
            }
          },
          splashColor: Colors.lightBlue,
          child: Container(
            decoration: BoxDecoration(
                color: ((Globle().colorscode) != null)
                    ? getColorByHex(Globle().colorscode)
                    : orangetheme,
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
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[
            _getmainviewTableno(),
            // _getItemImage(),
            _getOptions()
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: GestureDetector(
            onTap: () async {
              var alreadyAdde = await Preference.getPrefValue<bool>(
                  PreferenceKeys.isAlreadyINCart);
              var restauran = await (Preference.getPrefValue<int>(
                  PreferenceKeys.restaurantID));
              var restaurantName = await (Preference.getPrefValue<String>(
                  PreferenceKeys.restaurantName));
              var orderId =
                  await Preference.getPrefValue<int>(PreferenceKeys.ORDER_ID);
              if (orderId != null) {
                if (restauran == widget.rest_id) {
                  print("object");
                  if (_updateOrderModel == null) {
                    _updateOrderModel = UpdateOrderModel();
                  }
                  _updateOrderModel.orderId = orderId;
                  _updateOrderModel.userId = Globle().loginModel.data.id;
                  if (items == null) {
                    items = Item();
                  }

                  _updateOrderModel.items = items;
                  _updateOrderModel.items.quantity = count;
                  _updateOrderModel.items.itemId = widget.item_id;
                  _updateOrderModel.items.extra = extra ?? null;
                  _updateOrderModel.items.spreads =
                      spread == null ? [] : [spread];
                  _updateOrderModel.items.switches = switches ?? [];

                  print(_updateOrderModel.toJson());
                  _addItemPagepresenter.updateOrder(_updateOrderModel, context);
                } else {
                  //pop up
                  Constants.showAlert(
                      "Invalid Order",
                      "Sorry, you can't order from this restaurant right now.",
                      context);
                }
              } else {
                checkForItemIsAlreadyInCart(
                    alreadyAdde, restauran, restaurantName);
              }

              // if (Globle().orderNumber != null) {
              //   if (widget.rest_id == ) {

              //   } else {
              //   }
              // } else {

              // }
              // setState(() {
              // Navigator.pushNamed(context, '/OrderConfirmationView');
              // print("button is pressed");
              // showDialog(
              //   context: context,
              //   child: new RadioDialog(
              //     onValueChange: _onValueChange,
              //     initialValue: _selectedId,
              //   ));
            },
            child: Container(
                height: 54,
                decoration: BoxDecoration(
                    color: ((Globle().colorscode) != null)
                        ? getColorByHex(Globle().colorscode)
                        : orangetheme,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                // color: redtheme,
                child: Center(
                  child: Text(
                    "Add To Cart",
                    style: TextStyle(
                        fontFamily: 'gotham',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  void checkForItemIsAlreadyInCart(
      bool alreadyAdde, int restauran, String restaurantName) {
    if (addMenuToCartModel == null) {
      addMenuToCartModel = AddItemsToCartModel();
    }
    addMenuToCartModel.userId = Globle().loginModel.data.id;
    addMenuToCartModel.restId = widget.rest_id;
    addMenuToCartModel.tableId = _dropdownTableNumber;
    if (items == null) {
      items = Item();
    }

    addMenuToCartModel.items = [items];
    addMenuToCartModel.items[0].itemId = widget.item_id;
    addMenuToCartModel.items[0].extra = extra ?? [];
    addMenuToCartModel.items[0].spreads = spread == null ? [] : [spread];
    addMenuToCartModel.items[0].switches = switches ?? [];
    addMenuToCartModel.items[0].quantity = count;
    // }
    //);
    print(addMenuToCartModel.toJson());
    if (alreadyAdde != null && restauran != null) {
      if ((widget.rest_id != restauran) && (alreadyAdde)) {
        cartAlert(
            "Start a new order?",
            (restaurantName != null)
                ? "Your unfinished order at $restaurantName will be deleted."
                : "Your unfinished order at previous hotel will be deleted.",
            context);
      } else {
        _addItemPagepresenter.performaddMenuToCart(addMenuToCartModel, context);
      }
    } else {
      _addItemPagepresenter.performaddMenuToCart(addMenuToCartModel, context);
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
                                : orangetheme,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "NEW ORDER",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'gotham',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              _addItemPagepresenter.clearCart(context);
                              Preference.setPersistData<int>(
                                  widget.rest_id, PreferenceKeys.restaurantID);
                              Preference.setPersistData<bool>(
                                  true, PreferenceKeys.isAlreadyINCart);
                              Preference.setPersistData<String>(widget.restName,
                                  PreferenceKeys.restaurantName);
                              Globle().dinecartValue = 0;
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                          //width: 10,
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
                              "CANCEL",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'gotham',
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

  Widget _getItemImage() {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      height: 100,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Image.asset(
        "assets/PlaceholderFoodImage/MaskGroup55.png",
        fit: BoxFit.contain,
        width: double.infinity,
        height: 100,
      ),
      imageUrl: BaseUrl.getBaseUrlImages() + '${widget.itemImage}',
    );
  }

  Widget _getmainviewTableno() {
    return SliverToBoxAdapter(
      child: Container(
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      widget.title ?? '',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'gotham',
                          fontWeight: FontWeight.w600,
                          color: greytheme700),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 2,
                //endIndent: 10,
                //indent: 10,
              ),
              Row(
                children: <Widget>[
                  // SizedBox(
                  //   width: 26,
                  // ),
                  // Image.asset('assets/DineInImage/Group1504.png'),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Dine-in',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'gotham',
                        fontWeight: FontWeight.w600,
                        color: ((Globle().colorscode) != null)
                            ? getColorByHex(Globle().colorscode)
                            : orangetheme),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //isTableList ? getTableNumber() : Container(),
              // Row(
              //   children: <Widget>[
              //     SizedBox(width: 20),
              //     Text(
              //       'Add Table Number',
              //       textAlign: TextAlign.start,
              //       style: TextStyle(
              //           decoration: TextDecoration.underline,
              //           decorationColor: Colors.black,
              //           fontSize: 14,
              //           fontFamily: 'gotham',
              //           fontWeight: FontWeight.w600,
              //           color: greytheme100),
              //     )
              //   ],
              // ),
              // SizedBox(
              //   height: 10,
              // )
            ],
          ),
        ),
      ),
    );
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

  // Widget getTableNumber() {
  //   return Container(
  //     margin: EdgeInsets.only(left: 20),
  //     height: 50,
  //     width: MediaQuery.of(context).size.width * 0.8,
  //     child: FormField(builder: (FormFieldState state) {
  //       return DropdownButtonFormField(
  //         //itemHeight: Constants.getScreenHeight(context) * 0.06,
  //         items: _dropdownItemsTable.map((tableNumber) {
  //           return new DropdownMenuItem(
  //               value: tableNumber.id,
  //               child: Row(
  //                 children: <Widget>[
  //                   Container(
  //                       width: MediaQuery.of(context).size.width * 0.4,
  //                       child: Text(
  //                         "Table Number: ${tableNumber.name}",
  //                         style: TextStyle(
  //                             decoration: TextDecoration.underline,
  //                             decorationColor:
  //                                 getColorByHex(Globle().colorscode),
  //                             fontSize: 14,
  //                             fontFamily: 'gotham',
  //                             fontWeight: FontWeight.w600,
  //                             color: getColorByHex(Globle().colorscode)),
  //                       )),
  //                 ],
  //               ));
  //         }).toList(),
  //         onChanged: (newValue) {
  //           // do other stuff with _category
  //           setState(() {
  //             _dropdownTableNumber = newValue;
  //           });
  //           _addItemPagepresenter.addTablenoToCart(Globle().loginModel.data.id,
  //               widget.rest_id, _dropdownTableNumber, context);
  //         },

  //         value: _dropdownTableNumber,
  //         decoration: InputDecoration(
  //           contentPadding: EdgeInsets.fromLTRB(10, 0, 5, 0),
  //           focusedBorder: OutlineInputBorder(
  //             borderSide: BorderSide(color: greentheme100, width: 2),
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: greytheme900, width: 2)),
  //           border:
  //               OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
  //           filled: false,
  //           hintText: 'Choose Table',
  //           // prefixIcon: Icon(
  //           //   Icons.location_on,
  //           //   size: 20,
  //           //   color: greytheme1000,
  //           // ),
  //           labelText: _dropdownTableNumber == null
  //               ? "Add Table Number "
  //               : "Table Number",
  //           // errorText: _errorText,
  //           labelStyle: TextStyle(
  //               decoration: TextDecoration.underline,
  //               decorationColor: Colors.black,
  //               fontSize: 14,
  //               fontFamily: 'gotham',
  //               fontWeight: FontWeight.w600,
  //               color: greytheme100),
  //         ),
  //       );
  //     }),
  //   );
  // }

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
                  widget.title,
                  style: TextStyle(
                      fontFamily: 'gotham',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: greytheme700),
                ),
              ),
              // ),
              Padding(
                padding: EdgeInsets.only(left: 26, top: 12),
                child: Text(
                  widget.description,
                  style: TextStyle(
                      fontFamily: 'gotham',
                      fontSize: 16,
                      // fontWeight: FontWeight.w500,
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
                      'Quantity:',
                      style: TextStyle(
                          fontFamily: 'gotham',
                          fontSize: 16,
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
              Padding(
                padding: EdgeInsets.only(left: 26, top: 15),
                child: Text(
                  'Spreads',
                  style: TextStyle(
                      fontFamily: 'gotham', fontSize: 16, color: greytheme700),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 26, top: 8),
                child: Text(
                  'Please select any one option',
                  style: TextStyle(
                      fontFamily: 'gotham', fontSize: 12, color: greytheme1000),
                ),
              ),
              _getRadioOptions(),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 2,
              ),
              Padding(
                padding: EdgeInsets.only(left: 26, top: 15),
                child: Text(
                  'Additions',
                  style: TextStyle(
                      fontFamily: 'gotham', fontSize: 16, color: greytheme700),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 26, top: 8),
                child: Text(
                  'You can select multiple options',
                  style: TextStyle(
                      fontFamily: 'gotham', fontSize: 12, color: greytheme1000),
                ),
              ),
              _getCheckBoxOptions(),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              togglebutton(),
            ]),
      ),
    );
  }

  _getRadioOptions() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.baseline,
        children: _radioOptions.length > 0
            ? _radioOptions
                .map((radionBtn) => Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: RadioListTile(
                        title: Text("${radionBtn.title}") ?? Text('data'),
                        groupValue: id,
                        value: radionBtn.index,
                        dense: true,
                        activeColor: ((Globle().colorscode) != null)
                            ? getColorByHex(Globle().colorscode)
                            : orangetheme,
                        onChanged: (val) {
                          setState(() {
                            if (spread == null) {
                              spread = Spreads();
                            }
                            radioItem = radionBtn.title;
                            print(radionBtn.title);
                            id = radionBtn.index;
                            spread.spreadId = id;
                          });
                        },
                      ),
                    ))
                .toList()
            : [Container()]);
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
                                switchs.title ?? "",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'gotham',
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
                                  : orangetheme,
                              borderWidth: 2,
                              selectedBorderColor: Colors.transparent,
                              selectedColor: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              children: <Widget>[
                                Container(
                                  width: 85,
                                  child: Text(
                                    "${switchs.option1}" ?? "",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'gotham',
                                        fontWeight: FontWeight.w500,
                                        color: (switchs.isSelected[0] == true)
                                            ? Colors.white
                                            : greytheme700),
                                  ),
                                ),
                                Container(
                                  width: 85,
                                  child: Text(
                                    '${switchs.option2}' ?? "",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'gotham',
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
                        : orangetheme,
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
                          checkBtn.title ?? '',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color.fromRGBO(64, 64, 64, 1)),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 100,
                          ),
                          flex: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Text(
                            "${_addItemPageModelList.currencySymbol} " +
                                    checkBtn.price.toString() ??
                                '',
                            style: TextStyle(
                                fontSize: 13,
                                color: Color.fromRGBO(64, 64, 64, 1)),
                          ),
                        ),
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
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'gotham',
                      fontWeight: FontWeight.w600,
                      color: greytheme700),
                ),
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Image.asset(
                    'assets/SuccessIcon/success.png',
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
                        fontSize: 15,
                        fontFamily: 'gotham',
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
                    child: Text("Ok",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'gotham',
                            fontWeight: FontWeight.w600,
                            color: greytheme700)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => RestaurantView()));
                      //Navigator.of(context, rootNavigator: true).pop();
                    },
                  )
                ],
              ),
            ));
  }

  @override
  void addItemfailed() {}

  @override
  void addItemsuccess(List<AddItemModelList> _additemlist,
      AddItemPageModelList addItemPageModelList1) {
    _addItemModelList = _additemlist[0];

    getradiobtn(_addItemModelList.spreads.length);

    checkboxbtn(_addItemModelList.extras.length);

    switchbtn(_addItemModelList.switches.length);
    setState(() {
      _addItemPageModelList = addItemPageModelList1;
    });
  }

  @override
  void addMenuToCartfailed() {}

  @override
  void addMenuToCartsuccess() {
    Globle().dinecartValue += 1;
    Preference.setPersistData(
        Globle().dinecartValue, PreferenceKeys.dineCartItemCount);
    Preference.setPersistData(widget.rest_id, PreferenceKeys.restaurantID);
    Preference.setPersistData(true, PreferenceKeys.isAlreadyINCart);
    Preference.setPersistData(widget.restName, PreferenceKeys.restaurantName);

    showAlertSuccess("${widget.title}",
        "${widget.title} is successfully added to your cart.", context);
//Navigator.of(context).pop();
  }

  @override
  void addTablebnoSuccces() {
    // TODO: implement addTablebnoSuccces
  }

  @override
  void addTablenofailed() {
    // TODO: implement addTablenofailed
  }

  @override
  void getTableListFailed() {
    // TODO: implement getTableListFailed
  }

  @override
  void getTableListSuccess(List<GetTableList> _getlist) {
    getTableListModel = _getlist[0];
    if (_getlist.length > 0) {
      gettablelist(_getlist);
    }

    // TODO: implement getTableListSuccess
  }

  @override
  void clearCartFailed() {
    // TODO: implement clearCartFailed
  }

  @override
  void clearCartSuccess() {
    Preference.setPersistData(null, PreferenceKeys.restaurantID);
    Preference.setPersistData(null, PreferenceKeys.isAlreadyINCart);
    Preference.setPersistData(null, PreferenceKeys.restaurantName);
    // TODO: implement clearCartSuccess
  }

  @override
  void updateOrderFailed() {
    // TODO: implement updateOrderFailed
  }

  @override
  void updateOrderSuccess() {
    // TODO: implement updateOrderSuccess
    //Globle().dinecartValue += 1;
    //Preference.setPersistData(widget.rest_id, PreferenceKeys.restaurantID);
    //Preference.setPersistData(true, PreferenceKeys.isAlreadyINCart);
    //Preference.setPersistData(widget.restName, PreferenceKeys.restaurantName);
    showAlertSuccess("${widget.title}",
        "${widget.title} is successfully added to your cart.", context);
  }
}

// OrderConfirmationView
class CheckBoxOptions {
  int index;
  String title;
  String price;
  // double price;
  bool isChecked;

  CheckBoxOptions({
    this.index,
    this.title,
    this.price,
    this.isChecked,
  });
}

class RadioButtonOptions {
  int index;
  String title;

  RadioButtonOptions({this.index, this.title});
}

class SwitchesItems {
  int index;
  String title;
  String option1;
  List<bool> isSelected;
  String option2;
  SwitchesItems(
      {this.index, this.title, this.option1, this.option2, this.isSelected});
}

class TableList {
  //geolocation(){}
  String name;
  int restid;
  int id;
  TableList({this.restid, this.id, this.name});
}

class AddTableno {
  int user_id;
  int table_id;
  int rest_id;

  AddTableno({this.rest_id, this.table_id, this.user_id});
}
