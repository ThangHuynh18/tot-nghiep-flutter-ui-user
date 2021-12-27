// ignore_for_file: file_names

import 'package:flutter_t_watch/models/ProductModel.dart';

class CartItem {
  late String status;
  late List<Data> data;
  late String errors;

  CartItem({required this.status, required this.data, required this.errors});

  CartItem.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['errors'] = this.errors;
    return data;
  }
}

class Data {
  late String sId;
  late Item product;
  late int qty;

  Data({required this.sId, required this.product, required this.qty});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    product =
    (json['product'] != null ? new Item.fromJson(json['product']) : null)!;
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    data['qty'] = this.qty;
    return data;
  }
}

class Item {
  late int price;
  late int countInStock;
  late int discount;
  late String sId;
  late String name;
  late List<Image> images;

  Item({required this.price, required this.countInStock, required this.sId, required this.name, required this.images, required this.discount});

  Item.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    countInStock = json['countInStock'];
    discount = json['discount'];
    sId = json['_id'];
    name = json['name'];
    if (json['images'] != null) {
      images = <Image>[];
      json['images'].forEach((v) {
        images.add(new Image.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['countInStock'] = this.countInStock;
    data['discount'] = this.discount;
    data['_id'] = this.sId;
    data['name'] = this.name;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
