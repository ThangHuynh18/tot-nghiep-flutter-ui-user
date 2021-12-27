// ignore_for_file: file_names

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/wish_list_screen.dart';
import 'package:flutter_t_watch/screens/your_bag_screen.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/widgets/cart/add_to_cart_widget.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:flutter_t_watch/widgets/star_rating_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/src/flutter/padding.dart';
import 'package:http/http.dart' as http;

class HomeProductRatingWidget extends StatefulWidget {
  final String id;
  final String productImage;
  final String productName;
  final String productModel;
  final num productPrice;
  final num productOldPrice;
  final int qty;
  final int discount;
  final double rating;
  final VoidCallback onPressed;
  HomeProductRatingWidget({
    required this.id,
    required this.productImage,
    required this.productName,
    required this.productModel,
    required this.productPrice,
    required this.productOldPrice,
    required this.qty,
    required this.discount,
    required this.rating,
    required this.onPressed,
  });


  @override
  _HomeProductRatingWidgetState createState() => _HomeProductRatingWidgetState();
}

class _HomeProductRatingWidgetState extends State<HomeProductRatingWidget> {
  bool isFave = false;
  String token = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  void getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(mounted){
      setState(() {
        token = pref.getString("login");
        //addToWish();
      });
    }

  }

  Future<void> addToWish() async {
    var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/wishlist/add-to-wishlist/${widget.id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added Product to Wishlist"),));
      Fluttertoast.showToast(
          msg: "Added ${widget.productName} to wishlist successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

      //PageRouting.goToNextPage(context: context, navigateTo: WishListScreen());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Add Product to Wishlist Fail"),));
    }
  }


  Future<void> addToCart() async {
    print("TOKEN FOR API IS HERE---------------"+token+"AND ID OF PRODUCT:::"+widget.id);
    var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/cart/add-to-cart/${widget.id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      EasyLoading.showSuccess('Added ${widget.productName} to Cart');
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added ${widget.productName} to Cart"),));
     // await EasyLoading.dismiss();
     // PageRouting.goToNextPage(context: context, navigateTo: YourBagScreen());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Add Product to Cart Fail"),));
    }
  }


  @override
  Widget build(BuildContext context) {
    double trendCardWidth = 180;

    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            // padding: const EdgeInsets.only(bottom: 8.0, right: 3.0),
            width: trendCardWidth,
            child: widget.discount > 0 ?  Badge(
              position: BadgePosition.topEnd(top: -5, end: -12),
              badgeColor: Colors.red,
              badgeContent: Container(
                width: 27,
                height: 27,
                alignment: Alignment.center,
                child: Text(
                  'Sale ${widget.discount.toString()}%',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              child: Card(
                elevation: 2,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(onPressed: (){
                            addToCart();
                          },
                              icon: Icon(LineIcons.shoppingCart),
                              // SvgPicture.asset(
                              //   SvgImages.shoppingCart,
                              //   color: AppColors.baseBlackColor,
                              //   width: 20,
                              // )
                          ),
                          Spacer(),
                          Row(
                            children: [
                              // IconButton(onPressed: (){
                              //   addToCart();
                              // },
                              //     icon: SvgPicture.asset(
                              //       SvgImages.shoppingCart,
                              //       color: AppColors.baseBlackColor,
                              //       width: 40,
                              //     )),
                              // SizedBox(width: 5,),
                              IconButton(onPressed: (){
                                addToWish();
                              },
                                  icon: Icon(LineIcons.heart),
                                  // SvgPicture.asset(
                                  //   SvgImages.heart,
                                  //   color: AppColors.baseBlackColor,
                                  //   width: 20,
                                  // )
                              ),

                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: 90,
                              height: 90,
                              child: img.Image.network(
                                widget.productImage,
                                // fit: BoxFit.cover,
                              ),

                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 3,),
                          Text(
                            widget.productModel.toUpperCase(),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            widget.productName.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          StarRating(rating: widget.rating, size: 12),
                          Row(
                            children: <Widget>[
                              Text("${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(widget.productPrice)}",
                                  style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange)),
                              widget.productPrice == widget.productOldPrice ? SizedBox() :
                              Text(
                                "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(widget.productOldPrice)}",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough),
                              )
                            ],
                          ),

                          // MaterialButton(
                          //   color: AppColors.baseLightPinkColor,
                          //   elevation: 0,
                          //   height: 22,
                          //   shape: RoundedRectangleBorder(
                          //       side: BorderSide.none,
                          //       borderRadius: BorderRadius.circular(0.7)
                          //   ),
                          //   onPressed: () {addToCart();},
                          //   child: Row(
                          //     children: [
                          //       Text("Add to cart", style: TextStyle(fontSize: 14),),
                          //       SvgPicture.asset(
                          //         SvgImages.shoppingCart,
                          //         color: AppColors.baseBlackColor,
                          //         width: 20,
                          //       ),
                          //     ],
                          //   ),
                          // ),


                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
            : Card(
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(onPressed: (){
                          addToCart();
                        },
                          icon: Icon(LineIcons.shoppingCart),

                        ),
                        Spacer(),
                        Row(
                          children: [
                            IconButton(onPressed: (){
                              addToWish();
                            },
                              icon: Icon(LineIcons.heart),

                            ),

                          ],
                        ),
                      ],
                    ),
                    Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                            width: 90,
                            height: 90,
                            child: img.Image.network(
                              widget.productImage,
                              // fit: BoxFit.cover,
                            ),

                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 3,),
                        Text(
                          widget.productModel.toUpperCase(),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          widget.productName.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        StarRating(rating: widget.rating, size: 12),
                        Row(
                          children: <Widget>[
                            Text("${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(widget.productPrice)}",
                                style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange)),
                            widget.productPrice == widget.productOldPrice ? SizedBox() :
                            Text(
                              "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(widget.productOldPrice)}",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),


            // Card(
            //     elevation: 2,
            //     color: Colors.white,
            //     child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //
            //       Expanded(
            //         child: Container(
            //           width: double.infinity,
            //           color: Colors.transparent,
            //           child: img.Image.network(
            //             widget.productImage,
            //             width: 75,
            //             height: 75,
            //             // fit: BoxFit.cover,
            //           ),
            //         ),
            //       ),
            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 10),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Text(
            //               widget.productName.toUpperCase(),
            //               overflow: TextOverflow.ellipsis,
            //               style: TextStyle(
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Text(
            //               widget.productModel.toUpperCase(),
            //               overflow: TextOverflow.ellipsis,
            //               style: TextStyle(
            //                 color: AppColors.baseBlackColor,
            //               ),
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               children: [
            //                 Text(
            //                   "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(widget.productPrice)}",
            //                   overflow: TextOverflow.ellipsis,
            //                   style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.orange),
            //                 ),
            //                 widget.productPrice == widget.productOldPrice ? SizedBox() :
            //                 Text(
            //                   "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(widget.productOldPrice)}",
            //                   style: TextStyle(
            //                       color: Colors.grey,
            //                       fontSize: 10,
            //                       decoration: TextDecoration.lineThrough),
            //                 )
            //
            //               ],
            //
            //             ),
            //
            //             Center(
            //               child: Row(
            //                 children: [
            //
            //                   StarRating(rating: widget.rating, size: 12),
            //
            //                 ],
            //               ),
            //
            //             ),
            //
            //             Center(
            //               child: Row(
            //                 children: [
            //                   IconButton(onPressed: (){
            //                     addToWish();
            //                   },
            //                       icon: Icon(LineIcons.heart),
            //                       // SvgPicture.asset(
            //                       //   SvgImages.heart,
            //                       //   color: AppColors.baseBlackColor,
            //                       //   width: 20,
            //                       // )
            //                   ),
            //                   Spacer(),
            //                   //SizedBox(width: 5,),
            //                   widget.qty > 0 ?
            //                   IconButton(onPressed: (){
            //                     addToCart();
            //                   },
            //                       icon: Icon(LineIcons.shoppingCart),
            //                       // SvgPicture.asset(
            //                       //   SvgImages.shoppingCart,
            //                       //   color: AppColors.baseBlackColor,
            //                       //   width: 20,
            //                       // )
            //                   )
            //                       : Text("Out of Stock", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.red, fontSize: 14)),
            //                 ],
            //               ),
            //             )
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ),
        ],
      ),
      onTap: widget.onPressed,
    );
  }
}
