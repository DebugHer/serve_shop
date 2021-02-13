// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

ProductsResponse productsFromJson(String str) => ProductsResponse.fromJson(json.decode(str));

String productsToJson(ProductsResponse data) => json.encode(data.toJson());

class ProductsResponse {
  ProductsResponse({
    this.code,
    this.meta,
    this.data,
  });

  int code;
  Meta meta;
  List<ProductItem> data;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) => ProductsResponse(
    code: json["code"],
    meta: Meta.fromJson(json["meta"]),
    data: List<ProductItem>.from(json["data"].map((x) => ProductItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "meta": meta.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ProductItem with ChangeNotifier  {
  ProductItem({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.discountAmount,
    this.status,
    this.categories,
  });

  int id;
  String name;
  String description;
  String image;
  String price;
  String discountAmount;
  bool status;
  List<Category> categories;

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
    price: json["price"],
    discountAmount: json["discount_amount"],
    status: json["status"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image": image,
    "price": price,
    "discount_amount": discountAmount,
    "status": status,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Meta {
  Meta({
    this.pagination,
  });

  Pagination pagination;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "pagination": pagination.toJson(),
  };
}

class Pagination {
  Pagination({
    this.total,
    this.pages,
    this.page,
    this.limit,
  });

  int total;
  int pages;
  int page;
  int limit;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    pages: json["pages"],
    page: json["page"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "pages": pages,
    "page": page,
    "limit": limit,
  };
}
