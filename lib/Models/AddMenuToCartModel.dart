import 'dart:convert';

AddMenuToCartModel addMenuToCartModelFromJson(String str) => AddMenuToCartModel.fromJson(json.decode(str));

String addMenuToCartModelToJson(AddMenuToCartModel data) => json.encode(data.toJson());

class AddMenuToCartModel {
    String status;
    int statusCode;
    List<AddMenuToCartList> data;
    int grandTotal;
    String colourCode;

    AddMenuToCartModel({
        this.status,
        this.statusCode,
        this.data,
        this.grandTotal,
        this.colourCode,
    });

    factory AddMenuToCartModel.fromJson(Map<String, dynamic> json) => AddMenuToCartModel(
        status: json["status"],
        statusCode: json["status_code"],
        data: List<AddMenuToCartList>.from(json["data"].map((x) => AddMenuToCartList.fromJson(x))),
        grandTotal: json["grandTotal"],
        colourCode: json["colour_code"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "grandTotal": grandTotal,
        "colour_code": colourCode,
    };
}

class AddMenuToCartList {
    int id;
    int quantity;
    String preparationTime;
    int itemId;
    dynamic itemSizePriceId;
    int tableId;
    String price;
    int userId;
    int restId;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic sizePrice;
    int totalAmount;
    List<Item> items;
    List<dynamic> cartExtraItems;

    AddMenuToCartList({
        this.id,
        this.quantity,
        this.preparationTime,
        this.itemId,
        this.itemSizePriceId,
        this.tableId,
        this.price,
        this.userId,
        this.restId,
        this.createdAt,
        this.updatedAt,
        this.sizePrice,
        this.totalAmount,
        this.items,
        this.cartExtraItems,
    });

    factory AddMenuToCartList.fromJson(Map<String, dynamic> json) => AddMenuToCartList(
        id: json["id"],
        quantity: json["quantity"],
        preparationTime: json["preparation_time"],
        itemId: json["item_id"],
        itemSizePriceId: json["item_size_price_id"],
        tableId: json["table_id"],
        price: json["price"],
        userId: json["user_id"],
        restId: json["rest_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        sizePrice: json["size_price"],
        totalAmount: json["totalAmount"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        cartExtraItems: List<dynamic>.from(json["cart_extra_items"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "preparation_time": preparationTime,
        "item_id": itemId,
        "item_size_price_id": itemSizePriceId,
        "table_id": tableId,
        "price": price,
        "user_id": userId,
        "rest_id": restId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "size_price": sizePrice,
        "totalAmount": totalAmount,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "cart_extra_items": List<dynamic>.from(cartExtraItems.map((x) => x)),
    };
}

class Item {
    int id;
    String itemName;
    String price;
    String itemDescription;
    int workstationId;
    int restId;
    String menuType;
    String availability;
    String defaultPreparationTime;
    String itemCode;
    String itemImage;
    DateTime createdAt;
    DateTime updatedAt;

    Item({
        this.id,
        this.itemName,
        this.price,
        this.itemDescription,
        this.workstationId,
        this.restId,
        this.menuType,
        this.availability,
        this.defaultPreparationTime,
        this.itemCode,
        this.itemImage,
        this.createdAt,
        this.updatedAt,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        itemName: json["item_name"],
        price: json["price"],
        itemDescription: json["item_description"],
        workstationId: json["workstation_id"],
        restId: json["rest_id"],
        menuType: json["menu_type"],
        availability: json["availability"],
        defaultPreparationTime: json["default_preparation_time"],
        itemCode: json["item_code"],
        itemImage: json["item_image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "item_name": itemName,
        "price": price,
        "item_description": itemDescription,
        "workstation_id": workstationId,
        "rest_id": restId,
        "menu_type": menuType,
        "availability": availability,
        "default_preparation_time": defaultPreparationTime,
        "item_code": itemCode,
        "item_image": itemImage,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
