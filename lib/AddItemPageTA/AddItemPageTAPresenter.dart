import 'package:flutter/material.dart';
import 'package:foodzi/AddItemPageTA/AddItemPageTAContractor.dart';
import 'package:foodzi/Models/AddItemPageModel.dart';
import 'package:foodzi/Models/AddMenuToCartModel.dart';
import 'package:foodzi/Models/error_model.dart';
import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/network/ApiBaseHelper.dart';
import 'package:foodzi/network/api_model.dart';
import 'package:foodzi/network/url_constant.dart';

class AddItemPageTApresenter extends AddItemPageTAContractor {
  AddItemPageTAModelView addItemPageModelView;

  AddmenuToCartModelviews addMenuToCartModel;
  ClearCartTAModelView clearCartModelView;

  AddItemPageTApresenter(
      AddItemPageTAModelView addItemPageView,
      AddmenuToCartModelviews addMenuToCartModel,
      ClearCartTAModelView clearCartModelView) {
    this.addItemPageModelView = addItemPageView;
    this.addMenuToCartModel = addMenuToCartModel;
    this.clearCartModelView = clearCartModelView;
  }

  @override
  void onBackPresed() {}

  @override
  void performAddItem(int itemId, int restId, BuildContext context) {
    ApiBaseHelper().post<AddItemPageModelList>(
        UrlConstant.getmenudetailsApi, context,
        body: {
          JSON_STR_ITEM_ID: itemId,
          JSON_STR_REST_ID: restId,
        }).then((value) {
      print(value);
      switch (value.result) {
        case SuccessType.success:
          print(value.model);
          addItemPageModelView.addItemsuccess(value.model.data,value.model);
          break;
        case SuccessType.failed:
          addItemPageModelView.addItemfailed();
          break;
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void performaddMenuToCart(AddItemsToCartModel item, BuildContext context) {
    ApiBaseHelper()
        .post<AddMenuToCartModel>(UrlConstant.addMenuToCartApi, context,
            body: item.toJson())
        .then((value) {
      print(value);
      switch (value.result) {
        case SuccessType.success:
          addMenuToCartModel.addMenuToCartsuccess();
          break;
        case SuccessType.failed:
          addMenuToCartModel.addMenuToCartfailed();
          break;
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void clearCart(BuildContext context) {
    ApiBaseHelper()
        .get<ErrorModel>(
      UrlConstant.clearCartApi,
      context,
    )
        .then((value) {
      print(value);
      switch (value.result) {
        case SuccessType.success:
          print(value.model);
          clearCartModelView.clearCartSuccess();
          break;
        case SuccessType.failed:
          clearCartModelView.clearCartFailed();
          break;
      }
    }).catchError((onError) {
      print(onError);
    });
  }
}
