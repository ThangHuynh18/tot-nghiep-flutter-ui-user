import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/OrderModel.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/detail/detail_order_screen.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/widgets/order/my_order_single_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TabBarCancel extends StatefulWidget {
  const TabBarCancel({Key? key}) : super(key: key);

  @override
  _TabBarCancelState createState() => _TabBarCancelState();
}

class _TabBarCancelState extends State<TabBarCancel> {

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
    setState(() {
      loading = true;
      orders = [];
    });
    final response = await http.get(
      Uri.parse("${AppUrl.baseUrl}/api/orders/myorders/CANCEL"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    print("RESPONSE OF MY ORDER: " +response.body+"===-="+response.statusCode.toString());
    if (response.statusCode == 200) {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseGrey10Color,
      body:
      // ListView(
      //   children: [
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            color: AppColors.baseWhiteColor,
            child:
            // Column(
            //   children: [
                loading == true && orders.isEmpty ? const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Center(child: CircularProgressIndicator(color: Colors.orange,)),
                ) :
                orders.isEmpty ? const Padding(
                  padding:  EdgeInsets.only(top: 23.0),
                  child: Center(child: Text("No order", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                ) :
                RefreshIndicator(
                  onRefresh: getMyOrder,
                  child: ListView.builder(
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
                ),
                // SizedBox(
                //   height: 23,
                // ),

            //   ],
            // ),
          ),

      //   ],
      // ),
    );
  }
}
