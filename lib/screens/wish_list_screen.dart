import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/UserModel.dart';
import 'package:flutter_t_watch/models/WishItemModel.dart';
import 'package:flutter_t_watch/styles/detail_screen_stylies.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/widgets/slidable_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {

  String token = "";
  List<WishItem> items = [];
  List<Data> listItem = [];
  bool loading = false;

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
      getList();
    });
  }

  Future<Null> getList() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(
      Uri.parse("${AppUrl.baseUrl}/api/wishlist"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    print("RESPONSE: " +response.body+"===-="+response.statusCode.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode("[${response.body}]");
      print("data : ${data}");

      setState(() {
        for (Map<String, dynamic> i in data) {
          items.add(WishItem.fromJson(i));

        }

        var result = items[0];
        listItem = result.data;
        loading = false;

      });
    }
  }


  Future<void> removeItem(String id, int index) async {
    print("++++++++++++++++++++++++ID OF PRODUCT:::"+id);
    var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/wishlist/remove-item-wishlist/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    print("STATUS CODE IS: "+response.statusCode.toString()+" AND BODY IS:::: "+response.body);
    if(response.statusCode == 200){
      Fluttertoast.showToast(
          msg: "Removed Product from Wishlist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Removed Product from Wishlist"),));

      setState(() {
        listItem.removeAt(index);
        getList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Remove Product Fail"),));
    }
  }


  Future<void> removeAllItem() async {
    //print("TOKEN FOR API IS HERE---------------"+token+"AND ID OF PRODUCT:::"+widget.id);
    var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/wishlist/remove-all-item-wishlist/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Removed All Product from Wishlist"),));

      setState(() {
        listItem.removeRange(0, listItem.length);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Remove All Product Fail"),));
    }
  }


  Future<void> addToCart(String id) async {
    var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/cart/add-to-cart/${id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      EasyLoading.showSuccess('Added Product to Cart');

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Add Product to Cart Fail"),));
    }
  }


  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.deepOrangeAccent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Wishlist",
        style: TextStyle(
          color: AppColors.baseWhiteColor
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10.0, top: 2.0),
          child:
          IconButton(onPressed: (){
            //removeAllItem();
            showAlertDialogAll(context);
          },
            icon: Icon(Icons.delete, color: Colors.white,),

          )
        )
      ],
    );
  }


  String? myController;

  Widget buildSingleBag() {
    return Card(
      child: Container(
        height: 140,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://vcdn1-giaitri.vnecdn.net/2020/11/03/lisa-3-1604394414.jpg?w=1200&h=0&q=100&dpr=1&fit=crop&s=Uzqm3erCQJd3bC_65SfkrQ"),
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "3 stripes shirt",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.baseBlackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "adidas originals",
                            style: TextStyle(
                              color: AppColors.baseDarkPinkColor,
                            ),
                          ),
                          Text(
                            "\$40.00",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.baseBlackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$80.00",
                            style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.baseGrey50Color,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: AppColors.baseGrey30Color,
                        child: Icon(
                          Icons.check,
                          color: AppColors.baseWhiteColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: Container(
      //   height: 100,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Expanded(
      //         child: Container(
      //           height: 55,
      //           margin: EdgeInsets.all(10.0),
      //           child: ElevatedButton.icon(
      //             style: ElevatedButton.styleFrom(
      //               shape: BeveledRectangleBorder(
      //                 borderRadius: BorderRadius.circular(5)
      //               ),
      //               primary: AppColors.baseGrey80Color,
      //               onSurface: Colors.grey
      //             ),
      //             icon: SvgPicture.asset(SvgImages.delete,
      //             color: AppColors.baseWhiteColor,
      //             width: 30,),
      //             label: Text("Remove",
      //             style:
      //             TextStyle(
      //               fontSize: 25,
      //               color: AppColors.baseWhiteColor
      //             ),),
      //             onLongPress: () {}, onPressed: () async { await removeAllItem(); },
      //           ),
      //         ),
      //       ),
      //
      //       Expanded(
      //         child: Container(
      //           height: 55,
      //           margin: EdgeInsets.all(10.0),
      //           child: ElevatedButton.icon(
      //             style: ElevatedButton.styleFrom(
      //                 shape: BeveledRectangleBorder(
      //                     borderRadius: BorderRadius.circular(5)
      //                 ),
      //                 primary: AppColors.baseLightOrangeColor,
      //                 onSurface: Colors.grey
      //             ),
      //             icon: SvgPicture.asset(SvgImages.shoppingCart,
      //               color: AppColors.baseWhiteColor,
      //               width: 30,),
      //             label: Text("Buy Now",
      //               style: TextStyle(
      //                   fontSize: 25,
      //                   color: AppColors.baseWhiteColor
      //               ),),
      //             onLongPress: () {}, onPressed: () {  },
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      appBar: buildAppBar(),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Swipe the item to left to remove item from wishlist",
                  style: TextStyle(
                    color: AppColors.baseGrey60Color,
                  ),),
                const SizedBox(height: 3,),
                const Text("Click the trash button to remove all item from wishlist",
                  style: TextStyle(
                    color: AppColors.baseGrey60Color,
                  ),),
                const SizedBox(height: 3,),

                loading == true && listItem.isEmpty ? Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent,),) :
                listItem.isEmpty
                    ? const Center(child: Text('Your Wishlist is Empty'))
                    :
                        ListView.separated(
                            separatorBuilder: (context, index) => Divider(),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: true,
                        itemCount: listItem.length,
                        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        // crossAxisCount: 2,
                        // childAspectRatio: 0.7
                        // ),
                        itemBuilder: (context, index) {
                          var item = listItem[index];
                          var productImage, productName, productModel,
                              productPrice, qty, id, data;

                            productImage = item.product.images[0].url;
                            productName = item.product.name;
                            productPrice = item.product.price;
                            qty = item.product.countInStock;

                            id = item.product.sId;
                            // data = item;



                          return SlidableWidget(
                            onDismissed: (action) =>
                                dismissSlidableItem(context, index, action, id),
                            child: Card(
                              child: Container(
                                height: 155,
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    image: DecorationImage(
                                                      image: NetworkImage(productImage),
                                                    )),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0, vertical: 20.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                    "${productName.toString().toUpperCase()}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: AppColors.baseBlackColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),

                                                  Text(
                                                    "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(productPrice)}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: AppColors.baseBlackColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  qty > 0 ? Text(
                                                    "In stock",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: AppColors.baseBlackColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                      : Text(
                                                    "Out of stock",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.all(10.0),
                                              child: IconButton(onPressed: (){
                                                addToCart(id);
                                              },
                                                icon: Icon(LineIcons.shoppingCart),

                                              )
                                              // CircleAvatar(
                                              //   radius: 25,
                                              //   backgroundColor: AppColors.baseGrey30Color,
                                              //   child: Icon(
                                              //     Icons.check,
                                              //     color: AppColors.baseWhiteColor,
                                              //   ),
                                              // ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    // IconButton(onPressed: () async {
                                    //   await removeItem(id);
                                    // },
                                    //     icon: SvgPicture.asset(
                                    //       SvgImages.delete,
                                    //       color: AppColors.baseBlackColor,
                                    //       width: 40,
                                    //     )),

                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        ),



                // buildSingleBag(),
                // buildSingleBag(),
                // buildSingleBag(),
                // buildSingleBag(),
                // buildSingleBag(),
              ],
            ),
          )
        ],
      ),
    );
  }


  void dismissSlidableItem(BuildContext context, int index, SlidableAction action, String id) {
    switch (action) {
      case SlidableAction.delete:
        showAlertDialog(context, id, index);
        break;
    }
  }


  showAlertDialog(BuildContext context, String id, int index) {
    // Create button
    Widget okButton = Row(
      children: [
        TextButton(
          child: Text("Yes"),
          onPressed: () async{
            await removeItem(id, index);
            print("id: "+id);
           // Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("No"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove Item"),
      content: Text("Are you sure you want to remove this product?"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogAll(BuildContext context) {
    // Create button
    Widget okButton = Row(
      children: [
        TextButton(
          child: Text("Yes"),
          onPressed: () async{
            await removeAllItem();
           // Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text("No"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove"),
      content: Text("Are you sure you want to remove all product?"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}





