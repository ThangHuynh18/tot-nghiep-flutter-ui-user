import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/OrderModel.dart';
import 'package:flutter_t_watch/mybottombar/my_bottom_bar.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/detail/detail_order_screen.dart';
import 'package:flutter_t_watch/screens/tabbar/tabbar_accept.dart';
import 'package:flutter_t_watch/screens/tabbar/tabbar_cancel.dart';
import 'package:flutter_t_watch/screens/tabbar/tabbar_finish.dart';
import 'package:flutter_t_watch/screens/tabbar/tabbar_received.dart';
import 'package:flutter_t_watch/screens/tabbar/tabbar_refunded.dart';
import 'package:flutter_t_watch/screens/tabbar/tabbar_refunding.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/util/helper.dart';
import 'package:flutter_t_watch/widgets/order/my_order_single_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({Key? key}) : super(key: key);

  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  //final baseUrl = "https://graduate-flutter-api.herokuapp.com";
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  String token = "";
  List<Order> orders = [];
  List<dynamic> list = [];
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
      getMyOrder();
    });
  }

  Future<Null> getMyOrder() async {
    //keyRefresh.currentState?.show();
    setState(() {
      loading = true;
      orders = [];
    });
    final response = await http.get(
      Uri.parse("${AppUrl.baseUrl}/api/orders/myorders/WAIT"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    //print("RESPONSE OF MY ORDER: " +response.body+"===-="+response.statusCode.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode("${response.body}");
      final json = jsonEncode(data);
      // print("data OF MY ORDER : " + json['orderItems'].toString());

      setState(() {
        list = jsonDecode(response.body);
        print("LENGTH OF MY ORDERS: "+list.length.toString());
        for (Map<String, dynamic> i in list) {
          orders.add(Order.fromJson(i));

        }
        loading = false;

      });
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyBottomBar(selectIndex: 3,)), (route) => false);}),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              getMyOrder();
            });
          },
        ),
      ],
      title: const Text("My Orders",
        style: TextStyle(
            fontSize: 18,
            color: AppColors.baseBlackColor,
            fontWeight: FontWeight.bold
        ),),
      bottom: TabBar(
        labelPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.deepOrangeAccent,
        ),
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.white,
        tabs: [
          Text("Wait"),
          Text("Accept"),
          Text("Received"),
          Text("Cancel"),
          Text("Finish"),
          Text("Refunding"),
          Text("Refunded"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: buildAppBar(),
        backgroundColor: AppColors.baseGrey10Color,
        body: TabBarView(
          children: [
            Container(
             margin: EdgeInsets.only(bottom: 10.0),
             color: AppColors.baseWhiteColor,
             child:
             // Column(
             //   children: [
                 (loading == true)
                     ? Padding(
                   padding: EdgeInsets.only(top: 20),
                   child: const Center(
                       child: CircularProgressIndicator(
                         color: Colors.orange,
                       ),),
                 )
                        : orders.isEmpty
                           ? Padding(
                   padding: const EdgeInsets.only(top: 23.0),
                   child: Center(child: Text("No order", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                 )
                          : RefreshIndicator(
                           //key: keyRefresh,
                           onRefresh: getMyOrder,
                           child: SingleChildScrollView(
                             child: Column(
                               children: [
                                 const SizedBox(height: 20,),
                                 ListView.builder(
                                   physics: NeverScrollableScrollPhysics(),
                                    // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                   shrinkWrap: true,
                                   primary: true,
                                   itemCount: orders.length,
                                   itemBuilder: (context, index) {
                                     var item = orders[index];
                                     var address, name, ward, image, district, id, city, totalProduct, totalPrice, status, data;
                                     image = item.orderItems[0].product.images[0].url;
                                     id = item.sId;
                                     name = item.orderItems[0].product.name;
                                     address = item.shippingAddress.address;
                                     ward = item.shippingAddress.ward;
                                     district = item.shippingAddress.district;
                                     city = item.shippingAddress.city;
                                     totalProduct = item.orderItems.length;
                                     totalPrice = item.totalPrice.toDouble();
                                     status = item.status;
                                     data = item;
                                     // data = item;
                                     // name = item.product.name;
                                     // image = item.product.images[0].url;
                                     // price = item.product.price;
                                     // qty = item.qty;
                                     // id = item.product.sId;

                                     return MyOrderSingleWidget(id: id,
                                                         productImage: image,
                                                         productName: name,
                                                         address: address, ward: ward, district: district, city: city,
                                                         totalPrice: totalPrice, totalProduct: totalProduct,
                                                         status: status,
                                                         onPressed: (){
                                                           PageRouting.goToNextPage(context: context, navigateTo: DetailOrderScreen(data: data));
                                                         });

                                   }
                                 ),
                               ],
                             ),
                           ),
                         ),
                 // Container(
                 //   height: 10,
                 //   width: double.infinity,
                 //   color: AppColors.placeholderBg,
                 // ),
                         // Column(
                         //   crossAxisAlignment: CrossAxisAlignment.start,
                         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         //   mainAxisSize: MainAxisSize.max,
                         //   children: [
                         //     Text(
                         //       "King Burgers",
                         //       style: TextStyle(
                         //           fontSize: 18,
                         //           color: AppColors.baseBlackColor,
                         //           fontWeight: FontWeight.bold
                         //       ),
                         //     ),
                         //     Row(
                         //       children: [
                         //         Text("Burger"),
                         //         Padding(
                         //           padding: const EdgeInsets.only(
                         //             bottom: 5,
                         //           ),
                         //           child: Text(
                         //             ".",
                         //             style: TextStyle(
                         //               color: AppColors.orange,
                         //               fontWeight: FontWeight.bold,
                         //             ),
                         //           ),
                         //         ),
                         //         Text("Western Food"),
                         //       ],
                         //     ),
                         //     Row(
                         //       children: [
                         //         SizedBox(
                         //           height: 15,
                         //           child: Image.asset(
                         //             "./images/virtual/loc.png"
                         //           ),
                         //         ),
                         //         SizedBox(
                         //           width: 5,
                         //         ),
                         //         Text("No 03, 4th Lane, Newyork")
                         //       ],
                         //     )
                         //   ],
                         // )

                 // SizedBox(
                 //   height: 23,
                 // ),
                 // Container(
                 //   width: double.infinity,
                 //   color: AppColors.placeholderBg,
                 //   child: Padding(
                 //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                 //     child: Column(
                 //       children: [
                 //         BurgerCard(
                 //           price: "16",
                 //           name: "Beef Burger",
                 //         ),
                 //         BurgerCard(
                 //           price: "14",
                 //           name: "Classic Burger",
                 //         ),
                 //         BurgerCard(
                 //           price: "17",
                 //           name: "Cheese Chicken Burger",
                 //         ),
                 //         BurgerCard(
                 //           price: "15",
                 //           name: "Chicken Legs Basket",
                 //         ),
                 //         BurgerCard(
                 //           price: "6",
                 //           name: "French Fries Large",
                 //           isLast: true,
                 //         ),
                 //       ],
                 //     ),
                 //   ),
                 // ),
                 // Padding(
                 //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                 //   child: Column(
                 //     children: [
                 //       Container(
                 //         height: 50,
                 //         decoration: BoxDecoration(
                 //           border: Border(
                 //             bottom: BorderSide(
                 //               color: AppColors.placeholder.withOpacity(0.25),
                 //             ),
                 //           ),
                 //         ),
                 //         child: Row(
                 //           children: [
                 //             Expanded(
                 //               child: Text(
                 //                 "Delivery Instruction",
                 //                 style: TextStyle(
                 //                     fontSize: 15,
                 //                     color: AppColors.baseBlackColor,
                 //                     fontWeight: FontWeight.bold
                 //                 ),
                 //               ),
                 //             ),
                 //             TextButton(
                 //                 onPressed: () {},
                 //                 child: Row(
                 //                   children: [
                 //                     Icon(
                 //                       Icons.add,
                 //                       color: AppColors.orange,
                 //                     ),
                 //                     Text(
                 //                       "Add Notes",
                 //                       style: TextStyle(
                 //                         color: AppColors.orange,
                 //                       ),
                 //                     )
                 //                   ],
                 //                 ))
                 //           ],
                 //         ),
                 //       ),
                 //       SizedBox(
                 //         height: 15,
                 //       ),
                 //       Row(
                 //         children: [
                 //           Expanded(
                 //             child: Text(
                 //               "Sub Total",
                 //               style: TextStyle(
                 //                   fontSize: 15,
                 //                   color: AppColors.baseBlackColor,
                 //                   fontWeight: FontWeight.bold
                 //               ),
                 //             ),
                 //           ),
                 //           Text(
                 //             "\$68",
                 //             style: TextStyle(
                 //                 fontSize: 15,
                 //                 color: AppColors.baseBlackColor,
                 //                 fontWeight: FontWeight.bold
                 //             )
                 //           )
                 //         ],
                 //       ),
                 //       SizedBox(
                 //         height: 10,
                 //       ),
                 //       Row(
                 //         children: [
                 //           Expanded(
                 //             child: Text(
                 //               "Delivery Cost",
                 //               style: TextStyle(
                 //                   fontSize: 15,
                 //                   color: AppColors.baseBlackColor,
                 //                   fontWeight: FontWeight.bold
                 //               ),
                 //             ),
                 //           ),
                 //           Text(
                 //             "\$2",
                 //             style: TextStyle(
                 //                 fontSize: 15,
                 //                 color: AppColors.baseBlackColor,
                 //                 fontWeight: FontWeight.bold
                 //             )
                 //           )
                 //         ],
                 //       ),
                 //       SizedBox(
                 //         height: 10,
                 //       ),
                 //       Divider(
                 //         color: AppColors.placeholder.withOpacity(0.25),
                 //         thickness: 1.5,
                 //       ),
                 //       SizedBox(
                 //         height: 10,
                 //       ),
                 //       Row(
                 //         children: [
                 //           Expanded(
                 //             child: Text(
                 //               "Total",
                 //               style: TextStyle(
                 //                   fontSize: 15,
                 //                   color: AppColors.baseBlackColor,
                 //                   fontWeight: FontWeight.bold
                 //               ),
                 //             ),
                 //           ),
                 //           Text(
                 //             "\$70",
                 //             style: TextStyle(
                 //                 fontSize: 20,
                 //                 color: AppColors.orange,
                 //                 fontWeight: FontWeight.bold
                 //             )
                 //           )
                 //         ],
                 //       ),
                 //       SizedBox(height: 20),
                 //       SizedBox(
                 //         height: 50,
                 //         width: double.infinity,
                 //         child: ElevatedButton(
                 //           onPressed: () {
                 //
                 //           },
                 //           child: Text("Checkout"),
                 //         ),
                 //       ),
                 //     ],
                 //   ),
                 // )
               // ],
             // ),
              ),
            TabBarAccept(),
            TabBarReceived(),
            TabBarCancel(),
            TabBarFinish(),
            TabBarRefunding(),
            TabBarRefunded()
          ]
        ),
      ),
    );
  }
}
