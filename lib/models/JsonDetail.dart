
// ignore_for_file: file_names

import 'package:flutter_t_watch/models/ProductModel.dart';

// ignore: file_names
class JsonDetail {
  late String status;
  late Products data;
  late String errors;

  JsonDetail({required this.status, required this.data, required this.errors});

  JsonDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = (json['data'] != null ? new Products.fromJson(json['data']) : null)!;
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