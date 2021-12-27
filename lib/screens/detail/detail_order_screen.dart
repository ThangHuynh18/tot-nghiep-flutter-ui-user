import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/OrderModel.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/create_review_screen.dart';
import 'package:flutter_t_watch/screens/detail/detail_product_screen.dart';
import 'package:flutter_t_watch/screens/my_order_screen.dart';
import 'package:flutter_t_watch/screens/tabbar/confirm_refund_screen.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/util/default_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_braintree/flutter_braintree.dart';

class DetailOrderScreen extends StatefulWidget {
  final Order data;
  DetailOrderScreen({required this.data});


  @override
  _DetailOrderScreenState createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {

  bool loading = false;
  String phone = "";
  String name = "";
  String token = "";
  String timeOrder = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomerInfo();
    getToken();
    timeOrder = widget.data.createdAt.substring(0, 10);
    //timeOrder = DateFormat('dd-MM-yyyy').format(date)
  }

  void getCustomerInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      phone = pref.getString("phone");
      name = pref.getString("name");
    });
  }

  void getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("login");
    });
  }


  // List<Order> listOrder = [];
  // List<OrderDetailProduct> listDetailProduct = [];
  // List<OrderItems> listOrderItem = [];
  // Future<Null> _fetchData() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   final response = await http.get(
  //       Uri.parse("${AppUrl.baseUrl}/api/orders/${widget.data.sId}"),
  //       headers: {"Accept": "application/json",
  //         'connection': 'keep-alive'});
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode("[${response.body}]");
  //     //print("data : ${data}");
  //
  //     setState(() {
  //       for (Map<String, dynamic> i in data) {
  //         listOrder.add(Order.fromJson(i));
  //       }
  //       var result = listOrder[0];
  //       listOrderItem = result.orderItems;
  //       //listDetailProduct = listOrderItem.
  //       loading = false;
  //     });
  //   }
  // }


  Future<void> createReview(String id, double rating, String comment) async {
    var response = await http.post(Uri.parse("${AppUrl.baseUrl}/api/products/${id}/review"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "rating": rating,
          "comment": comment
        }
        ));
    if(response.statusCode == 200) {
      //final body = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Review Successfully"),));
      //PageRouting.goToNextPage(context: context, navigateTo: DetailProductScreen(data: data));
    }
    else {
      print(response.body.toString()+"stt code======"+response.statusCode.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Review Fail"),));
    }
  }

  Future<void> updateStatus(String stt) async {

    String discount = "";
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/orders/${widget.data.sId}/status?stt=$stt"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },);
    if(response.statusCode == 200) {
      await EasyLoading.dismiss();
      //final body = json.decode(response.body);
      Fluttertoast.showToast(
          msg: "${stt} Order Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      if(stt == "FINISH"){
        print("STATUS:"+stt);
        if(widget.data.totalPrice <= 10000000){
         // discount = "DISCOUNT10";
          discount = "61a99ca018be90000438bdaf";
        } else if (widget.data.totalPrice <= 20000000) {
          // discount = "DISCOUNT20";
          discount = "61b4890c684eaf00043a22d9";
        } else {
          // discount = "DISCOUNT30";
          discount = "61a7514e4b3ced2c6c82997f";
        }
        print("DISCOUNT ID: "+discount);
        await addVoucher(discount);
      }

      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("${stt} Order Successfully"),));
      //PageRouting.goToNextPage(context: context, navigateTo: MyOrderScreen());
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyOrderScreen()), (route) => false);
    }
    else {
      await EasyLoading.dismiss();
      print("BODY FAIL UPDATE STT: "+response.body.toString()+" stt code======"+response.statusCode.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${stt} Order Fail"),));
    }
  }


  Future<void> addVoucher(String discountName) async {
    print("DISCOUNT ID IN ADD VOUCHER: "+discountName);
    var response = await http.post(Uri.parse("${AppUrl.baseUrl}/api/users/voucher/add"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          "id": discountName
          // "name": discountName
        }
        ));
    if(response.statusCode == 201){
      Fluttertoast.showToast(
          msg: "Order Finished. We gave you a voucher in your wallet for the next shopping",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      print("add voucher fail: "+response.body);
    }
  }



  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text("Order Information",
        style: TextStyle(
            fontSize: 18,
            color: AppColors.baseBlackColor,
            fontWeight: FontWeight.bold
        ),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
        backgroundColor: AppColors.baseGrey10Color,
        body: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              color: AppColors.baseWhiteColor,
              //height: 1060,
              child: Column(
                children: [
                  // Expanded(
                  //   child: Container(
                  //     child: Align(
                  //       alignment: Alignment.topCenter,
                  //       child: Image(
                  //         image: AssetImage("./images/virtual/ic_thank_you.png"),
                  //         width: 300,
                  //         height: 100,
                  //       ),
                  //     ),
                  //   ),
                  //   flex: 5,
                  // ),
                  SizedBox(
                    height: 100,
                    width: 200,
                    child: Image.asset(
                        "./images/virtual/ic_thank_you.png"
                    ),
                  ),
                    // Container(
                    // margin: EdgeInsets.only(left: 16, right: 16),
                    // child: Column(
                    // children: <Widget>[
                    //     RichText(
                    //         textAlign: TextAlign.center,
                    //         text: TextSpan(children: [
                    //             TextSpan(
                    //               text:
                    //               "\n\nFor Your Purchase.",
                    //               style: TextStyle(
                    //                 fontSize: 20,
                    //               color: AppColors.baseGrey80Color
                    //               )
                    //             )
                    //     ])),
                    // ]
                    // )
                    // ),
                  Divider(),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: Row(
                            children: [
                              SizedBox(
                                height: 16,
                                width: 16,
                                child: Image.asset(
                                  "./images/virtual/loc.png"
                                ),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text("Delivery Address")
                            ],
                          ),
                    ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: ListTile(
                      title: Text("${widget.data.shippingAddress.address}, ${widget.data.shippingAddress.ward}, ${widget.data.shippingAddress.district}, ${widget.data.shippingAddress.city}",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.baseBlackColor,
                                fontWeight: FontWeight.bold
                            ),),
                      subtitle: Text(name.toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.baseBlackColor,
                          fontWeight: FontWeight.bold
                      ),),
                      trailing: Text(phone,
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColors.baseBlackColor,
                            fontWeight: FontWeight.bold
                        ),),
                    ),
                  ),

                  SizedBox(
                    height: 6,
                  ),

                  // ListTile(
                  //   title: Text(phone,
                  //       style: TextStyle(
                  //           fontSize: 16,
                  //           color: AppColors.baseBlackColor,
                  //           fontWeight: FontWeight.bold
                  //       ),),
                  //
                  // ),

                  // SizedBox(
                  //   height: 6,
                  // ),
                  //   Text(phone,
                  //     style: TextStyle(
                  //         fontSize: 16,
                  //         color: AppColors.baseBlackColor,
                  //         fontWeight: FontWeight.bold
                  //     ),),

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 10,
                    width: double.infinity,
                    color: AppColors.placeholderBg,
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  ListView.builder(
                      shrinkWrap: true,
                      primary: true,
                      itemCount: widget.data.orderItems.length,
                      itemBuilder: (context, index) {
                        var item = widget.data.orderItems[index];
                        var data, name, price, image, qty, id, qtyList;
                        //data = item;
                        name = item.product.name;
                        image = item.product.images[0].url;
                        price = item.price;
                        qty = item.qty;
                        id = item.product.sId;

                        return Card(
                          child: Container(
                            height: 165,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      image),
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
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      name.toString().toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppColors.baseBlackColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              Text(
                                                "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(price)}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.baseBlackColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "Quantity x${qty}",
                                                style: TextStyle(
                                                  fontSize: 16,

                                                  color: AppColors.baseGrey60Color,
                                                ),
                                              ),
                                              widget.data.status == "FINISH" ?
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        show(id, image, name);
                                                        //PageRouting.goToNextPage(context: context, navigateTo: CreateReviewScreen(id: id));
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        children: const [

                                                          SizedBox(width: 20),
                                                          Text("Create Review"),
                                                          SizedBox(width: 20),
                                                        ],
                                                      )),
                                                  SizedBox(height: 15,)
                                                ],
                                              ) : SizedBox(),


                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 6,
                    width: double.infinity,
                    color: AppColors.placeholderBg,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 16),
                    //padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                         "Total Price",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.baseBlackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(widget.data.totalPrice)}",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.baseBlackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment Method",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.baseBlackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${widget.data.paymentMethod}",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.baseBlackColor,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                    ]
                  ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                    Container(
                      height: 6,
                      width: double.infinity,
                      color: AppColors.placeholderBg,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  Padding(
                    padding: EdgeInsets.only(left: 50, right: 16),
                    //padding: EdgeInsets.all(12.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order ID",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.baseBlackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                "${widget.data.sId}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.baseBlackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Time Order",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.baseBlackColor,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${timeOrder}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.baseBlackColor,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ]
                    ),
                  ),


                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 6,
                    width: double.infinity,
                    color: AppColors.placeholderBg,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                SizedBox(
                  child: widget.data.status == "ACCEPT" && widget.data.paymentMethod == "PayPal" ?
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                      child: Row(
                        children: [
                          // DefaultButtonPay(
                          //   text: "Pay",
                          //   press: () async{
                          //     final request = BraintreeDropInRequest(
                          //       tokenizationKey:
                          //       "sandbox_bnmjvh5d_9qzq2sh2s4ndqyfz",
                          //       collectDeviceData: true,
                          //
                          //       paypalRequest: BraintreePayPalRequest(
                          //         amount: "${widget.data.totalPrice.toString()}",
                          //        // amount: "10000",
                          //         displayName: widget.data.user,
                          //       ),
                          //       cardEnabled: true,
                          //     );
                          //     BraintreeDropInResult? result =
                          //         await BraintreeDropIn.start(request);
                          //     if (result != null) {
                          //       print(result
                          //           .paymentMethodNonce.description);
                          //       print(result.paymentMethodNonce.nonce);
                          //       //markAsPaid();
                          //     } else {
                          //       print('Selection was canceled.');
                          //     }
                          //   }
                          // ),
                          // Spacer(),

                          // SizedBox(width: 20,),
                          // DefaultButton(
                          //     text: "Cancel",
                          //     press: () async{
                          //       //await updateStatus("CANCEL");
                          //       showAlertDialog(context);
                          //     }
                          // ),
                          DefaultButtonReceive(
                              text: "Received",
                              press: () async{
                                await updateStatus("RECEIVED");
                              }
                          ),
                          //Spacer(),
                          SizedBox(width: 10,),
                          DefaultButtonCancel(
                              text: "Cancel",
                              press: () async {
                                //await updateStatus("CANCEL");
                                showAlertDialog(context);
                              }
                          ),
                        ],
                      ),
                    )

                    :  widget.data.status == "WAIT" ?
                  DefaultButton(
                        text: "Cancel",
                        press: () async {
                          //await updateStatus("CANCEL");
                          showAlertDialog(context);
                        }
                    ) : widget.data.status == "ACCEPT" ?
                  Row(
                    children: [
                      SizedBox(width: 5,),
                      DefaultButtonReceive(
                          text: "Received",
                          press: () async{
                            await updateStatus("RECEIVED");
                          }
                      ),
                      //Spacer(),
                      SizedBox(width: 20,),
                      DefaultButtonCancel(
                          text: "Cancel",
                          press: () async {
                            //await updateStatus("CANCEL");
                            showAlertDialog(context);
                          }
                      ),
                    ],
                  ) : widget.data.status == "RECEIVED" ?
                  Row(
                    children: [
                      SizedBox(width: 5,),
                      DefaultButtonReceive(
                          text: "Finish",
                          press: () async{
                            await updateStatus("FINISH");
                          }
                      ),
                      //Spacer(),
                      SizedBox(width: 20,),
                      DefaultButtonCancel(
                          text: "Refund",
                          press: () async {
                            //await updateStatus("CANCEL");
                            showAlertDialogRefund(context);
                          }
                      ),
                    ],
                  ) : null
                )

                ],
              )
            )
          ],
        )
    );
  }


  void show(String id, String image, String name) {
    showDialog(
        context: context,
        barrierDismissible: true, // set to false if you want to force a rating
        builder: (context) {
          return RatingDialog(
            image: Image.network(image, width: 80, height: 80,), // set your own image/icon widget
            title: Text("Review for ${name}"),
            message: Text("Tap a star to give your rating. And write your review"),
            submitButtonText: "SUBMIT",
            onSubmitted: (response) async{
              String c = response.comment;
              double r = response.rating;
              print('rating: ${r}, comment: ${c}');
              await createReview(id, r, c);
              // TODO: add your own logic
              if (response.rating < 3.0) {
                // send their comments to your email or anywhere you wish
                // ask the user to contact you instead of leaving a bad review
              } else {
                //_rateAndReviewApp();
              }
            },
          );
        });
  }


  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = Row(
      children: [
        TextButton(
          child: Text("Yes"),
          onPressed: () async{
            await updateStatus("CANCEL");
            //Navigator.pop(context);
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
      title: Text("Cancel Order"),
      content: Text("Are you sure you want to Cancel?"),
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


  showAlertDialogRefund(BuildContext context) {
    // Create button
    Widget okButton = Row(
      children: [
        TextButton(
          child: Text("Yes"),
          onPressed: () {
            Navigator.pop(context);
            PageRouting.goToNextPage(context: context, navigateTo: RefundScreen(data: widget.data));
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
      title: Text("Refund Order"),
      content: Text("Are you sure you want to refund?"),
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



