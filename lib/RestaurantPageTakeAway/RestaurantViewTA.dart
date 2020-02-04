import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodzi/Models/RestaurantListModel.dart';
import 'package:foodzi/RestaurantInfoPage/RestaurantInfoView.dart';
import 'package:foodzi/RestaurantPage/RestaurantContractor.dart';
import 'package:foodzi/RestaurantPage/RestaurantPresenter.dart';
import 'package:foodzi/RestaurantPageTakeAway/RestaurantTAContractor.dart';
import 'package:foodzi/Utils/String.dart';

import 'package:foodzi/widgets/MenuItemDropDown.dart';

import 'package:foodzi/theme/colors.dart';
import 'package:foodzi/widgets/MenuItemDropDown.dart';

import 'package:foodzi/BottomTabbar/BottomTabbarRestaurant.dart';

class RestaurantTAView extends StatefulWidget {
  String title;
  int rest_Id;
  RestaurantTAView({this.title, this.rest_Id});
  @override
  State<StatefulWidget> createState() {
    return _RestaurantTAViewState();
  }
}

class _RestaurantTAViewState extends State<RestaurantTAView>
    implements RestaurantTAModelView {
  // RestaurantPresenter restaurantPresenter;
  // List<RestaurantList> _restaurantList;
  // int page = 1;
  final GlobalKey _menuKey = new GlobalKey();
  ScrollController _controller = ScrollController();
  bool _switchvalue = false;
  bool isselected = false;
  @override
  // void initState() {
  //   _detectScrollPosition();
  //   restaurantPresenter = RestaurantPresenter(this);
  //   restaurantPresenter.getrestaurantspage(
  //       "18.579622", "73.738691", "", "", page, context);
  //   // TODO: implement initState
  //   super.initState();
  // }

  // _detectScrollPosition() {
  //   _controller.addListener(() {
  //     if (_controller.position.atEdge) {
  //       if (_controller.position.pixels == 0) {
  //         print("Top");
  //       } else {
  //         restaurantPresenter.getrestaurantspage(
  //             "18.579622", "73.738691", "", "", page, context);

  //         print("Bottom");
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: greytheme100,
            ),
            onPressed: () {
              //  Navigator.pushNamed(context, '/HotelInfoView');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RestaurantInfoView(
                        // title: "${_restaurantList[i].restName}",
                        rest_Id: widget.rest_Id,
                      )));
            },
          )
        ],
      ),
      body: CustomScrollView(
        controller: _controller,
        slivers: <Widget>[
          _getmainviewTableno(),
          SliverToBoxAdapter(
            child: Container(
              child: SizedBox(
                height: 15,
              ),
            ),
          ),
          _getOptionsformenu(context),
          SliverToBoxAdapter(
            child: Container(
              child: SizedBox(
                height: 15,
              ),
            ),
          ),
          _menuItemList()
        ],
      ),
    );
  }

  // Widget _buildMainView() {
  //   return Container(
  //     child: Column(
  //       children: <Widget>[
  //         _getmainviewTableno(),

  //         _getOptionsformenu(),
  //         SliverToBoxAdapter(
  //                     child: Container(
  //             child: SizedBox(
  //               height: 40,
  //             ),
  //           ),
  //         ),
  //         _menuItemList()
  //       ],
  //     ),
  //   );
  // }

  Widget _getmainviewTableno() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      widget.title,
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
                    'Take Away',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'gotham',
                        fontWeight: FontWeight.w600,
                        color: redtheme),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 20),
                  Text(
                    'Add Table Number',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        fontSize: 14,
                        fontFamily: 'gotham',
                        fontWeight: FontWeight.w600,
                        color: greytheme100),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getOptionsformenu(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        child: Row(
          children: <Widget>[
            SizedBox(width: 15),
            Text(
              'veg only',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'gotham',
                  fontWeight: FontWeight.w500,
                  color: greytheme1000),
            ),
            Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                activeColor: redtheme,
                onChanged: (bool value) {
                  setState(() {
                    this._switchvalue = value;
                  });
                },
                value: this._switchvalue,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.46,
            ),
            SizedBox(
              child: OutlineButton(
                  child: Text(
                    "Menu",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'gotham',
                        fontWeight: FontWeight.w500,
                        color: (isselected) ? redtheme : greytheme100),
                  ),
                  borderSide: (isselected)
                      ? BorderSide(color: redtheme)
                      : BorderSide(color: greytheme100),
                  //borderSide: BorderSide(color:redtheme),
                  onPressed: () async {
                    setState(() {
                      if (isselected == false) {
                        isselected = true;
                      } else {
                        isselected = false;
                      }
                    });
                    var abc = await showDialog(
                        context: context,
                        builder: (_) => MenuItem(),
                        barrierDismissible: true);
                    setState(() {
                      isselected = false;
                    });
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                  )),
              height: 22,
              width: 65,
            )
          ],
        ),
      ),
    );
  }

  Widget _menuItemList() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 0.7),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                          //bottomLeft: Radius.circular(10.0),
                          //bottomRight: Radius.circular(10.0),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          heightFactor: 1,
                          child: Image.network(
                              "https://static.vinepair.com/wp-content/uploads/2017/03/darts-int.jpg"),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                "data",
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'gotham',
                                    fontWeight: FontWeight.w600,
                                    color: greytheme700),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "data",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'gotham',
                                    fontWeight: FontWeight.w500,
                                    color: greytheme1000),
                              ),
                            ]),
                      )),
                      Container(
                        height: MediaQuery.of(context).size.width * 0.09,
                        child: Row(
                          children: <Widget>[
                            Container(
                              decoration: new BoxDecoration(
                                //color: Colors.white,
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey,
                                    width: 0.7,
                                  ),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Center(
                                child: Text(
                                  "\$ 12",
                                  style: TextStyle(
                                      //fontFamily: FontNames.gotham,
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(64, 64, 64, 1)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: redtheme,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12.0),
                                    )),
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Center(
                                  child: Text(
                                    "+ ADD",
                                    style: TextStyle(
                                        //fontFamily: FontNames.gotham,
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }, childCount: 7),
    );
  }

  @override
  void restaurantfailed() {
    // TODO: implement restaurantfailed
  }

  @override
  void restaurantsuccess(List<RestaurantList> restlist) {
    // if (restlist.length == 0) {
    //   return;
    // }

    // setState(() {
    //   if (_restaurantList == null) {
    //     _restaurantList = restlist;
    //   } else {
    //     _restaurantList.addAll(restlist);
    //   }
    //   page++;
    // });
    // TODO: implement restaurantsuccess
  }
}

// class Item {
//   String itemName;
//   String itemCount;
//   Item({this.itemName, this.itemCount});
// }
