
import 'dart:convert';

import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:http/http.dart' as http;

class ProductDataProvider {
  Future<Data> getProductItems() async {
    List<Product> list = [];
    //Map<String, dynamic> productList = "";
    List<Products> products = [];
    final baseUrl = "http://localhost:3030";

    // final baseUrl = "http://localhost:5000";



      final response = await http.get(
          Uri.parse("$baseUrl/api/products"),
          headers: {"Accept": "application/json",
            'connection': 'keep-alive'});

      if (response.statusCode == 200) {
        final data = jsonDecode("[${response.body}]");
        print("data : ${data}");


          for (Map<String, dynamic> i in data) {
            list.add(Product.fromJson(i));

          }

          var result = list[0];
          products = result.data.products;
          print("===================="+products.toString()+"==================");

      }


    return Data(products: products, page: 0, pages: 0);
  }
}