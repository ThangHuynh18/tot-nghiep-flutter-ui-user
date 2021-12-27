part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartPageLoadedState extends CartState {
 // ShopData shopData;
  late Data cartData;

  CartPageLoadedState({required this.cartData});
}

class ItemAddingCartState extends CartState {
  Data? cartData;
  List<Products> cartItems;

  ItemAddingCartState({ this.cartData, required this.cartItems});
}

class ItemAddedCartState extends CartState {
  List<Products> cartItems;

  ItemAddedCartState({required this.cartItems});
}

class ItemDeletingCartState extends CartState {
  List<Products> cartItems;

  ItemDeletingCartState({required this.cartItems});
}

