import 'package:flutter/src/widgets/framework.dart';
import 'package:foodzi/DeliveryFoodView/DeliveryContractor.dart';
import 'package:foodzi/DineInPage/DineInContractor.dart';
import 'package:foodzi/Models/RestaurantListModel.dart';
import 'package:foodzi/Utils/String.dart';
import 'package:foodzi/network/ApiBaseHelper.dart';
import 'package:foodzi/network/api_model.dart';
import 'package:foodzi/network/url_constant.dart';

class DineInDeliveryPresenter extends DineInDeliveryContractor {
  DineInDeliveryModelView restaurantModelView;

  DineInDeliveryPresenter(this.restaurantModelView);
  @override
  void getrestaurantspage(String latitude, String longitude, String sortBy,
      String searchBy, int page, BuildContext context) {
    ApiBaseHelper().post<RestaurantListModel>(
        UrlConstant.restaurantListApi, context,
        body: {
          JSON_STR_LATI: latitude,
          JSON_STR_LONG: longitude,
          JSON_STR_SORT_BY: sortBy,
          JSON_STR_SEARCH_BY: searchBy,
          JSON_STR_PAGE: page
        }).then((value) {
      print(value);
      switch (value.result) {
        case SuccessType.success:
          print(value.model);
          restaurantModelView.restaurantsuccess(value.model.data);
          break;
        case SuccessType.failed:
          restaurantModelView.restaurantfailed();
          break;
      }
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void onBackPresed() {}
}