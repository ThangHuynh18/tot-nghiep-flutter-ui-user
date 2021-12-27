import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_t_watch/bloc/cart/cart_bloc.dart';
import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:flutter/src/widgets/image.dart' as img;

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  late List<Products> cartItems;
  double totalAmount = 0;
  void calculateTotalAmount(List<Products> list) {
    double res = 0;

    list.forEach((element) {
      res = res + element.price * element.countInStock;
    });
    totalAmount = res;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is ItemAddedCartState) {
          cartItems = state.cartItems;
          calculateTotalAmount(cartItems);
        }
        if (state is CartPageLoadedState) {
          cartItems = state.cartData.products;
          calculateTotalAmount(cartItems);
        }
        if (state is ItemDeletingCartState) {
          cartItems = state.cartItems;
          calculateTotalAmount(cartItems);
        }

        if (state is ItemAddingCartState) {
          cartItems = state.cartItems;
          calculateTotalAmount(cartItems);
        }
        return Scaffold(
          backgroundColor: Colors.yellow,
          appBar: AppBar(
            backgroundColor: Color(0XFFF8F5F0),
            title: Text(
              'Shopping Cart',
              style: TextStyle(color: Colors.purple),
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          bottomNavigationBar: Container(
            height: 68,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 8,
                    color: Color(0xFF000000).withOpacity(0.20),
                  ),
                  BoxShadow(
                    offset: Offset(0, -1),
                    blurRadius: 3,
                    color: Color(0xFF000000).withOpacity(0.20),
                  ),
                  BoxShadow(
                    offset: Offset(0, -1),
                    blurRadius: 4,
                    color: Color(0xFF000000).withOpacity(0.14),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                )),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text('Total Amount'),
                  Text('\$${totalAmount.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          body: cartItems == null || cartItems.length == 0
              ? Center(child: Text('Your Cart is Empty'))
              : ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            img.Image.network(
                              cartItems[index].images[0].url,
                              height: 64,
                              width: 64,
                            ),
                            SizedBox(width: 20),
                            Text(cartItems[index].name),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  if (state is CartPageLoadedState) {
                                    state.cartData.products
                                        .removeAt(index);
                                    calculateTotalAmount(cartItems);
                                    BlocProvider.of<CartBloc>(context)
                                      ..add(ItemDeleteCartEvent(
                                          cartItems:
                                          state.cartData.products));
                                  } else if (state
                                  is ItemAddedCartState) {
                                    state.cartItems.removeAt(index);
                                    calculateTotalAmount(cartItems);

                                    BlocProvider.of<CartBloc>(context)
                                      ..add(ItemDeleteCartEvent(
                                          cartItems: state.cartItems));
                                  } else if (state
                                  is ItemDeletingCartState) {
                                    state.cartItems.removeAt(index);
                                    calculateTotalAmount(cartItems);

                                    BlocProvider.of<CartBloc>(context)
                                      ..add(ItemDeleteCartEvent(
                                          cartItems: state.cartItems));
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                if (cartItems[index].countInStock > 0)
                                  setState(() {
                                    calculateTotalAmount(cartItems);
                                    cartItems[index].countInStock--;
                                  });
                              },
                            ),
                            SizedBox(
                              height: 20,
                              width: 30,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 0.5)),
                                child: Text(
                                  cartItems[index].countInStock.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  calculateTotalAmount(cartItems);
                                  cartItems[index].countInStock++;
                                });
                              },
                            ),
                            Spacer(),
                            Text(
                                '\$${cartItems[index].price * cartItems[index].countInStock} ')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
