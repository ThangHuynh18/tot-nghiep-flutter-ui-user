// ignore_for_file: file_names

import 'package:flutter_t_watch/models/ProductModel.dart';

class WishItem {
  late String status;
  late List<Data> data;
  late String errors;

  WishItem({required this.status, required this.data, required this.errors});

  WishItem.fromJson(Map<String, dynamic> json) {
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

  Data({required this.sId, required this.product});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    product =
    (json['product'] != null ? new Item.fromJson(json['product']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class Item {
  late int price;
  late int countInStock;
  late String sId;
  late String name;
  late List<Image> images;

  Item({required this.price, required this.countInStock, required this.sId, required this.name, required this.images});

  Item.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    countInStock = json['countInStock'];
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
    data['_id'] = this.sId;
    data['name'] = this.name;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
