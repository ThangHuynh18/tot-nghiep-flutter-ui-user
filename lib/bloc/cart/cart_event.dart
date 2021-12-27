part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class CartPageInitializedEvent extends CartEvent {}

class ItemAddingCartEvent extends CartEvent {
  List<Products> cartItems;

  ItemAddingCartEvent({required this.cartItems});
}

class ItemAddedCartEvent extends CartEvent {
  List<Products> cartItems;

  ItemAddedCartEvent({required this.cartItems});
}

class ItemDeleteCartEvent extends CartEvent {
  List<Products> cartItems;
  int? index;
  ItemDeleteCartEvent({required this.cartItems,  this.index});
}
