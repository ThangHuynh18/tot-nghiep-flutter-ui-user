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
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/src/flutter/padding.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class HomeSingleProductWidget extends StatefulWidget {
  final String id;
  final String productImage;
  final String productName;
  final String productModel;
  final double productPrice;
  final num productOldPrice;
  final int qty;
  final int discount;
  final double rating;
  final VoidCallback onPressed;
  HomeSingleProductWidget({
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



  static List<HomeSingleProductWidget> items = [];

  // Get Item by ID
  HomeSingleProductWidget getById(String id) =>
      items.firstWhere((element) => element.id == id, orElse: null);

  // Get Item by position
  HomeSingleProductWidget getByPosition(int pos) => items[pos];


  @override
  _HomeSingleProductWidgetState createState() => _HomeSingleProductWidgetState();
}

class _HomeSingleProductWidgetState extends State<HomeSingleProductWidget> {
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
    setState(() {
      token = pref.getString("login");
      //addToWish();
    });
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
      // setState(() {
      //   widget.listItemCart.length++;
      // });

      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added Product to Cart"),));
      EasyLoading.showSuccess('Added ${widget.productName} to Cart');
      // Fluttertoast.showToast(
      //     msg: "Added ${widget.productName} to cart successfully",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );
      //PageRouting.goToNextPage(context: context, navigateTo: YourBagScreen());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Add Product to Cart Fail"),));
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: 250,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: widget.discount > 0 ? Badge(
          position: BadgePosition.topEnd(top: -10, end: -15),
          badgeColor: Colors.red,
          badgeContent: Container(
            width: 30,
            height: 30,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: img.Image.network(
                      widget.productImage,
                      width: 75,
                      height: 75,
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.productName.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.productModel.toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.baseBlackColor,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(widget.productPrice)}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.orange),
                          ),
                          widget.productPrice == widget.productOldPrice ? SizedBox() :
                          Text(
                            "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(widget.productOldPrice)}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough),
                          )



                          // ButtonBar(
                          //   alignment: MainAxisAlignment.spaceBetween,
                          //   buttonPadding: EdgeInsets.zero,
                          //   buttonHeight: 20,
                          //   buttonMinWidth: 20,
                          //   children: [
                          //     AddToCart(product: widget),
                          //   ],
                          // ).pOnly(left: 8.0,right: 8.0, bottom: 8.0,top: 8.0)
                        ],

                      ),
                      // Text(
                      //   "Quantity: ${widget.qty}",
                      //   overflow: TextOverflow.ellipsis,
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Center(
                        child: Row(
                          children: [
                            // Container(
                            //   color: AppColors.baseGrey10Color,
                            //   //width: double.infinity,
                            //   margin: EdgeInsets.symmetric(horizontal: 23),
                            //   child: MaterialButton(
                            //     color: Colors.black,
                            //     height: 25,
                            //     elevation: 0,
                            //     shape: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(5),
                            //       borderSide: BorderSide.none,
                            //     ),
                            //     onPressed:(){
                            //       AddToCart(product: widget);
                            //     },
                            //     child: Text(
                            //       "Add to Cart",
                            //       style: TextStyle(
                            //         fontSize: 20,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            StarRating(rating: widget.rating, size: 12),
                            // SizedBox(width: 5,),
                            // IconButton(onPressed: (){
                            //   addToWish();
                            // },
                            //     icon: SvgPicture.asset(
                            //       SvgImages.heart,
                            //       color: AppColors.baseBlackColor,
                            //       width: 40,
                            //     )),
                            // SizedBox(width: 5,),
                            // IconButton(onPressed: (){
                            //   addToCart();
                            // },
                            //     icon: SvgPicture.asset(
                            //       SvgImages.shoppingCart,
                            //       color: AppColors.baseBlackColor,
                            //       width: 40,
                            //     )),
                          ],
                        ),

                      ),

                  Center(
                    child: Row(
                      children: [
                        IconButton(onPressed: (){
                          addToWish();
                        },
                            // icon: SvgPicture.asset(
                            //   SvgImages.heart,
                            //   color: AppColors.baseBlackColor,
                            //   width: 20,
                            // )
                          icon: Icon(LineIcons.heart),
                        ),
                        Spacer(),
                        //SizedBox(width: 5,),
                        widget.qty > 0 ?
                        IconButton(onPressed: (){
                          addToCart();
                        },
                            icon: Icon(LineIcons.shoppingCart),
                            // SvgPicture.asset(
                            //   SvgImages.shoppingCart,
                            //   color: AppColors.baseBlackColor,
                            //   width: 20,
                            // )
                        )
                        : Text("Out of Stock", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.red, fontSize: 14)),
                      ],
                    ),
                  )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
        : Card(
          elevation: 2,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.transparent,
                  child: img.Image.network(
                    widget.productImage,
                    width: 75,
                    height: 75,
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.productName.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.productModel.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.baseBlackColor,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(widget.productPrice)}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.orange),
                        ),
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

                    Center(
                      child: Row(
                        children: [

                          StarRating(rating: widget.rating, size: 12),

                        ],
                      ),

                    ),

                    Center(
                      child: Row(
                        children: [
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
                          Spacer(),
                          //SizedBox(width: 5,),
                          widget.qty > 0 ?
                          IconButton(onPressed: (){
                            addToCart();
                          },
                              icon: Icon(LineIcons.shoppingCart),
                              // SvgPicture.asset(
                              //   SvgImages.shoppingCart,
                              //   color: AppColors.baseBlackColor,
                              //   width: 20,
                              // )
                          )
                              : Text("Out of Stock", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.red, fontSize: 14)),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
