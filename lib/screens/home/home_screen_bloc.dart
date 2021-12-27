import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_t_watch/bloc/cart/cart_bloc.dart';
import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:flutter_t_watch/screens/cart/cart_screen.dart';
import 'package:flutter_t_watch/screens/detail/detail_product_screen.dart';
import 'package:flutter_t_watch/widgets/home/home_one_product_widget.dart';
import 'package:flutter_t_watch/widgets/home/home_singleProduct_widget.dart';

class HomeScreenBloc extends StatefulWidget {
  const HomeScreenBloc({Key? key}) : super(key: key);

  @override
  _HomeScreenBlocState createState() => _HomeScreenBlocState();
}

class _HomeScreenBlocState extends State<HomeScreenBloc> {
  bool loadingData = true;
  List<Products> _cartItems = [];
  late List<Products> shopItems;
  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartInitial) {
          loadingData = true;
        } else if (state is CartPageLoadedState) {
          shopItems = state.cartData.products;
          _cartItems = state.cartData.products;
          loadingData = false;
          print("=========="+shopItems.toString()+ "+++++++++++" +shopItems.length.toString());
        }
        if (state is ItemAddedCartState) {
          _cartItems = state.cartItems;
          loadingData = false;
        }
        if (state is ItemDeletingCartState) {
          _cartItems = state.cartItems;
          loadingData = false;
        }
      },
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          print("produc page state: $state");

          return Scaffold(
            appBar: AppBar(
              title: Text(
                "E-com",
              ),
              elevation: 0,
              backgroundColor: Colors.orange,
            ),
            backgroundColor: Color(0xFFEEEEEE),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.orange,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<CartBloc>(context),
                            child: ShoppingCart())));
              },
              child: Text(
                _cartItems.length.toString(),
              ),
            ),
            body: loadingData
                ? Center(
                child: Center(
                  child: CircularProgressIndicator(),
                ))
                : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    overflow: Overflow.visible,
                    children: [
                      Container(
                        // height: displayHeight(context) * 6,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            GridView.builder(
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.6,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                ),
                                itemCount: shopItems.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return HomeOneProductWidget(
                                    addToCart: () {
                                      setState(() {
                                        _cartItems.add(shopItems[index]);
                                      });

                                      print("added");
                                    },
                                    // productImage:
                                    //     shopItems[index].imageUrl,
                                    productImage:
                                    shopItems[index].images[0].url,
                                    productPrice: shopItems[index].price as double,
                                    productName: shopItems[index].name,
                                    productModel: shopItems[index].brand.name,
                                    id: shopItems[index].sId,
                                    qty: shopItems[index].countInStock,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider.value(
                                                      value: BlocProvider
                                                          .of<CartBloc>(
                                                          context)
                                                        ..add(ItemAddingCartEvent(
                                                            cartItems:
                                                            _cartItems)),
                                                      child:
                                                      DetailProductScreen(
                                                        data:
                                                        shopItems[
                                                        index],
                                                      ))));
                                    },
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
