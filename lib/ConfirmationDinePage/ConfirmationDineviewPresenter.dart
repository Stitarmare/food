import 'package:flutter/material.dart';
import 'package:foodzi/ConfirmationDinePage/ConfirmationDineViewContractor.dart';
import 'package:foodzi/Models/GetPeopleListModel.dart';
import 'package:foodzi/Models/error_model.dart';
import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/network/ApiBaseHelper.dart';
import 'package:foodzi/network/api_model.dart';
import 'package:foodzi/network/url_constant.dart';

class ConfirmationDineviewPresenter extends ConfirmationDineViewContractor {
  ConfirmationDineViewModelView _confirmationDineViewModelView;

  ConfirmationDineviewPresenter(
      ConfirmationDineViewModelView _confirmationDineViewModelView) {
    this._confirmationDineViewModelView = _confirmationDineViewModelView;
  }
  @override
  void onBackPresed() {}
  @override
  void addPeople(List<String> mobileNumber, int tableId, int restId,
      int orderId, BuildContext context) {
    ApiBaseHelper()
        .post<ErrorModel>(UrlConstant.addPeopleToOrderApi, context,
            body: {
              JSON_STR_MOB_NO: mobileNumber,
              JSON_STR_TABLE_ID: tableId,
              JSON_STR_REST_ID: restId,
              JSON_STR_ORDER_ID: orderId
            },
            isShowDialoag: true,
            isShowNetwork: true)
        .then((value) {
      print(value);
      switch (value.result) {
        case SuccessType.success:
          print(value.model);
          _confirmationDineViewModelView.addPeopleSuccess();
          break;
        case SuccessType.failed:
          _confirmationDineViewModelView.addPeopleFailed();
          break;
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void getPeopleList(String searchText, BuildContext context) {
    ApiBaseHelper()
        .post<GetPeopleListModel>(UrlConstant.getPeopleListApi, context,
            body: {
              "search": searchText,
            },
            isShowNetwork: true,
            isShowDialoag: true)
        .then((value) {
      print(value);
      switch (value.result) {
        case SuccessType.success:
          print(value.model.statusCode);
          _confirmationDineViewModelView
              .getPeopleListonSuccess(value.model.data);
          break;
        case SuccessType.failed:
          _confirmationDineViewModelView.getPeopleListonFailed();
          break;
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void sentInvitRequest(int tableId, int restId, BuildContext context) {
    ApiBaseHelper()
        .post<ErrorModel>(UrlConstant.requestToJoinTableApi, context,
            body: {"table_id": tableId, "rest_id": restId}, isShowDialoag: true)
        .then((value) {
      print(value);
      switch (value.result) {
        case SuccessType.success:
          _confirmationDineViewModelView
              .inviteRequestSuccess(value.model.message);
          break;
        case SuccessType.failed:
          _confirmationDineViewModelView.inviteRequestFailed(value.model);
          break;
      }
    }).catchError((error) {
      print(error);
    });
  }
}
