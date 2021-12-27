// ignore_for_file: file_names
class MyVoucher {
  late String sId;
  late String name;
  late int discount;
  //late String voucherId;

  MyVoucher({required this.sId, required this.name, required this.discount});

  MyVoucher.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    discount = json['discount'];
    //voucherId = json['voucherId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['discount'] = this.discount;
    //data['voucherId'] = this.voucherId;
    return data;
  }
}




class Voucher {
  late String sId;
  late String name;
  late int discount;
  late String createdAt;
  late String updatedAt;
  late int iV;

  Voucher(
      {required this.sId,
        required this.name,
        required this.discount,
        required this.createdAt,
        required this.updatedAt,
        required this.iV});

  Voucher.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    discount = json['discount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['discount'] = this.discount;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
