import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_t_watch/models/Cart.dart';
import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:flutter_t_watch/models/Store.dart';
import 'package:flutter_t_watch/widgets/home/home_singleProduct_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class AddToCart extends StatelessWidget {
  final HomeSingleProductWidget product;
  AddToCart({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [AddMutation, RemoveMutation]);
    final CartModel _cart = (VxState.store as MyStore).cart;
    bool isInCart = _cart.items.contains(product);
    return ElevatedButton(
      onPressed: () {
        if (!isInCart) {
          AddMutation(product);
        }
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(context.theme.buttonColor),
          shape: MaterialStateProperty.all(
            StadiumBorder(),
          )),
      child: isInCart ? Icon(Icons.done) : Icon(CupertinoIcons.cart_badge_plus),
    );
  }
}