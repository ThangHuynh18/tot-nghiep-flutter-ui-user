// ignore_for_file: implementation_imports
import 'package:flutter_t_watch/mybottombar/my_bottom_bar.dart';
import 'package:flutter_t_watch/screens/get_product_by/get_by_brand_screen.dart' as productScreen;
import 'package:flutter_t_watch/screens/home/home_screen.dart';
import 'package:flutter_t_watch/screens/your_bag_screen.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/widgets/cart/add_to_cart_widget.dart';
import 'package:flutter_t_watch/widgets/home/home_product_rating_widget.dart';
import 'package:flutter_t_watch/widgets/star_rating_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/data/detail_screen_data.dart';
import 'package:flutter_t_watch/models/JsonDetail.dart';
import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/styles/detail_screen_stylies.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:flutter_t_watch/widgets/drop_button_widget.dart';
import 'package:flutter_t_watch/widgets/singleProductForDetailScreen_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../detail_screen.dart';

class DetailProductScreen extends StatefulWidget {
  final Products data;
  DetailProductScreen({required this.data});

  @override
  _DetailProductScreenState createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {


  String activeImg = '';
  int qty = 1;

  String token = "";
  //String avatar = "";
  num detailPrice = 0;

  List<JsonDetail> list = [];
  var loading = false;

  // final baseUrl = "http://localhost:5000";

  Future<Null> _fetchData() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/api/products/${widget.data.sId}"),
        headers: {"Accept": "application/json",
          'connection': 'keep-alive'});

