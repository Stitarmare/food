import 'package:flutter/material.dart';
import 'package:foodzi/Models/PlaceOrderModel.dart';

abstract class PaymentTipAndPayContarctor {
  void placeOrder(
    int restId,
    int userId,
    String orderType,
    int tableId,
    List items,
    double totalAmount,
    String latitude,
    String longitude,
    BuildContext context,
  );
  void onBackPresed();
}

abstract class PaymentTipAndPayModelView {
  void placeOrdersuccess(OrderData orderData, PlaceOrderModel model);
  void placeOrderfailed();
}
