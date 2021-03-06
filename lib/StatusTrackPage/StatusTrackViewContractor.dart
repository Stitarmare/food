import 'package:flutter/material.dart';
import 'package:foodzi/Models/InvitePeopleModel.dart';
import 'package:foodzi/Models/OrderStatusModel.dart';

abstract class StatusTrackViewContractor {
  void getOrderStatus(int orderId, BuildContext context);
  void getInvitedPeople(
    int userId,
    int tableId,
    BuildContext context, {
    int orderId,
  });
  void onBackPresed();
}

abstract class StatusTrackViewModelView {
  void getOrderStatussuccess(StatusData statusData);
  void getOrderStatusfailed();
  void getInvitedPeopleSuccess(List<InvitePeopleList> list);
  void getInvitedPeopleFailed();
}
