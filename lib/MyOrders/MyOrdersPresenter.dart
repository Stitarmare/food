import 'package:flutter/material.dart';
import 'package:foodzi/Models/OrderDetailsModel.dart';
import 'package:foodzi/MyOrders/MyOrderContractor.dart';
import 'package:foodzi/network/ApiBaseHelper.dart';
import 'package:foodzi/network/api_model.dart';
import 'package:foodzi/network/url_constant.dart';

class MyOrdersPresenter extends MyOrderContractor {
  MyOrderModelView _myOrderModelView;
  @override
  void getOrderDetails(int orderid, {BuildContext context}) {
    ApiBaseHelper()
        .post<OrderDetailsModel>(UrlConstant.getorderDetails, context, body: {
      "order_id": orderid,
    }).then((value) {
      print(value);
      switch (value.result) {
        case SuccessType.success:
          print("Order Detail success");
          print(value.model);
          _myOrderModelView.getOrderDetailsSuccess();
          break;
        case SuccessType.failed:
          print("Order Detail failed");
          _myOrderModelView.getOrderDetailsFailed();
          break;
      }
    }).catchError((error) {
      print(error);
    });
    // TODO: implement getOrderDetails
  }

  @override
  void onBackPresed() {
    // TODO: implement onBackPresed
  }
}