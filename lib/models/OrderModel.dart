// ignore_for_file: file_names
import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:flutter_t_watch/models/UserModel.dart';

class Order {
  late ShippingAddress shippingAddress;
  late Refund refund;
  late String status;
  late int itemsPrice;
  late int shippingPrice;
  late int totalPrice;
  late String sId;
  late List<OrderItems> orderItems;
  late String user;
  late String paymentMethod;
  late String createdAt;
  late String updatedAt;
  late int iV;

  Order(
      {required this.shippingAddress,
        required this.refund,
        required this.status,
        required this.itemsPrice,
        required this.shippingPrice,
        required this.totalPrice,
        required this.sId,
        required this.orderItems,
        required this.user,
        required this.paymentMethod,
        required this.createdAt,
        required this.updatedAt,
        required this.iV});

  Order.fromJson(Map<String, dynamic> json) {
    shippingAddress =
    (json['shippingAddress'] != null ? new ShippingAddress.fromJson(
        json['shippingAddress']) : null)!;
    refund =
    (json['refund'] != null ? new Refund.fromJson(json['refund']) : null)!;
    status = json['status'];
    itemsPrice = json['itemsPrice'];
    shippingPrice = json['shippingPrice'];
    totalPrice = json['totalPrice'];
    sId = json['_id'];
    if (json['orderItems'] != null) {
      orderItems = <OrderItems>[];
      json['orderItems'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
    user = json['user'];
    paymentMethod = json['paymentMethod'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shippingAddress != null) {
      data['shippingAddress'] = this.shippingAddress.toJson();
    }
    if (this.refund != null) {
      data['refund'] = this.refund.toJson();
    }
    data['status'] = this.status;
    data['itemsPrice'] = this.itemsPrice;
    data['shippingPrice'] = this.shippingPrice;
    data['totalPrice'] = this.totalPrice;
    data['_id'] = this.sId;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    data['user'] = this.user;
    data['paymentMethod'] = this.paymentMethod;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}


class Refund {
  late String reason;
  late String refundAt;
  late List<Image> images;

  Refund({required this.reason, required this.refundAt, required this.images});

  Refund.fromJson(Map<String, dynamic> json) {
    reason = json['reason'];
    refundAt = json['refundAt'];
    if (json['images'] != null) {
      images = <Image>[];
      json['images'].forEach((v) {
        images.add(new Image.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reason'] = this.reason;
    data['refundAt'] = this.refundAt;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class OrderItems {
  late String sId;
  late int qty;
  // late String name;
  // late String image;
  late int price;
  late OrderDetailProduct product;

  OrderItems(
      {required this.sId, required this.qty, required this.price, required this.product});

  OrderItems.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    qty = json['qty'];
    // name = json['name'];
    // image = json['image'];
    price = json['price'];
    //product = json['product'];
    product =
    (json['product'] != null ? OrderDetailProduct.fromJson(
        json['product']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['_id'] = this.sId;
    data['qty'] = this.qty;
    // data['name'] = this.name;
    // data['image'] = this.image;
    data['price'] = this.price;
    //data['product'] = this.product;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}



class OrderDetailProduct {
  late int price;
  late String sId;
  late String name;
  late List<Image> images;

  OrderDetailProduct({required this.price, required this.sId, required this.name, required this.images});

  OrderDetailProduct.fromJson(Map<String, dynamic> json) {
    price = json['price'];
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
    data['_id'] = this.sId;
    data['name'] = this.name;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

