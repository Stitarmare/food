import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:foodzi/CartDetailsPage/CartDetailsPage.dart';
import 'package:foodzi/Models/RestaurantItemsList.dart';
import 'package:foodzi/MyCart/MyCartView.dart';
import 'package:foodzi/MyOrders/MyOrders.dart';
import 'package:foodzi/MyprofileBottompage/MyprofileBottompage.dart';
import 'package:foodzi/NotificationBottomPage/NotificationBottomPage.dart';
import 'package:foodzi/RestaurantPage/RestaurantContractor.dart';
import 'package:foodzi/RestaurantPage/RestaurantPresenter.dart';
import 'package:foodzi/RestaurantPage/RestaurantView.dart';
import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/Utils/globle.dart';
import 'package:foodzi/Utils/shared_preference.dart';
import 'package:foodzi/theme/colors.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class BottomTabbarHome extends StatefulWidget {
  String title;
  int restId;
  String lat;
  String long;
  String imageUrl;
  String tableName;
  BottomTabbarHome(
      {this.title,
      this.restId,
      this.lat,
      this.long,
      this.imageUrl,
      this.tableName});
  @override
  State<StatefulWidget> createState() {
    return _BottomTabbarHomeState();
  }
}

class _BottomTabbarHomeState extends State<BottomTabbarHome>
    implements RestaurantModelView {
  var title;
  int tableID;
  int orderID;
  RestaurantPresenter restaurantPresenter;
  int currentTabIndex = 0;
  bool isAlreadyOrder = false;
  List<Widget> tabsHome = [
    RestaurantView(),
    MyOrders(),
    BottomNotificationView(),
    BottomProfileScreen()
  ];

  bool cartStatus = false;
  onTapIndex(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  void initState() {
    getAlreadyInCart();
    restaurantPresenter = RestaurantPresenter(this);
    if (widget.title != null) {
      setState(() {
        tabsHome.setAll(0, [
          RestaurantView(
            title: widget.title,
            restId: widget.restId,
            imageUrl: widget.imageUrl,
          )
        ]);
      });
    }

    if (widget.tableName != null) {
      setState(() {
        tabsHome.setAll(1, [MyOrders(tableName: widget.tableName)]);
      });
    }
    getTableID();
    getOrderID();
    getCartCount();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: 60,
        height: 120,
        child: Column(
          children: <Widget>[
            FittedBox(
              child: FloatingActionButton(
                  backgroundColor: getColorByHex(Globle().colorscode),
                  onPressed: () {
                    if (tableID != null && tableID != 0) {
                      restaurantPresenter.notifyWaiter(
                          Globle().loginModel.data.id, tableID, "", context);
                    }
                  },
                  heroTag: STR_BTN_BUZZER,
                  child: Image.asset(CLOCK_IMAGE_PATH)),
            ),
            SizedBox(
              height: 5,
            ),
            FittedBox(
              child: FloatingActionButton(
                  backgroundColor: getColorByHex(Globle().colorscode),
                  onPressed: () {
                    if (Globle().orderID != null && Globle().orderID != 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartDetailsPage(
                                    orderId: Globle().orderID,
                                    flag: 2,
                                  )));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyCartView(
                                  restId: widget.restId,
                                  lat: widget.lat,
                                  long: widget.long,
                                  orderType: STR_SMALL_DINEIN,
                                  restName: widget.title,
                                  imgUrl: widget.imageUrl)));
                    }
                  },
                  heroTag: STR_BTN_ADD_CART,
                  child: Stack(
                    fit: StackFit.passthrough,
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Icon(Icons.shopping_cart, color: Colors.white),
                      (Globle().dinecartValue != null)
                          ? Globle().dinecartValue > 0
                              ? Positioned(
                                  top: -20,
                                  right: -15,
                                  child: Badge(
                                      badgeColor: redtheme,
                                      badgeContent: Text(
                                          "${Globle().dinecartValue} ",
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.white))))
                              : Text(STR_BLANK)
                          : Text(STR_BLANK)
                    ],
                  )),
            ),
            //
          ],
        ),
      ),
      body: tabsHome[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: onTapIndex,
          currentIndex: currentTabIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  OMIcons.home,
                  color: greytheme100,
                  size: 30,
                ),
                activeIcon: Icon(
                  OMIcons.home,
                  color: orangetheme,
                  size: 30,
                ),
                title: Text('')),
            BottomNavigationBarItem(
                icon: (isAlreadyOrder)
                    ? Stack(
                        fit: StackFit.passthrough,
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Icon(
                            OMIcons.assignment,
                            color: greytheme100,
                            size: 30,
                          ),
                          Positioned(
                            top: -11,
                            right: -11,
                            child: (cartStatus)
                                ? Badge(
                                    badgeColor: redtheme,
                                    badgeContent: Text(STR_ONE,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white)))
                                : Text(STR_BLANK),
                          )
                        ],
                      )
                    : Icon(
                        OMIcons.assignment,
                        color: greytheme100,
                        size: 30,
                      ),
                activeIcon: (isAlreadyOrder)
                    ? Stack(
                        fit: StackFit.passthrough,
                        overflow: Overflow.visible,
                        children: <Widget>[
                          Icon(
                            OMIcons.assignment,
                            color: orangetheme,
                            size: 30,
                          ),
                          Positioned(
                            top: -11,
                            right: -11,
                            child: (cartStatus)
                                ? Badge(
                                    badgeColor: redtheme,
                                    badgeContent: Text(STR_ONE,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white)))
                                : Text(STR_BLANK),
                          )
                        ],
                      )
                    : Icon(
                        OMIcons.assignment,
                        color: orangetheme,
                        size: 30,
                      ),
                title: Text(STR_BLANK)),
            BottomNavigationBarItem(
                icon: Icon(
                  OMIcons.notifications,
                  color: greytheme100,
                  size: 30,
                ),
                activeIcon: Icon(
                  OMIcons.notifications,
                  color: orangetheme,
                  size: 30,
                ),
                title: Text('')),
            BottomNavigationBarItem(
                icon: Icon(
                  OMIcons.personOutline,
                  color: greytheme100,
                  size: 30,
                ),
                activeIcon: Icon(
                  OMIcons.person,
                  color: orangetheme,
                  size: 30,
                ),
                title: Text(STR_BLANK)),
          ]),
    );
  }

  getDineINcartvalue() {
    if (Globle().dinecartValue != null) {
      if (Globle().dinecartValue > 0) {
        return Globle().dinecartValue;
      }
      return;
    }
    return;
  }

  getAlreadyInCart() async {
    var alreadyIncartStatus =
        await Preference.getPrefValue<bool>(PreferenceKeys.isAlreadyINCart);
    if (alreadyIncartStatus == true) {
      setState(() {
        cartStatus = true;
      });
    }
  }

  getOrderID() async {
    var orderId = await Preference.getPrefValue<int>(PreferenceKeys.orderId);
    if (orderId != null) {
      setState(() {
        isAlreadyOrder = true;
        orderID = orderId;
        Globle().orderID = orderID;
      });
    }
  }

  getTableID() async {
    var tableId = await Preference.getPrefValue<int>(PreferenceKeys.tableId);
    if (tableId != null) {
      setState(() {
        tableID = tableId;
      });
      return tableId;
    }
    return;
  }

  getCartCount() async {
    var cartCount =
        await Preference.getPrefValue<int>(PreferenceKeys.dineCartItemCount);
    if (cartCount != null) {
      setState(() {
        Globle().dinecartValue = cartCount;
      });
      return cartCount;
    }
    return;
  }

  @override
  void getMenuListfailed() {
    // TODO: implement getMenuListfailed
  }

  @override
  void getMenuListsuccess(List<RestaurantMenuItem> menulist,
      RestaurantItemsModel restaurantItemsModel) {
    // TODO: implement getMenuListsuccess
  }

  @override
  void notifyWaiterFailed() {
    // TODO: implement notifyWaiterFailed
  }

  @override
  void notifyWaiterSuccess() {
    // TODO: implement notifyWaiterSuccess
  }
}
