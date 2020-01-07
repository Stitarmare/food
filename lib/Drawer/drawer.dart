import 'package:flutter/material.dart';
import 'package:foodzi/theme/colors.dart';

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
                  // padding: EdgeInsets.only(left: 25, right: 16),
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
  HiddenDrawer({this.header, this.decoration, this.controller,this.isOpen});
  BoxDecoration decoration;
  Widget header;
  HiddenDrawerController controller;
  final bool isOpen;
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

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(microseconds: 300));
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.75).animate(animationController);
    radiusAnimation = BorderRadiusTween(
            begin: BorderRadius.circular(0.0), end: BorderRadius.circular(32))
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease));
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
            //decoration: widget.decoration,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/BackgroundImage/Group1649.png'),fit: BoxFit.fitHeight
                
              )
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 66.0),
              child: ListView(
                children: <Widget>[
                  Container(
                    child: widget.header,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: drawerItems()),SizedBox(height: MediaQuery.of(context).size.height*0.22),
                      DrawerItem(
            text: Text(
              'Sign Out',
              style: TextStyle(
                  color: greytheme800,
                  fontFamily: 'gotham',
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
            icon: Image.asset('assets/SignOutIcon/Group1349.png'),
            // page: Landingview(
            //   title: 'SETTINGS',
            // ),
            onPressed: null),
            Padding(
              padding: EdgeInsets.only(left: 50, top: 62),
              child: Text("Vesion 1.2",style: TextStyle(
                  color: greytheme100,
                  fontFamily: 'gotham',
                  fontWeight: FontWeight.w600,
                  fontSize: 12),)
            )
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
                                // child: Container(
                                //   color: Colors.white.withAlpha(128),
                                // ),
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
                )
                ),
          )
        ],
      ),
    );
  }
}
