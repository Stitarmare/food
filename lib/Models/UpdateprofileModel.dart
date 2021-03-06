import 'dart:convert';

import 'package:foodzi/Models/loginmodel.dart';

UpdateProfileModel updateProfileFromJson(String str) => UpdateProfileModel.fromJson(json.decode(str));

String updateProfileToJson(UpdateProfileModel data) => json.encode(data.toJson());

class UpdateProfileModel {
    String status;
    int statusCode;
    String message;
    Data data;

    UpdateProfileModel({
        this.status,
        this.statusCode,
        this.message,
        this.data,
    });

    factory UpdateProfileModel.fromJson(Map<String, dynamic> json) => UpdateProfileModel(
        status: json["status"],
        statusCode: json["status_code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "message": message,
        "data": data.toJson(),
    };
}
class UserDetails {
    int id;
    int userId;
    String addressLine1;
    String addressLine2;
    String addressLine3;
    int countryId;
    int stateId;
    int cityId;
    String postalCode;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic profileImage;
    Country country;
    State state;
    City city;

    UserDetails({
        this.id,
        this.userId,
        this.addressLine1,
        this.addressLine2,
        this.addressLine3,
        this.countryId,
        this.stateId,
        this.cityId,
        this.postalCode,
        this.createdAt,
        this.updatedAt,
        this.profileImage,
        this.country,
        this.state,
        this.city,
    });

    factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        userId: json["user_id"],
        addressLine1: json["address_line_1"],
        addressLine2: json["address_line_2"],
        addressLine3: json["address_line_3"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        cityId: json["city_id"],
        postalCode: json["postal_code"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        profileImage: json["profile_image"],
        country: json["country"] != null ? Country.fromJson(json["country"]) : null,
        state: json["state"] != null ? State.fromJson(json["state"]) : null,
        city: json["city"] != null ? City.fromJson(json["city"]) : null, 
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "address_line_1": addressLine1,
        "address_line_2": addressLine2,
        "address_line_3": addressLine3,
        "country_id": countryId,
        "state_id": stateId,
        "city_id": cityId,
        "postal_code": postalCode,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "profile_image": profileImage,
        "country": country != null ? country.toJson() : null,
        "state": state != null ? state.toJson() : null,
        "city": city != null ? city.toJson() : null,
    };
}

class City {
    int id;
    String name;
    String stateCode;
    String countryCode;
    int flag;
    String latitude;
    String longitude;
    String wikiDataId;
    int stateId;
    int countryId;
    DateTime createdAt;
    DateTime updatedAt;

    City({
        this.id,
        this.name,
        this.stateCode,
        this.countryCode,
        this.flag,
        this.latitude,
        this.longitude,
        this.wikiDataId,
        this.stateId,
        this.countryId,
        this.createdAt,
        this.updatedAt,
    });

    factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        stateCode: json["state_code"],
        countryCode: json["country_code"],
        flag: json["flag"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        wikiDataId: json["wikiDataId"],
        stateId: json["state_id"],
        countryId: json["country_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "state_code": stateCode,
        "country_code": countryCode,
        "flag": flag,
        "latitude": latitude,
        "longitude": longitude,
        "wikiDataId": wikiDataId,
        "state_id": stateId,
        "country_id": countryId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class Country {
    int id;
    String name;
    String iso3;
    String iso2;
    String phonecode;
    String capital;
    String currency;
    int flag;
    String wikiDataId;
    DateTime createdAt;
    DateTime updatedAt;

    Country({
        this.id,
        this.name,
        this.iso3,
        this.iso2,
        this.phonecode,
        this.capital,
        this.currency,
        this.flag,
        this.wikiDataId,
        this.createdAt,
        this.updatedAt,
    });

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        iso3: json["iso3"],
        iso2: json["iso2"],
        phonecode: json["phonecode"],
        capital: json["capital"],
        currency: json["currency"],
        flag: json["flag"],
        wikiDataId: json["wikiDataId"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iso3": iso3,
        "iso2": iso2,
        "phonecode": phonecode,
        "capital": capital,
        "currency": currency,
        "flag": flag,
        "wikiDataId": wikiDataId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class State {
    int id;
    String name;
    String countryCode;
    String fipsCode;
    String iso2;
    int flag;
    String wikiDataId;
    int countryId;
    DateTime createdAt;
    DateTime updatedAt;

    State({
        this.id,
        this.name,
        this.countryCode,
        this.fipsCode,
        this.iso2,
        this.flag,
        this.wikiDataId,
        this.countryId,
        this.createdAt,
        this.updatedAt,
    });

    factory State.fromJson(Map<String, dynamic> json) => State(
        id: json["id"],
        name: json["name"],
        countryCode: json["country_code"],
        fipsCode: json["fips_code"],
        iso2: json["iso2"],
        flag: json["flag"],
        wikiDataId: json["wikiDataId"],
        countryId: json["country_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_code": countryCode,
        "fips_code": fipsCode,
        "iso2": iso2,
        "flag": flag,
        "wikiDataId": wikiDataId,
        "country_id": countryId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
