// ignore_for_file: file_names

import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:flutter_t_watch/models/Store.dart';
import 'package:flutter_t_watch/widgets/home/home_singleProduct_widget.dart';
import 'package:velocity_x/velocity_x.dart';


class CatalogModel {
  static List<Products> items = [];

  // Get Item by ID
  Products getById(String id) =>
      items.firstWhere((element) => element.sId == id, orElse: null);

  // Get Item by position
  Products getByPosition(int pos) => items[pos];
}

class CartModel {
  // catalog field
  late HomeSingleProductWidget _catalog;

  // Collection of IDs - store Ids of each item
  final List<String> _itemIds = [];

  // Get Catalog
  HomeSingleProductWidget get catalog => _catalog;

  set catalog(HomeSingleProductWidget newCatalog) {
    assert(newCatalog != null);
    _catalog = newCatalog;
  }

  // Get items in the cart
  List<HomeSingleProductWidget> get items => _itemIds.map((id) => _catalog.getById(id)).toList();

  // Get total price
  num get totalPrice =>
      items.fold(0, (total, current) => total + current.productPrice);
}

class AddMutation extends VxMutation<MyStore> {
  final HomeSingleProductWidget item;

  AddMutation(this.item);
  @override
  perform() {
    store!.cart._itemIds.add(item.id);
  }
}

class RemoveMutation extends VxMutation<MyStore> {
  final HomeSingleProductWidget item;

  RemoveMutation(this.item);
  @override
  perform() {
    store!.cart._itemIds.remove(item.id);
  }
}