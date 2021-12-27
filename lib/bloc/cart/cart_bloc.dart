import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_t_watch/data/product_data.dart';
import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  ProductDataProvider productDataProvider = ProductDataProvider();
  CartBloc() : super(CartInitial()) {
   add(CartPageInitializedEvent());
  }

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is CartPageInitializedEvent) {
      //ShopData shopData = await productDataProvider.getShopItems();
      Data cartData = await productDataProvider.getProductItems();
      yield CartPageLoadedState(cartData: cartData);
    }
    if (event is ItemAddingCartEvent) {
      yield ItemAddingCartState(cartItems: event.cartItems);
    }
    if (event is ItemAddedCartEvent) {
      yield ItemAddedCartState(cartItems: event.cartItems);
    }
    if (event is ItemDeleteCartEvent) {
      yield ItemDeletingCartState(cartItems: event.cartItems);
    }
  }
}
