import 'package:flutter/material.dart';
import 'package:foodzi/Utils/constant.dart';
import 'package:foodzi/Utils/shared_preference.dart';
import 'package:foodzi/theme/colors.dart';

import 'package:foodzi/Utils/String.dart';
import 'package:package_info/package_info.dart';

class HiddenDrawerController {
  HiddenDrawerController({this.items, @required DrawerContent initialPage}) {
    this.page = initialPage;
  }
  List<DrawerItem> items;
  Function open;
  Function close;
  DrawerContent page;
}

class DrawerContent extends StatefulWidget {
  Function onMenuPressed;
  State<StatefulWidget> createState() {
    return null;
  }
}

class DrawerItem extends StatelessWidget {
  DrawerItem({this.onPressed, this.icon, this.text, this.page});
  Function onPressed;
  Widget icon;
  Widget text;
  DrawerContent page;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: icon,
                ),
                text
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HiddenDrawer extends StatefulWidget {
  HiddenDrawer(
      {this.header,
      this.decoration,
      this.controller,
      this.isOpen,
      this.version});
  BoxDecoration decoration;
  Widget header;
  HiddenDrawerController controller;
  final bool isOpen;
  String version;
  @override
  _HiddenDrawerState createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer>
    with TickerProviderStateMixin {
  bool isMenuOpen = false;
  bool isMenudragging = false;
  Animation<double> animation, scaleAnimation;
  Animation<BorderRadius> radiusAnimation;
  AnimationController animationController;
  String versionName = "";
  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.84).animate(animationController);
    radiusAnimation = BorderRadiusTween(
            begin: BorderRadius.circular(0.0), end: BorderRadius.circular(32))
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease));
    getVersion();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  drawerItems() {
    return widget.controller.items.map((DrawerItem item) {
      if (item.onPressed == null) {
        item.onPressed = () {
          widget.controller.page = item.page;
          widget.controller.close();
        };
      }
      item.page.onMenuPressed = menuPress;
      return item;
    }).toList();
  }

  menuPress() {
    isMenuOpen ? closeDrawer() : openDrawer();
  }

  closeDrawer() {
    animationController.reverse();
    setState(() {
      isMenuOpen = false;
    });
  }

  openDrawer() {
    animationController.forward();

    setState(() {
      isMenuOpen = true;
    });
  }

  animations() {
    if (isMenudragging) {
      var opened = false;
      setState(() {
        isMenudragging = false;
      });
      if (animationController.value >= 0.4) {
        animationController.forward();
        opened = true;
      } else {
        animationController.reverse();
      }
      setState(() {
        isMenuOpen = opened;
      });
    }
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      versionName = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.page.onMenuPressed = menuPress;
    widget.controller.close = closeDrawer;
    widget.controller.open = openDrawer;
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        if (isMenuOpen &&
            event.position.dx / MediaQuery.of(context).size.width >= 0.66) {
          closeDrawer();
        } else {
          setState(() {
            isMenudragging = (!isMenudragging && event.position.dx <= 8.0);
          });
        }
      },
      onPointerMove: (PointerMoveEvent event) {
        if (isMenudragging) {
          animationController.value =
              event.position.dx / MediaQuery.of(context).size.width;
        }
      },
      onPointerUp: (PointerUpEvent event) {
        animations();
      },
      onPointerCancel: (PointerCancelEvent event) {
        animations();
      },
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage(STR_IMAGE_PATH), fit: BoxFit.fitHeight)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 66.0),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Container(
                    child: widget.header,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: drawerItems()),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  DrawerItem(
                      text: Text(
                        KEY_SIGN_OUT,
                        style: TextStyle(
                            color: greytheme800,
                            fontFamily: Constants.getFontType(),
                            fontWeight: FontWeight.w600,
                            fontSize: FONTSIZE_15),
                      ),
                      icon: Image.asset(STR_IMAGE_PATH1),
                      onPressed: () {
                        Preference.removeAllPref();
                        Navigator.pushReplacementNamed(context, STR_LOGIN_PAGE);
                      }),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 50,
                          top: MediaQuery.of(context).size.height * 0.01),
                      child: Text(
                        "$STR_VERSION_NO ${versionName ?? ""}",
                        style: TextStyle(
                            color: greytheme100,
                            fontFamily: Constants.getFontType(),
                            fontWeight: FontWeight.w600,
                            fontSize: FONTSIZE_12),
                      ))
                ],
              ),
            ),
          ),
          Transform.scale(
            scale: scaleAnimation.value,
            child: Transform.translate(
                offset: Offset(
                    MediaQuery.of(context).size.width * 0.65 * animation.value,
                    0.0),
                child: AbsorbPointer(
                  absorbing: isMenuOpen,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(44)),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: animation.value * 10),
                        child: ClipRRect(
                          borderRadius: radiusAnimation.value,
                          child: Container(
                            color: Colors.white,
                            child: widget.controller.page,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
