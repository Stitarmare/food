import 'package:flutter/material.dart';
import 'package:foodzi/AddItemPage/ADdItemPagePresenter.dart';
import 'package:foodzi/AddItemPage/AddItemPageContractor.dart';
import 'package:foodzi/AddItemPageTA/AddItemPageTAContractor.dart';
import 'package:foodzi/AddItemPageTA/AddItemPageTAPresenter.dart';
//import 'package:foodzi/AddItemPage/AddItemPagePresenter.dart';
import 'package:foodzi/Models/AddItemPageModel.dart';
import 'package:foodzi/Utils/globle.dart';
import 'package:foodzi/theme/colors.dart';
import 'package:foodzi/widgets/RadioDailog.dart';

class AddItemPageTAView extends StatefulWidget {
  String title;
  String description;
  int item_id;
  int rest_id;

  AddItemPageTAView({this.title, this.description, this.item_id, this.rest_id});
  _AddItemPageTAViewState createState() => _AddItemPageTAViewState();
}

class _AddItemPageTAViewState extends State<AddItemPageTAView>
    implements AddItemPageTAModelView {
  List<bool> isSelected;

  AddItemModelList _addItemModelList;
  int item_id;
  int rest_id;
  ScrollController _controller = ScrollController();
  AddItemPageTApresenter _addItemPagepresenter;

  @override
  void initState() {
    _addItemPagepresenter = AddItemPageTApresenter(this);
    isSelected = [true, false];
    _addItemPagepresenter.performAddItem(
        widget.item_id, widget.rest_id, context);
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
  void _onValueChange(String value) {
    setState(() {
      _selectedId = value;
    });
  }

  int getradiobtn(int length) {
    List<RadioButtonOptions> radiolist = [];
    for (int i = 1; i <= length; i++) {
      radiolist.add(RadioButtonOptions(
          index: i, title: _addItemModelList.spreads[i - 1].name ?? ''));
    }
    setState(() {
      _radioOptions = radiolist;
    });
  }

  int checkboxbtn(int length) {
    List<CheckBoxOptions> _checkboxlist = [];
    for (int i = 1; i <= length; i++) {
      _checkboxlist.add(CheckBoxOptions(
          price: _addItemModelList.extras[i - 1].price ?? '',
          isChecked: false,
          index: i,
          title: _addItemModelList.extras[i - 1].name ?? ''));
    }
    setState(() {
      _checkBoxOptions = _checkboxlist;
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
            }
          },
          splashColor:  getColorByHex(Globle().colorscode),
          child: Container(
            decoration: BoxDecoration(
                color:  getColorByHex(Globle().colorscode),
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
            }
          },
          splashColor: Colors.lightBlue,
          child: Container(
            decoration: BoxDecoration(
                color:  getColorByHex(Globle().colorscode),
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
      left: true,
      top: true,
      right: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: CustomScrollView(
          controller: _controller,
          slivers: <Widget>[_getmainviewTableno(), _getOptions()],
        ),
        bottomNavigationBar: BottomAppBar(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/OrderConfirmationView');
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
                  color:  getColorByHex(Globle().colorscode),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              // color: redtheme,
              child: Center(
                child: Text(
                  'ADD \$24',
                  style: TextStyle(
                      fontFamily: 'gotham',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
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
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Wimpy',
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
                        color:  getColorByHex(Globle().colorscode)),
                  )
                ],
              ),
              // SizedBox(
              //   height: 20,
              // ),
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
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _getOptions() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 12, 0, 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 25, left: 26),
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
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 28),
                    Text(
                      'Dressing',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'gotham',
                          fontWeight: FontWeight.w500,
                          color: greytheme700),
                    ),
                    SizedBox(
                      width: 34,
                    ),
                    togglebutton()
                  ],
                ),
              ),
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
                        activeColor:  getColorByHex(Globle().colorscode),
                        onChanged: (val) {
                          setState(() {
                            radioItem = radionBtn.title;
                            print(radionBtn.title);
                            id = radionBtn.index;
                          });
                        },
                      ),
                    ))
                .toList()
            : [Container()]);
  }

  Widget togglebutton() {
    return Container(
      height: 36,
      child: ToggleButtons(
        borderColor: greytheme1300,
        fillColor:  getColorByHex(Globle().colorscode),
        borderWidth: 2,
        selectedBorderColor: Colors.transparent,
        selectedColor: Colors.white,
        borderRadius: BorderRadius.circular(4),
        children: <Widget>[
          Container(
            width: 85,
            child: Text(
              'On side',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'gotham',
                  fontWeight: FontWeight.w500,
                  color: (isSelected[0] == true) ? Colors.white : greytheme700),
            ),
          ),
          Container(
            width: 85,
            child: Text(
              'On top',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'gotham',
                  fontWeight: FontWeight.w500,
                  color:
                      (isSelected[1] == false) ? greytheme700 : Colors.white),
            ),
          ),
        ],
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < isSelected.length; i++) {
              if (i == index) {
                isSelected[i] = true;
              } else {
                isSelected[i] = false;
              }
            }
          });
        },
        isSelected: isSelected,
      ),
    );
  }

  _getCheckBoxOptions() {
    return Column(
        children: _checkBoxOptions.length > 0
            ? _checkBoxOptions
                .map((checkBtn) => CheckboxListTile(
                    activeColor:  getColorByHex(Globle().colorscode),
                    value: checkBtn.isChecked,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (val) {
                      setState(() {
                        checkBtn.isChecked = val;
                        print(val);
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
                            checkBtn.price.toString() ?? '',
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

  @override
  void addItemfailed() {
    // TODO: implement addItemfailed
  }

  @override
  void addItemsuccess(List<AddItemModelList> _additemlist) {
    _addItemModelList = _additemlist[0];

    getradiobtn(_addItemModelList.spreads.length);

    checkboxbtn(_addItemModelList.extras.length);
    // TODO: implement addItemsuccess
  }
}

// OrderConfirmationView
class CheckBoxOptions {
  int index;
  String title;
  String price;
  // double price;
  bool isChecked;
  CheckBoxOptions({this.index, this.title, this.price, this.isChecked});
}

class RadioButtonOptions {
  int index;
  String title;
  RadioButtonOptions({this.index, this.title});
}