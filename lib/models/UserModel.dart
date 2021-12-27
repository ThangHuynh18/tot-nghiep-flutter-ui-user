// ignore_for_file: file_names

class User {
  late ShippingAddress shippingAddress;
  late bool deleted;
  late String sId;
  late String name;
  late String email;
  late String password;
  late String role;
  late String phone;
  late String avatar;
  late List<WishListItems> wishListItems;
  late List<CartListItems> cartListItems;
  late String token;
  late String createdAt;
  late String updatedAt;
  late int iV;

  User(
      {required this.shippingAddress,
        required this.deleted,
        required this.sId,
        required this.name,
        required this.email,
        required this.password,
        required this.role,
        required this.phone,
        required this.avatar,
        required this.wishListItems,
        required this.cartListItems,
        required this.createdAt,
        required this.updatedAt,
        required this.iV});

  User.forLogin({sId, name, email, phone, token, wishListItems}) :
    this.sId = sId,
    this.name = name,
    this.email = email,
    this.phone = phone,
    this.token = token,
    this.wishListItems = wishListItems;


  User.fromJson(Map<String, dynamic> json) {
    shippingAddress = (json['shippingAddress'] != null ? new ShippingAddress.fromJson(json['shippingAddress']) : null)!;
    deleted = json['deleted'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    phone = json['phone'];
    avatar = json['avatar'];
    if (json['wishListItems'] != null) {
      wishListItems = <WishListItems>[];
      json['wishListItems'].forEach((v) {
        wishListItems.add(new WishListItems.fromJson(v));
      });
    }
    if (json['cartItems'] != null) {
      cartListItems = <CartListItems>[];
      json['cartItems'].forEach((v) {
        cartListItems.add(new CartListItems.fromJson(v));
      });
    }
    token = json['token'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shippingAddress != null) {
      data['shippingAddress'] = this.shippingAddress.toJson();
    }
    data['deleted'] = this.deleted;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['role'] = this.role;
    data['phone'] = this.phone;
    data['avatar'] = this.avatar;
    if (this.wishListItems != null) {
      data['wishListItems'] =
          this.wishListItems.map((v) => v.toJson()).toList();
    }
    if (this.cartListItems != null) {
      data['cartItems'] =
          this.cartListItems.map((v) => v.toJson()).toList();
    }
    data['token'] = this.token;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class ShippingAddress {
  late String address;
  late String city;
  late String district;
  late String ward;

  ShippingAddress({required this.address, required this.city, required this.district, required this.ward});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    district = json['district'];
    ward = json['ward'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city'] = this.city;
    data['district'] = this.district;
    data['ward'] = this.ward;
    return data;
  }
}

class WishListItems {
  late String sId;
  late String product;

  WishListItems({required this.sId, required this.product});

  WishListItems.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    product = json['product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['product'] = this.product;
    return data;
  }
}

class CartListItems {
  late String sId;
  late String product;
  late String qty;

  CartListItems({required this.sId, required this.product, required this.qty});

  CartListItems.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    product = json['product'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['product'] = this.product;
    data['qty'] = this.qty;
    return data;
  }
}

class Profile {
  late String sId;
  late String name;
  late String email;
  late String phone;
  late String avatar;
  //late List<CartListItems> cartItems;
  late List<WishListItems> wishItems;
  late ShippingAddress shippingAddress;
  late String role;

  Profile({required this.sId,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    //required this.cartItems,
    required this.wishItems,
    required this.shippingAddress,
    required this.role});

  Profile.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    avatar = json['avatar'];
    if (json['wishListItems'] != null) {
      wishItems = <WishListItems>[];
      json['wishListItems'].forEach((v) {
        wishItems.add(new WishListItems.fromJson(v));
      });
    }
    // if (json['cartItems'] != null) {
    //   cartItems = <CartListItems>[];
    //   json['cartItems'].forEach((v) {
    //     cartItems.add(new CartListItems.fromJson(v));
    //   });
    // }
    shippingAddress =
    (json['shippingAddress'] != null ? new ShippingAddress.fromJson(
        json['shippingAddress']) : null)!;
    role = json['role'];
  }
}


class OrderItem {
  late int qty;
  // late String name;
  // late String image;
  late String product;
  late int price;

  // OrderItem({required this.qty, required this.name, required this.image, required this.productId, required this.itemPrice});
  OrderItem();

  OrderItem.fromJson(Map<String, dynamic> json) {
    qty = json['qty'];
    // name = json['name'];
    // image = json['image'];
    price = json['price'];
    product = json['product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qty'] = this.qty;
    // data['name'] = this.name;
    // data['image'] = this.image;
    data['price'] = this.price;
    data['product'] = this.product;
    return data;
  }
}

class UploadImage {
  late String fileName;
  late String fileLocation;

  UploadImage.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    fileLocation = json['fileLocation'];
  }
}

class ImageForUpload {
  ImageForUpload({
    required this.url,
  });

  String url;

  factory ImageForUpload.fromJson(Map<String, dynamic> json) => ImageForUpload(
    url: json["imageLink"],
  );

  Map<String, dynamic> toJson() => {
    "imageLink": url,
  };
}