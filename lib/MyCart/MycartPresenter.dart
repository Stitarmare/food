import 'package:flutter/src/widgets/framework.dart';
import 'package:foodzi/Models/AddMenuToCartModel.dart';
import 'package:foodzi/MyCart/MyCartContarctor.dart';
import 'package:foodzi/network/ApiBaseHelper.dart';
import 'package:foodzi/network/api_model.dart';
import 'package:foodzi/network/url_constant.dart';

class MycartPresenter extends MyCartContarctor {
  MyCartModelView _cartModelView;
  MycartPresenter(MyCartModelView _cartModelView) {
    this._cartModelView = _cartModelView;
  }

  @override
  void onBackPresed() {
    // TODO: implement onBackPresed
  }

  @override
  void getMenuList(int restId, BuildContext context, int user_id,
      {String menu, int category_id}) {
    // TODO: implement getMenuList
    ApiBaseHelper()
        .post<AddMenuToCartModel>(UrlConstant.getMenuListApi, context, body: {
      "rest_id": restId,
      "user_id": user_id,
    }).then((value) {
      print(value);
      switch (value.result) {
        case SuccessType.success:
          print("Added Menu To Cart success");
          print(value.model);
          _cartModelView.getCartMenuListsuccess(value.model.data);
          break;
        case SuccessType.failed:
          print("Added Menu To Cart failed");
          _cartModelView.getCartMenuListfailed();
          break;
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void getCartMenuList(int rest_id, BuildContext context, {String menu}) {
    // TODO: implement getCartMenuList
  }
}