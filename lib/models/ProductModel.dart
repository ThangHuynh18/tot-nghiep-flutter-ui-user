// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names

import 'dart:convert';

Product productDataFromJson(String str) => Product.fromJson(json.decode(str));
class Product {
  late String status;
  late Data data;
  late String errors;

  Product({required this.status, required this.data, required this.errors});

  Product.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['errors'] = this.errors;
    return data;
  }
}

class Data {
  late List<Products> products;
  late int page;
  late int pages;

  Data({required this.products, required this.page, required this.pages});


  void addProduct(Products p) {
    products.add(p);
  }

  void removeProduct(Products p) {
    products.add(p);
  }


  Data.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    page = json['page'];
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['pages'] = this.pages;
    return data;
  }
}

class DataAllProduct{
  late List<Products> products;

  DataAllProduct.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
  }
}

class Products {
  late int discount;
  late num rating;
  late int numberReviews;
  late num price;
  late int countInStock;
  late bool deleted;
  late String sId;
  late String user;
  late String name;
  late List<Image> images;
  late Brand brand;
  late Category category;
  late String description;
  late List<Review> reviews;
  late String createdAt;
  late String updatedAt;
  late int iV;




  Products(
      {required this.discount,
        required this.rating,
        required this.numberReviews,
        required this.price,
        required this.countInStock,
        required this.deleted,
        required this.sId,
        required this.user,
        required this.name,
        required this.images,
        required this.brand,
        required this.category,
        required this.description,
        required this.reviews,
        required this.createdAt,
        required this.updatedAt,
        required this.iV});


  static List<Products> items = [];

  // Get Item by ID
  Products getById(String id) =>
      items.firstWhere((element) => element.sId == id, orElse: null);

  // Get Item by position
  Products getByPosition(int pos) => items[pos];

  factory Products.fromJsonSearch(Map<String, dynamic> json) => Products(
      discount: json["discount"],
      rating: json["rating"],
      numberReviews: json["numberReviews"],
      price: json["price"],
      countInStock: json["countInStock"],
      deleted: json["deleted"],
      sId: json["_id"],
      user: json["user"],
      name: json["name"],
      images: json['images'],
      brand: Brand.fromJson(json["brand"]),
      category: Category.fromJson(json["category"]),
      description: json["description"],
      reviews: json['reviews'],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      iV: json["__v"]
  );

  factory Products.fromJson(Map<String, dynamic> json) {
    final reviewsData = json['reviews'] as List<dynamic>;
    final reviews = reviewsData != null
        ? reviewsData.map((reviewData) => Review.fromJson(reviewData))
        .toList()
        : <Review>[];

    final imagesData = json['images'] as List<dynamic>;
    final images = imagesData != null
        ? imagesData.map((imageData) => Image.fromJson(imageData))
        .toList()
        : <Image>[];
    return Products(
    discount: json["discount"],
    rating: json["rating"],
    numberReviews: json["numberReviews"],
    price: json["price"],
    countInStock: json["countInStock"],
    deleted: json["deleted"],
    sId: json["_id"],
    user: json["user"],
    name: json["name"],
    images: images,
    brand: Brand.fromJson(json["brand"]),
    category: Category.fromJson(json["category"]),
    description: json["description"],
    reviews: reviews,
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    iV: json["__v"]
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discount'] = this.discount;
    data['rating'] = this.rating;
    data['numberReviews'] = this.numberReviews;
    data['price'] = this.price;
    data['countInStock'] = this.countInStock;
    data['deleted'] = this.deleted;
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['name'] = this.name;
    if (this.images != null) {
      data['images'] = images.map((v) => v.toJson()).toList();
    }
    if (this.brand != null) {
      data['brand'] = this.brand.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['description'] = this.description;
    if (this.reviews != null) {
      data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Brand {
  Brand({
    required this.brandId,
    required this.name,
    // required this.brand,
  });

  String brandId;
  String name;
  // String brand;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    brandId: json["_id"],
    name: json["name"],
    // brand: json["brand"],
  );

  Map<String, dynamic> toJson() => {
    "_id": brandId,
    "name": name,
    // "brand": brand,
  };
}

class Category {
  Category({
    required this.cateId,
    required this.name,
    //required this.category,
  });

  String cateId;
  String name;
  //String category;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    cateId: json["_id"],
    name: json["name"],
    //category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "_id": cateId,
    "name": name,
    //"category": category,
  };
}

class Image {
  Image({
    required this.imageId,
    required this.url,
  });

  String imageId;
  String url;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    imageId: json["_id"],
    url: json["imageLink"],
  );

  Map<String, dynamic> toJson() => {
    "_id": imageId,
    "imageLink": url,
  };
}

class Review {
  Review({
    required this.id,

    required this.rating,
    required this.comment,
    required this.user,
    required this.createdAt,
  });

  String id;
  //String name;
  int rating;
  String comment;
  //String user;
  UserReview user;
  DateTime createdAt;

  factory Review.fromJson(Map<String, dynamic> json) =>
      Review(
        id: json["_id"],
        // name: json["name"],
        rating: json["rating"],
        comment: json["comment"],
        //user: json["user"],
        user: UserReview.fromJson(json["user"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['_id'] = this.id;
    data['comment'] = this.comment;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['createdAt'] = this.createdAt;
    return data;
  }

}


class UserReview {
  UserReview({
    required this.id,
    required this.name,
    required this.avatar
  });

  String id;
  String name;
  String avatar;

  factory UserReview.fromJson(Map<String, dynamic> json) => UserReview(
    id: json["_id"],
    name: json["name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "avatar": avatar,
  };
}
