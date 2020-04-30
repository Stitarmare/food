import 'package:flutter/material.dart';
import 'package:foodzi/Models/OrderDetailsModel.dart';
import 'package:foodzi/SplitBillPage/SplitBillContractor.dart';
import 'package:foodzi/SplitBillPage/SplitBillPresenter.dart';
import 'package:foodzi/SplitBllNotification/SplitBillContractor.dart';
import 'package:foodzi/SplitBllNotification/SplitBillNotificationPresenter.dart';
import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/Utils/globle.dart';
import 'package:foodzi/theme/colors.dart';
import 'package:foodzi/widgets/InvitedPeopleDialogSplitBill.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RadioDialog extends StatefulWidget {
  int tableId;
  int orderId;
  double amount;
  List<ListElements> elementList;

  RadioDialog(
      {this.onValueChange,
      this.initialValue,
      this.tableId,
      this.orderId,
      this.amount,
      this.elementList});

  final String initialValue;
  final void Function(String) onValueChange;

  @override
  State createState() => new RadioDialogState();
}

class RadioDialogState extends State<RadioDialog>
    implements
        SplitBillContractorModelView,
        SplitBillNotificationContractorModelView {
  SplitBillPresenter _splitBillPresenter;
  SplitBillNotificationPresenter _splitBillNotificationPresenter;
  String radioItem = STR_MANGO;
  int id = 1;
  List<BillList> bList = [
    BillList(
      index: 1,
      name: STR_SPLIT_BILL_AMONG_ALL,
    ),
    BillList(
      index: 2,
      name: STR_SPLIT_BILL_CERTAIN_MEMB,
    ),
    // BillList(
    //   index: 3,
    //   name: STR_SPLIT_BILL_ORDER_ITEMS,
    // ),
    BillList(
      index: 4,
      name: STR_SPLIT_BILL_USER_SPECIFIC,
    ),
  ];
  ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
    _splitBillPresenter = SplitBillPresenter(this);
    _splitBillNotificationPresenter = SplitBillNotificationPresenter(this);
  }

  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog.style(message: STR_LOADING);
    return new SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      children: <Widget>[
        Container(
            height: 350,
            width: 284,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: Text(
                    STR_SPLIT_BILL,
                    style: TextStyle(
                        fontSize: FONTSIZE_16,
                        color: greytheme700,
                        fontFamily: KEY_FONTFAMILY,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Column(
                  children: bList
                      .map((data) => RadioListTile(
                            title: Text(
                              data.name,
                              style: TextStyle(
                                  fontSize: FONTSIZE_15,
                                  color: greytheme700,
                                  fontFamily: KEY_FONTFAMILY),
                            ),
                            groupValue: id,
                            value: data.index,
                            activeColor: redtheme,
                            onChanged: (val) {
                              setState(() {
                                radioItem = data.name;
                                id = data.index;
                              });
                            },
                          ))
                      .toList(),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                    child: RaisedButton(
                  color: redtheme,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    onConfirmTap();
                  },
                  child: Text(
                    STR_CONFIRM,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: FONTSIZE_18,
                    ),
                  ),
                ))
              ],
            ))
      ],
    );
  }
  onConfirmTap() async{
    if (id == 1) {
      await progressDialog.show();
                      _splitBillPresenter.getSPlitBill(
                          widget.orderId,
                          Globle().loginModel.data.id,
                          1,
                          widget.amount.toInt(),
                          context);
                      // _splitBillNotificationPresenter.getSPlitBillNotification(
                      //     widget.orderId,
                      //     Globle().loginModel.data.id,
                      //     1,
                      //     widget.amount.toInt(),
                      //     context);
                    } else if (id == 2) {
                      Navigator.of(context).pop({"isInvitePeople":true});
                      
                    } else if (id == 3) {
                      await progressDialog.show();
                      _splitBillPresenter.getSPlitBill(
                          widget.orderId,
                          Globle().loginModel.data.id,
                          3,
                          widget.amount.toInt(),
                          context);

                      // _splitBillNotificationPresenter.getSPlitBillNotification(
                      //     widget.orderId,
                      //     Globle().loginModel.data.id,
                      //     3,
                      //     widget.amount.toInt(),
                      //     context);
                    } else if (id == 4) {
                      await progressDialog.show();
                      _splitBillPresenter.getSPlitBill(
                          widget.orderId,
                          Globle().loginModel.data.id,
                          3,
                          widget.amount.toInt(),
                          context);

                      // _splitBillNotificationPresenter.getSPlitBillNotification(
                      //     widget.orderId,
                      //     Globle().loginModel.data.id,
                      //     4,
                      //     widget.amount.toInt(),
                      //     context);
                    }
  }

  @override
  void getSplitBillFailed() async{
    await progressDialog.hide();
    Navigator.of(context).pop({"isSplitBill":false});
  }

  @override
  void getSplitBillSuccess() async{
    await progressDialog.hide();
    Navigator.of(context).pop({"isSplitBill":true});
  }

  @override
  void getSplitBillNotificationFailed() {
    // TODO: implement getSplitBillNotificationFailed
  }

  @override
  void getSplitBillNotificationSuccess() {
    // TODO: implement getSplitBillNotificationSuccess
  }
}

class BillList {
  String name;
  int index;
  BillList({this.name, this.index});
}
