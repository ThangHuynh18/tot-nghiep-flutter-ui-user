
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/CartItemModel.dart';
import 'package:flutter_t_watch/models/UserModel.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/confirmation_success_screen.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/util/default_button.dart';
import 'package:flutter_t_watch/util/helper.dart';
import 'package:flutter_t_watch/widgets/custom_text_input.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum PaymentMethod { Cod, Visa, PayPal }

class ConfirmationScreen extends StatefulWidget {
  late List<Data> cartList = [];
  late double total;
  late String voucherId;
  ConfirmationScreen({required this.cartList, required this.total, required this.voucherId});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {

  String userEmail = "";
  String userName = "";
  String address = "";
  String district = "";
  String ward = "";
  String city = "";
  late int qty;
  late String name;
  late String image;
  late String productId;
  late int itemPrice;
  String token = "";
  late Object data;
  late OrderItem finalItem = OrderItem();
  List<Object> orderItems = [];
  late String jsonOrderItem;
  List<OrderItem> list = [];

  late Data item;
  late double shippingPrice, totalPrice;

  TextEditingController addressController = TextEditingController();
  TextEditingController wardController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  // PaymentMethod _character = PaymentMethod.Cod;
  String _character = 'Cod';
  bool isPaid = false;
  String pay = "no";
  int priceItem = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.total < 5000000){
      shippingPrice = 30000;
    } else {
      shippingPrice = 0;
    }
    totalPrice = widget.total + shippingPrice;
    getAddress();
    getToken();
    print("payment method first: "+_character);
  }


  void getAddress() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      address = pref.getString("address");
      ward = pref.getString("ward");
      district = pref.getString("district");
      city = pref.getString("city");

      // ShippingAddress model = ShippingAddress();
      // shippingAddress = model.toJson() as String;
      //print("SHIPPING: "+shippingAddress['address']);
      // widget.cartList.map((e) => {
      //   data = {
      //     qty = e.qty,
      //     name = e.product.name,
      //     image = e.product.images[0].url,
      //     itemPrice = e.product.price,
      //     productId = e.product.sId
      //   }
      //
      // });
      for(var i=0; i < widget.cartList.length; i++){
        item = widget.cartList[i];

        if(item.product.discount >0){
          priceItem = (item.product.price * (100 - item.product.discount) * 0.01).toInt();
          //priceDiscount = item.product.price * item.product.discount * 0.01;
        } else {
          priceItem = item.product.price;
          //priceDiscount = 0;
        }

          data = {
          "qty":  widget.cartList[i].qty,
          // "name": "${widget.cartList[i].product.name}",
          // "image": "${widget.cartList[i].product.images[0].url}",
          "price": priceItem,
          "product": "${widget.cartList[i].product.sId}"
         };
        orderItems.add(data);
        print("ITEM: "+data.toString());
      }
      //return OrderItem(qty: widget.cartList[i].qty, name: "${widget.cartList[i].product.name}", image: "${widget.cartList[i].product.images[0].url}", productId: ${widget.cartList[i].product.sId}, itemPrice: widget.cartList[i].product.price);

      jsonOrderItem = jsonEncode(orderItems);
      print("JSON DECODE: "+jsonDecode(jsonOrderItem).toString());
      for (Map<String, dynamic> i in jsonDecode(jsonOrderItem)) {
        list.add(OrderItem.fromJson(i));
        print("ITEM OF JSON DECODE: "+i.toString());

      }
       //finalItem = OrderItem.fromJson(jsonDecode(jsonOrderItem));

      print("ORDER ITEMS: "+jsonOrderItem.toString()+"   LENGTH: "+orderItems.length.toString());
      //print("FINAL ITEMS: "+list.toString() +"PRICE: "+list[0].price.toString() +"PRICE LAST: "+list[1].price.toString());
      // if(widget.total < 5000000){
      //   shippingPrice = 30000;
      // } else {
      //   shippingPrice = 0;
      // }
      // totalPrice = widget.total + shippingPrice;

    });
  }

  Future<void> updateAddress() async {
    setState(() {
      address = addressController.text;
      ward = wardController.text;
      district = districtController.text;
      city = cityController.text;
    });
    print("======ADDRESS UPDATED: $address, $ward, $district, $city ========");
  }

  void getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("login");
      userName = pref.getString("name");
      userEmail = pref.getString("email");
    });
  }

  Future<void> createOrder() async {
    //String discount = "";
    await EasyLoading.show(
      status: 'Processing...',
      maskType: EasyLoadingMaskType.black,
    );
    //print("TOKEN FOR API IS HERE---------------"+token+"AND ID OF PRODUCT:::"+id);
    print("============== PAYMENT METHOD: $_character ============");
    var response = await http.post(Uri.parse("${AppUrl.baseUrl}/api/orders"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "orderItems": list,
          "shippingAddress":  {
            "address": address,
            "city": city,
            "district": district,
            "ward": ward
          },
          "paymentMethod": _character,
          "itemsPrice": widget.total,
          "shippingPrice": shippingPrice,
          "totalPrice": totalPrice
        }
        ));

    if(response.statusCode == 201){
      final body = json.decode(response.body);
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order Successfully"),));
      var res = await http.put(Uri.parse("${AppUrl.baseUrl}/api/cart/remove-all-item-cart/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );

      if(res.statusCode == 200){
        await EasyLoading.dismiss();
        await sendEmail(name: userName, email: userEmail, idOrderEmail: body['data']['_id'].toString(), priceEmail: totalPrice.toString());
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ConfirmationSuccessScreen()), (Route<dynamic> route) => false);


      } else {
        await EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Remove All Product Fail"),));
      }

      // if(totalPrice.toInt() <= 10000000){
      //   discount = "DISCOUNT10";
      // } else if (totalPrice.toInt() <= 20000000) {
      //   discount = "DISCOUNT20";
      // } else {
      //   discount = "DISCOUNT30";
      // }
      await removeVoucher();
      // await addVoucher(discount);



      // Fluttertoast.showToast(
      //     msg: "Order Successfully",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0
      // );



    } else {
      await EasyLoading.dismiss();
      print("errr: "+response.statusCode.toString()+ " , ERROR: "+response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order Failed"),));
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: const Text("Check out",
        style: TextStyle(
            fontSize: 18,
            color: AppColors.baseBlackColor,
            fontWeight: FontWeight.bold
        ),),
    );
  }


  String formatPrice(double price){
    price = price / 23000;
    return price.toStringAsFixed(2);
  }


  Future sendEmail({required String name, required String email, required String idOrderEmail, required String priceEmail}) async {
    var serviceId = "service_dfjvs2u";
    var templateId = "template_hvpljef";
    var userEmailId = "user_5XkYwjcUPdfdSnQzF9hhl";

    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

    final response = await http.post(url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userEmailId,
          'template_params': {
              'user_name': name,
              'user_email': email,
              'to_email': email,
              'user_subject': "Order successfully from T Watch",
              'user_message': "Thank you for your order. Your order id is ${idOrderEmail} with price: ${priceEmail}. And we have also added to your wallet a voucher for your next order."
          }
      })
    );
    print("stt code: "+response.statusCode.toString());
    print("body res: "+response.body);
    if(response.statusCode == 200){
      Fluttertoast.showToast(
          msg: "Order Successfully. We sent a email to you",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sent email"),));
    } else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Send Failed"),));
    }
  }


  // Future<void> addVoucher(String discountName) async {
  //     var response = await http.post(Uri.parse("${AppUrl.baseUrl}/api/users/voucher/add"),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //           'Authorization': 'Bearer $token'
  //         },
  //         body: jsonEncode(<String, String>{
  //           "name": discountName
  //         }
  //         ));
  // }


  Future<void> removeVoucher() async {
    var response = await http.delete(Uri.parse("${AppUrl.baseUrl}/api/users/voucher/${widget.voucherId}/remove"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },);

  }


  Widget buildConfirmationProduct() {
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
                    flex: 1,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                "\$ 40",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.baseBlackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "adidas originals",
                                style: TextStyle(
                                  color: AppColors.baseDarkPinkColor,
                                ),
                              ),
                              Text(
                                "\$ 70",
                                style: TextStyle(
                                  color: AppColors.baseBlackColor,
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough
                                ),
                              ),
                            ],
                          ),

                          Text(
                            "Quantity x2",
                            style: TextStyle(
                              fontSize: 16,

                              color: AppColors.baseGrey60Color,
                            ),
                          )
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

  Widget buildBottomPart(BuildContext context) {
    return Column(
      children: [
        // ListTile(
        //   tileColor: AppColors.baseGrey10Color,
        //   title: Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: const [
        //         Text(
        //           "Total price",
        //           style: TextStyle(
        //               fontSize: 18,
        //               color: AppColors.baseBlackColor,
        //               fontWeight: FontWeight.bold
        //           ),
        //         ),
        //         SizedBox(height: 5,),
        //         // Text(
        //         //   "Your total amount of discount",
        //         //   style: TextStyle(
        //         //     fontSize: 12,
        //         //     color: AppColors.baseBlackColor,
        //         //   ),
        //         // ),
        //       ],
        //     ),
        //   ),
        //   trailing: Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.end,
        //       children: [
        //         Text(
        //           "${widget.total}",
        //           style: TextStyle(
        //               fontSize: 14,
        //               color: AppColors.baseBlackColor,
        //               fontWeight: FontWeight.bold
        //           ),
        //         ),
        //         SizedBox(height: 2,),
        //         // Text(
        //         //   "\$-23.05",
        //         //   style: TextStyle(
        //         //     fontSize: 12,
        //         //     color: AppColors.baseBlackColor,
        //         //   ),
        //         // ),
        //       ],
        //     ),
        //   ),
        // ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sub Total"),
                  Text(
                    "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(widget.total)}",
                    style: TextStyle(
                        fontSize: 15,
                        color: AppColors.baseBlackColor,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Delivery Cost"),
                  Text(
                    "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(shippingPrice)}",
                    style: TextStyle(
                        fontSize: 15,
                        color: AppColors.baseBlackColor,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text("Discount"),
              //     Text(
              //       "-\$4",
              //       style: Helper.getTheme(context).headline3,
              //     )
              //   ],
              // ),
              Divider(
                height: 40,
                color: AppColors.placeholder.withOpacity(0.25),
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total"),
                  Text(
                    "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(totalPrice)}",
                    style: TextStyle(
                        fontSize: 15,
                        color: AppColors.baseBlackColor,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),

        Container(
          color: AppColors.baseGrey10Color,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 23),
          child: isPaid == true && _character == "Cod"  ? MaterialButton(
            color: Colors.black,
            height: 45,
            elevation: 0,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            onPressed:() async{
              await createOrder();
             // await sendEmail(name: userName, email: userEmail, idOrderEmail: "653463fsnadbfb", priceEmail: "1234455");

              // PageRouting.goToNextPage(context: context, navigateTo: ConfirmationSuccessScreen());
            },
            child: Text(
              "Place Order",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          )
          : isPaid == false && _character == "PayPal" ? DefaultButtonPay(
              text: "Pay",
              press: () async{

                print("total price in paypal: "+"${totalPrice.toString()}");
                final request = BraintreeDropInRequest(
                  tokenizationKey:
                  "sandbox_bnmjvh5d_9qzq2sh2s4ndqyfz",
                  collectDeviceData: true,

                  paypalRequest: BraintreePayPalRequest(
                    amount: formatPrice(totalPrice),
                    //amount: "10000.0",
                    displayName: userName,
                  ),
                  cardEnabled: true,
                );
                BraintreeDropInResult? result =
                await BraintreeDropIn.start(request);
                if (result != null) {
                  print(result
                      .paymentMethodNonce.description);
                  print(result.paymentMethodNonce.nonce);
                  setState(() {
                    isPaid = true;
                    pay = "yes";
                  });
                  EasyLoading.showSuccess('Pay successfully');
                  // Fluttertoast.showToast(
                  //     msg: "Pay successfully",
                  //     toastLength: Toast.LENGTH_SHORT,
                  //     gravity: ToastGravity.CENTER,
                  //     timeInSecForIosWeb: 1,
                  //     backgroundColor: Colors.red,
                  //     textColor: Colors.white,
                  //     fontSize: 16.0
                  // );
                  //markAsPaid();
                } else {
                  print('Selection was canceled.');
                }
              }
          ) : MaterialButton(
            color: Colors.black,
            height: 45,
            elevation: 0,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
            onPressed:() async{
              await createOrder();
              //await sendEmail(name: userName, email: userEmail, idOrderEmail: "653463fsnadbfb", priceEmail: "1234455");
              // PageRouting.goToNextPage(context: context, navigateTo: ConfirmationSuccessScreen());
            },
            child: Text(
              "Place Order",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: AppColors.baseGrey10Color,
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            color: AppColors.baseWhiteColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 5.0),
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
                      Text("Delivery Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                //  ListTile(
                //   title: Text("Delivery Address",
                //   style: TextStyle(
                //     fontSize: 18,
                //     color: AppColors.baseBlackColor,
                //     fontWeight: FontWeight.bold
                //   ),),
                //   leading: SizedBox(
                //     height: 16,
                //     width: 16,
                //     child: Image.asset(
                //         "./images/virtual/loc.png"
                //     ),
                //   ),
                //   // subtitle: Text("order number #44124131"),
                // ),


                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Text("Delivery Address"),
                // ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 285,
                        child: Text(
                          "$address, $ward, $district, $city",
                          style: TextStyle(
                                fontSize: 15,
                                color: AppColors.baseBlackColor,
                                fontWeight: FontWeight.bold
                              ),),
                      ),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              isScrollControlled: true,
                              isDismissible: false,
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: Helper.getScreenHeight(context) * 0.7,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(
                                              Icons.clear,
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Change shipping address",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: AppColors.baseBlackColor,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Divider(
                                          color: AppColors.placeholder
                                              .withOpacity(0.5),
                                          thickness: 1.5,
                                          height: 40,
                                        ),
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),
                                       Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: CustomTextInputAddress(
                                            hintText: "address number, name street", controller: addressController,),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                       Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: CustomTextInputAddress(
                                            hintText: "ward", controller: wardController,),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                       Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: CustomTextInputAddress(
                                            hintText: "district", controller: districtController,),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                       Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: CustomTextInputAddress(
                                            hintText: "city", controller: cityController,),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                              onPressed: () async{
                                                await updateAddress();
                                                Navigator.of(context).pop();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: const [

                                                  SizedBox(width: 40),
                                                  Text("Update"),
                                                  SizedBox(width: 40),
                                                ],
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        child: Text(
                          "Change",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


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


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Payment method"),
                      // TextButton(
                      //   onPressed: () {
                      //     showModalBottomSheet(
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //         isScrollControlled: true,
                      //         isDismissible: false,
                      //         context: context,
                      //         builder: (context) {
                      //           return Container(
                      //             height: Helper.getScreenHeight(context) * 0.7,
                      //             child: Column(
                      //               children: [
                      //                 Row(
                      //                   mainAxisAlignment:
                      //                   MainAxisAlignment.end,
                      //                   children: [
                      //                     IconButton(
                      //                       onPressed: () {
                      //                         Navigator.of(context).pop();
                      //                       },
                      //                       icon: Icon(
                      //                         Icons.clear,
                      //                       ),
                      //                     )
                      //                   ],
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 20.0),
                      //                   child: Row(
                      //                     children: [
                      //                       Text(
                      //                         "Add Credit/Debit Card",
                      //                         style: Helper.getTheme(context)
                      //                             .headline3,
                      //                       )
                      //                     ],
                      //                   ),
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 20.0),
                      //                   child: Divider(
                      //                     color: AppColors.placeholder
                      //                         .withOpacity(0.5),
                      //                     thickness: 1.5,
                      //                     height: 40,
                      //                   ),
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 20.0),
                      //                   child: CustomTextInput(
                      //                       hintText: "card Number"),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 20,
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 20.0),
                      //                   child: Row(
                      //                     mainAxisAlignment:
                      //                     MainAxisAlignment.spaceBetween,
                      //                     children: [
                      //                       Text("Expiry"),
                      //                       SizedBox(
                      //                         height: 50,
                      //                         width: 100,
                      //                         child: CustomTextInput(
                      //                           hintText: "MM",
                      //                           padding: const EdgeInsets.only(
                      //                               left: 35),
                      //                         ),
                      //                       ),
                      //                       SizedBox(
                      //                         height: 50,
                      //                         width: 100,
                      //                         child: CustomTextInput(
                      //                           hintText: "YY",
                      //                         ),
                      //                       )
                      //                     ],
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 20,
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 20.0),
                      //                   child: CustomTextInput(
                      //                       hintText: "Security Code"),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 20,
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 20.0),
                      //                   child: CustomTextInput(
                      //                       hintText: "First Name"),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 20,
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 20.0),
                      //                   child: CustomTextInput(
                      //                       hintText: "Last Name"),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 20,
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 20.0),
                      //                   child: Row(
                      //                     mainAxisAlignment:
                      //                     MainAxisAlignment.spaceBetween,
                      //                     children: [
                      //                       SizedBox(
                      //                         width: Helper.getScreenWidth(
                      //                             context) *
                      //                             0.4,
                      //                         child: Text(
                      //                             "You can remove this card at anytime"),
                      //                       ),
                      //                       Switch(
                      //                         value: false,
                      //                         onChanged: (_) {},
                      //                         thumbColor:
                      //                         MaterialStateProperty.all(
                      //                           AppColors.secondary,
                      //                         ),
                      //                       )
                      //                     ],
                      //                   ),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 30,
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 20.0),
                      //                   child: SizedBox(
                      //                     height: 50,
                      //                     child: ElevatedButton(
                      //                         onPressed: () {
                      //                           Navigator.of(context).pop();
                      //                         },
                      //                         child: Row(
                      //                           mainAxisAlignment:
                      //                           MainAxisAlignment.center,
                      //                           children: [
                      //                             Icon(
                      //                               Icons.add,
                      //                             ),
                      //                             SizedBox(width: 40),
                      //                             Text("Add Card"),
                      //                             SizedBox(width: 40),
                      //                           ],
                      //                         )),
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //           );
                      //         });
                      //   },
                      //   child: Row(
                      //     children: [
                      //       Icon(Icons.add),
                      //       Text(
                      //         "Add Card",
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                // PaymentCard(
                //   widget: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text("Cash on delivery"),
                //
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // PaymentCard(
                //   widget: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Row(
                //         children: [
                //           SizedBox(
                //             width: 40,
                //             child: Image.network(
                //               "https://augmentit.ch/wp-content/uploads/2019/06/58482363cef1014c0b5e49c1.png",
                //               width: 125,
                //               height: 50,
                //               ),
                //             ),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           Text("**** **** **** 2187"),
                //
                //
                //
                //         ],
                //       ),
                //
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // PaymentCard(
                //   widget: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Row(
                //         children: [
                //           SizedBox(
                //             width: 40,
                //             height: 30,
                //             child: Image.network(
                //               "https://quangan.vn/wp-content/uploads/paypal.jpg",
                //               // width: 150,
                //               // height: 150,
                //             ),
                //           ),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           Text("thanghuynh@gmail.com"),
                //         ],
                //       ),
                //
                //     ],
                //   ),
                // ),


                SizedBox(
                  height: 10,
                ),

                Column(
                  children: <Widget>[
                    ListTile(
                      title: Row(
                        children: [
                          const Text('Cash on delivery'),

                        ],
                      ),
                      leading: Radio(
                        value: 'Cod',
                        groupValue: _character,
                        onChanged: (String? value) {
                          setState(() {
                            _character = value!;
                            isPaid = true;
                            pay = "yes";
                          });
                        },
                      ),
                    ),
                    // ListTile(
                    //   title: Row(
                    //     children: [
                    //       const Text(''),
                    //       SizedBox(
                    //         width: 40,
                    //         child: Image.network(
                    //           "https://augmentit.ch/wp-content/uploads/2019/06/58482363cef1014c0b5e49c1.png",
                    //           width: 125,
                    //           height: 50,
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text("**** **** **** 2187"),
                    //     ],
                    //   ),
                    //   leading: Radio(
                    //     value: 'Visa',
                    //     groupValue: _character,
                    //     onChanged: (String? value) {
                    //       setState(() {
                    //         _character = value!;
                    //       });
                    //     },
                    //   ),
                    // ),
                    ListTile(
                      title: Row(
                        children: [
                          const Text(''),
                          SizedBox(
                            width: 40,
                            height: 30,
                            child: Image.network(
                              "https://quangan.vn/wp-content/uploads/paypal.jpg",
                              // width: 150,
                              // height: 150,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          //Text("thanghuynh@gmail.com"),
                        ],
                      ),
                      leading: Radio(
                        value: 'PayPal',
                        groupValue: _character,
                        onChanged: (String? value) {
                          setState(() {
                            _character = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),



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
                  physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                itemCount: widget.cartList.length,
                itemBuilder: (context, index) {
                  var item = widget.cartList[index];
                  var data, name, price, image, qty, id, qtyList;
                  data = item;
                  name = item.product.name;
                  image = item.product.images[0].url;
                  if(item.product.discount > 0){
                    price = item.product.price * (100 - item.product.discount) * 0.01;
                  } else {
                    price = item.product.price;
                  }

                  qty = item.qty;
                  id = item.product.sId;

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
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
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

                                            Text(
                                              name.toString().toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: AppColors.baseBlackColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(price)}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: AppColors.baseBlackColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     Text(
                                        //       "adidas originals",
                                        //       style: TextStyle(
                                        //         color: AppColors.baseDarkPinkColor,
                                        //       ),
                                        //     ),
                                        //     Text(
                                        //       "\$ 70",
                                        //       style: TextStyle(
                                        //           color: AppColors.baseBlackColor,
                                        //           fontSize: 16,
                                        //           decoration: TextDecoration.lineThrough
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),

                                        Text(
                                          "Quantity x${qty}",
                                          style: TextStyle(
                                            fontSize: 16,

                                            color: AppColors.baseGrey60Color,
                                          ),
                                        )
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
                  height: 10,
                  width: double.infinity,
                  color: AppColors.placeholderBg,
                ),
                SizedBox(
                  height: 20,
                ),
                // buildConfirmationProduct(),
                // buildConfirmationProduct(),
                // buildConfirmationProduct(),
                buildBottomPart(context),
              ],
            ),
          )
        ],
      ),
    );
  }
}


class PaymentCard extends StatelessWidget {
  const PaymentCard({
    required Widget widget,
  })  : _widget = widget;

  final Widget _widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
          height: 50,
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: 30,
            right: 20,
          ),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: AppColors.placeholder.withOpacity(0.25),
              ),
            ),
            color: AppColors.placeholderBg,
          ),
          child: _widget),
    );
  }
}


class PaymentWidget extends StatefulWidget {
  const PaymentWidget({Key? key}) : super(key: key);

  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  PaymentMethod _character = PaymentMethod.Cod;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('COD'),
          leading: Radio(
            value: PaymentMethod.Cod,
            groupValue: _character,
            onChanged: (PaymentMethod? value) {
              setState(() {
                _character = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Visa'),
          leading: Radio(
            value: PaymentMethod.Visa,
            groupValue: _character,
            onChanged: (PaymentMethod? value) {
              setState(() {
                _character = value!;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Paypal'),
          leading: Radio(
            value: PaymentMethod.PayPal,
            groupValue: _character,
            onChanged: (PaymentMethod? value) {
              setState(() {
                _character = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}