    if (response.statusCode == 200) {
      final data = jsonDecode("[${response.body}]");
      print("data : ${data}");

      setState(() {
        for (Map<String, dynamic> i in data) {
          list.add(JsonDetail.fromJson(i));
        }
        loading = false;
      });
    }
  }


  void getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("login");
      //avatar = pref.getString("avatar");
    });
  }


  Future<void> addToCart(String id) async {
    print("TOKEN FOR API IS HERE---------------"+token+"AND ID OF PRODUCT:::"+id);
    var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/cart/add-to-cart/${id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
        body: jsonEncode(<String, int>{
          "quantity": qty
        }
    ));

    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added Product to Cart"),));

      PageRouting.goToNextPage(context: context, navigateTo: YourBagScreen());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Add Product to Cart Fail"),));
    }
  }


  List<Products> listResult =[];
  List<productScreen.Product> listJson = [];
  Future<Null> getRelatedProduct() async {

    final response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/api/products/brand/${widget.data.brand.brandId}"),
        headers: {"Accept": "application/json",
          'connection': 'keep-alive'});

    if (response.statusCode == 200) {
      final data = jsonDecode("[${response.body}]");
      print("data of product by brand: ${data}");

      setState(() {
        for (Map<String, dynamic> i in data) {
          listJson.add(productScreen.Product.fromJson(i));
        }

        var result = listJson[0];
        listResult = result.products;

      });
    }

  }


  Future<void> addToWish() async {
    var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/wishlist/add-to-wishlist/${widget.data.sId}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added Product to Wishlist"),));
      Fluttertoast.showToast(
          msg: "Added ${widget.data.name} to wishlist successfully",
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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_fetchData();
    activeImg = widget.data.images[0].url;
    getToken();
    getRelatedProduct();
    if(widget.data.discount > 0 ){
      detailPrice = widget.data.price * (100 - widget.data.discount) * 0.01;
    } else {
      detailPrice = widget.data.price;
    }
  }


  String? ratingController;
  PreferredSize buildAppBar(){
    return PreferredSize(
      preferredSize: Size.fromHeight(70),
      child: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MyBottomBar(selectIndex: 0,)), (route) => false);}),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.data.name.toUpperCase(),
          style: TextStyle(
            color: AppColors.baseWhiteColor,
          ),
        ),
        actions: [
          IconButton(onPressed: () {
            addToWish();
          }, icon: SvgPicture.asset(
            SvgImages.heart,
            color: AppColors.baseWhiteColor,
            width: 35,
            semanticsLabel: "Fave",
          )),
          // IconButton(onPressed: () {}, icon: SvgPicture.asset(
          //   SvgImages.upload,
          //   color: AppColors.baseBlackColor,
          //   width: 35,
          //   semanticsLabel: "Fave",
          // )),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ListView(

        physics: BouncingScrollPhysics(),
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(
                  "images/Logo.png"
              ),
            ),
            title: Column(
              children: [
                Text(widget.data.category.name,
                  style: DetailScreenStylies.productModelStyle,),
                SizedBox(height: 5,),
                Text(widget.data.brand.name.toUpperCase(),
                  style: DetailScreenStylies.productModelStyle,),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8,),
                Text(
                  "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(detailPrice)}",
                  style: DetailScreenStylies.productPriceStyle,
                ),
                SizedBox(height: 5,),
                widget.data.discount > 0 ? Text("${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(widget.data.price)}",
                  style: TextStyle(color: Colors.grey,
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough),)
                    : SizedBox()
                // Text(
                //   widget.data.category.name,
                //   style: DetailScreenStylies.productModelStyle,
                // ),
              ],
            ),
          ),

          Padding(padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: img.Image.network(
                    activeImg,
                    fit: BoxFit.cover,
                  ),
                ),
                // Row(
                //   children: [
                //     // Expanded(child: Container(
                //     //   margin: EdgeInsets.only(right: 15, top: 15),
                //     //   child: img.Image.network(widget.data.images[1].url, fit: BoxFit.cover,),
                //     // )),
                //     Expanded(
                //       child: ListView.builder(
                //           shrinkWrap: true,
                //           primary: true,
                //           itemCount: widget.data.images.length,
                //           itemBuilder: (context, index) {
                //             var item = widget.data.images[index];
                //             //var imageList = item.data.images;
                //             var imgItem = item.url;
                //
                //             return Row(
                //               children: [
                //                 Expanded(child: Container(
                //                   margin: EdgeInsets.only(right: 15, top: 15),
                //                   width: 150,
                //                   height: 150,
                //                   child: img.Image.network(imgItem),
                //                 )),
                //               ],
                //             );
                //           }
                //         ),
                //     ),
                //
                //
                //   ],
                // )
              ],
            ),),



          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                    child: Wrap(
                        children: List.generate(widget.data.images.length, (index){
                          return Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  activeImg = widget.data.images[index].url;
                                });
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage(widget.data.images[index].url),fit: BoxFit.cover),
                                    border: Border.all(
                                      width: 1,

                                    ),
                                    borderRadius: BorderRadius.circular(5)
                                ),

                              ),
                            ),
                          );
                        })
                    )
                ),
              ],
            ),
          ),




          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: widget.data.countInStock > 0 ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Quantity :",style: TextStyle(
                    fontSize: 18,
                    height: 1.5
                ),),
                SizedBox(width: 20,),
                Flexible(
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: (){
                            if(qty > 1){
                              setState(() {
                                qty = --qty;
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.baseBlackColor.withOpacity(0.5)
                                )
                            ),
                            width: 35,
                            height: 35,
                            child: Icon(LineIcons.minus,color: AppColors.baseBlackColor.withOpacity(0.5),),
                          ),
                        ),
                        SizedBox(width: 25,),
                        Text(qty.toString(),style: const TextStyle(
                            fontSize: 16
                        ),),
                        SizedBox(width: 25,),
                        InkWell(
                          onTap: (){
                            setState(() {
                              qty = ++qty;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.baseBlackColor.withOpacity(0.5)
                                )
                            ),
                            width: 35,
                            height: 35,
                            child: Icon(LineIcons.plus,color: AppColors.baseBlackColor.withOpacity(0.5),),
                          ),
                        )
                      ],
                    )
                ),
              ],
            ) : SizedBox(),
          ),




          // Row(
          //   children: [
          //     Expanded(child: DropButton(
          //       hintText: "Quantity",
          //       items: ["red", "blue", "white", "black", "pink"],
          //       ratringController: ratingController,
          //     ))
          //   ],
          // ),

          Padding(
              padding: EdgeInsets.all(16.0),
              child: widget.data.countInStock > 0 ? MaterialButton(
                elevation: 0,
                height: 50,
                color: AppColors.baseDarkGreenColor,
                shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Text(
                  "Add to Cart",
                  style: DetailScreenStylies.buttonTextStyle,
                ),
                onPressed: () {
                  addToCart(widget.data.sId);
                },
              )
                  : Padding(padding: EdgeInsets.only(left: 6),
                  child: Text("Out of Stock", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20),),)
          ),

          ExpansionTile(title: Text(
              "Description",
              style: DetailScreenStylies.descriptionTextStyle
          ),
            children: [
              ListTile(
                title: Wrap(
                  children: [
                    Text(widget.data.description,
                      style: TextStyle(fontSize: 16),),

                  ],
                ),
              )
            ],),

          _buildComments(context),

          ListTile(
            leading: Text(
                "You may also like",
                style: DetailScreenStylies.youmayalsolikeTextStyle
            ),
            trailing: Text(
              "Show All",
              style: DetailScreenStylies.showAllTextStyle,
            ),
          ),

          Container(
            height: 240,
            child: GridView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                primary: true,
                itemCount: listResult.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.5
                ),
                itemBuilder: (context, index) {
                  var dataDetail = listResult[index];
                  var price;

                  if (dataDetail.discount > 0) {
                    price = ((100 - dataDetail.discount) * dataDetail.price * 0.01) as double;
                  } else {
                    price = dataDetail.price.toDouble();
                  }
                  return HomeProductRatingWidget(
                      id: dataDetail.sId,
                      productImage: dataDetail.images[0].url,
                      productName: dataDetail.name,
                      productModel: dataDetail.category.name,
                      productPrice: price,
                      productOldPrice: dataDetail.price.toDouble(),
                      rating: dataDetail.rating.toDouble(),
                      qty: dataDetail.countInStock,
                      onPressed: () {
                        PageRouting.goToNextPage(context: context, navigateTo: DetailProductScreen(
                          data: dataDetail,
                        ));
                      }, discount: dataDetail.discount,);
                }),
          )

        ],
      ),
    );
  }


  _buildComments(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.black12),
          bottom: BorderSide(width: 1.0, color: Colors.black12),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Comments",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                ),
                Text(
                  "View All",
                  style: TextStyle(fontSize: 18.0, color: Colors.orange),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                StarRating(rating: widget.data.rating.toDouble(), size: 20),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "${widget.data.numberReviews} Reviews",
                  style: TextStyle(color: Colors.black54),
                )
              ],
            ),
            SizedBox(
              child: Divider(
                color: Colors.black26,
                height: 4,
              ),
              height: 24,
            ),


            ListView.builder(
              shrinkWrap: true,
              primary: true,
              itemCount: widget.data.reviews.length,
              itemBuilder: (context, index) {
                var item = widget.data.reviews[index];
                var data, name, rating, image, comment, createAt, avatar;
                data = item;
                name = item.user.name;
                //image = item.product.images[0].url;
                rating = item.rating.toDouble();
                comment = item.comment;
                createAt = item.createdAt;
                avatar = item.user.avatar;


                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        avatar.toString()),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      StarRating(rating: rating as double, size: 15),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                          comment),
                    ],
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${name}",
                        style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      // SizedBox(
                      //   width: 8,
                      // ),
                      // StarRating(rating: rating as double, size: 15),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${createAt}",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                );
              }),

          ],
        ),
      ),
    );
  }

}
