// ignore_for_file: file_names

import 'package:flutter_t_watch/models/Cart.dart';
import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:flutter_t_watch/widgets/home/home_singleProduct_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class MyStore extends VxStore {
  late HomeSingleProductWidget catalog;
  late CartModel cart;
  late VxNavigator navigator;
  late List<Products> items;

  MyStore() {
    catalog = CatalogModel() as HomeSingleProductWidget;
    cart = CartModel();
    cart.catalog = catalog;
  }
}