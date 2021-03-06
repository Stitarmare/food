import 'dart:convert';

RestaurantItemsModel restaurantItemsModelFromJson(String str) => RestaurantItemsModel.fromJson(json.decode(str));

String restaurantItemsModelToJson(RestaurantItemsModel data) => json.encode(data.toJson());

class RestaurantItemsModel {
    String status;
    int statusCode;
    int page;
    int totalPages;
    List<RestaurantMenuItem> data;
    String colourCode;
    String currencySymbol;
    String restImage;
    String restLogo;

    RestaurantItemsModel({
        this.status,
        this.statusCode,
        this.page,
        this.totalPages,
        this.data,
        this.colourCode,
        this.currencySymbol,
        this.restImage,
        this.restLogo,
    });

    factory RestaurantItemsModel.fromJson(Map<String, dynamic> json) => RestaurantItemsModel(
        status: json["status"],
        statusCode: json["status_code"],
        page: json["page"],
        totalPages: json["totalPages"],
        data: List<RestaurantMenuItem>.from(json["data"].map((x) => RestaurantMenuItem.fromJson(x))),
        colourCode: json["colour_code"],
        currencySymbol: json["currency_symbol"],
        restImage: json["rest_image"],
        restLogo: json["rest_logo"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "page": page,
        "totalPages": totalPages,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "colour_code": colourCode,
        "currency_symbol": currencySymbol,
        "rest_image": restImage,
        "rest_logo": restLogo,
    };
}

class RestaurantMenuItem {
    int id;
    String itemName;
    String price;
    String itemDescription;
    String menuType;
    String extrasrequired;
    String spreadsrequired;
    String switchesrequired;
    String defaultPreparationTime;
    String itemCode;
    String itemImage;
    int workstationId;
    DateTime createdAt;
    DateTime updatedAt;
    List<SizePrizes> sizePrizes;
    int restId;

    RestaurantMenuItem({
        this.id,
        this.itemName,
        this.price,
        this.itemDescription,
        this.menuType,
        this.extrasrequired,
        this.spreadsrequired,
        this.switchesrequired,
        this.defaultPreparationTime,
        this.itemCode,
        this.itemImage,
        this.workstationId,
        this.createdAt,
        this.updatedAt,
        this.sizePrizes,
        this.restId,
    });

    factory RestaurantMenuItem.fromJson(Map<String, dynamic> json) => RestaurantMenuItem(
        id: json["id"],
        itemName: json["item_name"],
        price: json["price"],
        itemDescription: json["item_description"],
        menuType: json["menu_type"],
        extrasrequired: json["extrasrequired"],
        spreadsrequired: json["spreadsrequired"],
        switchesrequired: json["switchesrequired"],
        defaultPreparationTime: json["default_preparation_time"],
        itemCode: json["item_code"],
        itemImage: json["item_image"],
        workstationId: json["workstation_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        sizePrizes: List<SizePrizes>.from(json["size_prizes"].map((x) => SizePrizes.fromJson(x))),
        restId: json["rest_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "item_name": itemName,
        "price": price,
        "item_description": itemDescription,
        "menu_type": menuType,
        "extrasrequired": extrasrequired,
        "spreadsrequired": spreadsrequired,
        "switchesrequired": switchesrequired,
        "default_preparation_time": defaultPreparationTime,
        "item_code": itemCode,
        "item_image": itemImage,
        "workstation_id": workstationId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "size_prizes": List<dynamic>.from(sizePrizes.map((x) => x)),
        "rest_id": restId,
    };
}
class SizePrizes {
    int id;
    int itemId;
    String price;
    String size;
    String status;
    dynamic createdAt;
    dynamic updatedAt;

    SizePrizes({
        this.id,
        this.itemId,
        this.price,
        this.size,
        this.status,
        this.createdAt,
        this.updatedAt,
    });

    factory SizePrizes.fromJson(Map<String, dynamic> json) => SizePrizes(
        id: json["id"],
        itemId: json["item_id"],
        price: json["price"],
        size: json["size"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "item_id": itemId,
        "price": price,
        "size": size,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}