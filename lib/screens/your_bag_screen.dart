import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/Cart.dart';
import 'package:flutter_t_watch/models/CartItemModel.dart';
import 'package:flutter_t_watch/models/Store.dart';
import 'package:flutter_t_watch/models/VoucherModel.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/confirmation_screen.dart';
import 'package:flutter_t_watch/screens/payment_screen.dart';
import 'package:flutter_t_watch/styles/detail_screen_stylies.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/util/helper.dart';
import 'package:flutter_t_watch/widgets/custom_text_input.dart';
import 'package:flutter_t_watch/widgets/drop_button_widget.dart';
import 'package:flutter_t_watch/widgets/my_button_widget.dart';
import 'package:flutter_t_watch/widgets/slidable_widget.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class YourBagScreen extends StatefulWidget {
  const YourBagScreen({Key? key}) : super(key: key);

  @override
  _YourBagScreenState createState() => _YourBagScreenState();
}

class _YourBagScreenState extends State<YourBagScreen> {

  String voucherId = "";
  String nameVoucher = "";
  int sale = 0;
  String? myController;
  String dropdownValue = '1';
  String token = "";
  List<CartItem> items = [];
  List<Data> listItem = [];
  double totalAmount = 0;
  double itemsPrice = 0;
  double priceDiscount = 0;
  TextEditingController qtyController = TextEditingController();
  late int quantity = 1;
  bool loading = false;

  void calculateTotalAmount() {
    totalAmount = itemsPrice - priceDiscount;
  }


  void calculateDiscount(double firstPrice) {
    firstPrice = firstPrice * (100 - sale) * 0.01;
    setState(() {
      totalAmount = firstPrice;
    });
  }


  void calculateDiscountPrice(List<Data> list) {
    double totalPrice =  0;
    priceDiscount = 0;
    itemsPrice=0;
    list.forEach((element) {
      if(element.product.discount > 0 && sale > 0){
        totalPrice = (element.product.price *  sale * 0.01 * element.qty) + (element.product.price * element.product.discount * 0.01* element.qty) ;
        setState(() {
          itemsPrice += (element.product.price * element.qty).toDouble();
          priceDiscount += totalPrice;
        });

      } else if(element.product.discount == 0  && sale > 0){
        totalPrice = (element.product.price *  sale * 0.01* element.qty);
        setState(() {
          itemsPrice += (element.product.price * element.qty).toDouble();

          priceDiscount += totalPrice;
        });
      } else if (element.product.discount > 0 && sale == 0){
        totalPrice = (element.product.price * element.product.discount * 0.01* element.qty);
        setState(() {
          itemsPrice += (element.product.price * element.qty).toDouble();

          priceDiscount += totalPrice;
        });
      }
      else {
        setState(() {
          itemsPrice += (element.product.price * element.qty).toDouble();
        });
      }

    });

  }


  void updateTotalAmount(List<Data> list) {
    double res = 0;

    list.forEach((element) {
      res = res + element.qty * element.product.price;
    });
    totalAmount = res;
  }


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
      getMyVoucher();
    });
  }

  Future<Null> getList() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(
      Uri.parse("${AppUrl.baseUrl}/api/cart"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    //print("RESPONSE: " +response.body+"===-="+response.statusCode.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode("[${response.body}]");
      //print("data : ${data}");

      setState(() {
        for (Map<String, dynamic> i in data) {
          items.add(CartItem.fromJson(i));
        }

        var result = items[0];
        listItem = result.data;

        calculateDiscountPrice(listItem);
        setState(() {
          totalAmount = itemsPrice - priceDiscount;
        });
        loading = false;
      });
    }
  }


  Future<void> removeItem(String id, int index) async {
    print("++++++++++++++++++++++++ID OF PRODUCT:::"+id);
    var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/cart/remove-item-cart/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    print("STATUS CODE IS: "+response.statusCode.toString()+" AND BODY IS:::: "+response.body);
    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Removed Product from Cart"),));

      setState(() {
        listItem.removeAt(index);
        // calculateTotalAmount(listItem);
        calculateDiscountPrice(listItem);

          totalAmount = itemsPrice - priceDiscount;

      });

     //await getList();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Remove Product Fail"),));
    }
  }


  Future<void> removeAllItem() async {
    //print("TOKEN FOR API IS HERE---------------"+token+"AND ID OF PRODUCT:::"+widget.id);
    var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/cart/remove-all-item-cart/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );

    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Removed All Product from Cart"),));

      setState(() {
        listItem.removeRange(0, (listItem.length ));
      });
     // await getList();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Remove All Product Fail"),));
    }
  }


  List<MyVoucher> vouchers = [];
  Future<Null> getMyVoucher() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(
      Uri.parse("${AppUrl.baseUrl}/api/users/voucher/myvoucher"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode("${response.body}");

      setState(() {
        for (Map<String, dynamic> i in data) {
          vouchers.add(MyVoucher.fromJson(i));

        }

        loading = false;
      });
    }
  }


  Future<void> updateQty() async {
    setState(() {
      String q = qtyController.text;
      quantity = int.parse(q);
      getList();

    });
   // await getList();
    print("======QUANTITY UPDATED: $quantity========");
  }



  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.deepOrangeAccent,
      elevation: 2,
      centerTitle: true,
      title: Text(
        "Your cart",
        style: TextStyle(
          color: AppColors.baseWhiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
      actions: [
        // IconButton(onPressed: (){},
        // icon: SvgPicture.asset(
        //   SvgImages.heart,
        //   color: AppColors.baseBlackColor,
        //   width: 40,
        // )),
        IconButton(onPressed: (){
          //removeAllItem();
          showAlertDialogRemoveAll(context);
        },
            icon: SvgPicture.asset(
              SvgImages.delete,
              color: AppColors.baseBlackColor,
              width: 30,
            ))
      ],
    );
  }

  Widget buildSingleBag(){
    return Card(
      child: Container(
        height: 200,
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
                            image: NetworkImage("https://vcdn1-giaitri.vnecdn.net/2020/11/03/lisa-3-1604394414.jpg?w=1200&h=0&q=100&dpr=1&fit=crop&s=Uzqm3erCQJd3bC_65SfkrQ")
                          )
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("3 stripes shirt",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.baseBlackColor,
                            fontWeight: FontWeight.bold
                          ),),
                          Text("addidas original",
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.baseDarkPinkColor,
                                fontWeight: FontWeight.bold
                            ),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("\$50.00",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.baseBlackColor,
                                    fontWeight: FontWeight.bold
                                ),),
                              Text("\$70.00",
                                style: TextStyle(
                                    fontSize: 16,
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.baseBlackColor,
                                    fontWeight: FontWeight.bold
                                ),)
                            ],
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
            
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        fillColor: AppColors.baseWhiteColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0)
                        )
                      ),
                      hint: Text("Quantity",
                      style: DetailScreenStylies.productDropDownValueStyle,),
                      value: myController,
                      items: ["1", "2", "3", "4", "5"].map(
                              (e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
                      onChanged: (String? value){
                        setState(() {
                          myController = value;
                        });
                      },
                    )
                  ),
                ],
              ),
            )
          ],
        ),
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
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("Your bag",
                // style: TextStyle(
                //   fontSize: 25,
                //   color: AppColors.baseBlackColor,
                //   fontWeight: FontWeight.bold
                // ),),
                // SizedBox(height: 3,),
                Text("You have ${listItem.length} items in your bag",
                  style: TextStyle(
                      color: AppColors.baseBlackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),),
                SizedBox(height: 3,),
                Text("Swipe the item to left to remove item from cart",
                  style: TextStyle(
                    color: AppColors.baseGrey60Color,
                  ),),
                SizedBox(height: 3,),
                Text("Click the trash button to remove all item from cart",
                  style: TextStyle(
                    color: AppColors.baseGrey60Color,
                  ),),
                // _CartList(),



                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            loading == true ? const Center(child: CircularProgressIndicator(color: Colors.orangeAccent,),) :
                          listItem.isEmpty
                          ? const Center(child: Text('Your Cart is Empty'))
                              :
                          ListView.separated(
                              separatorBuilder: (context, index) => Divider(),
                            physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          primary: true,
                          itemCount: listItem.length,
                          itemBuilder: (context, index) {
                            var item = listItem[index];
                            var data, name, price, image, qty, id, qtyList, discount;
                               data = item;
                               name = item.product.name;
                               image = item.product.images[0].url;
                               //price = item.product.price;
                               qty = item.qty;
                               id = item.product.sId;
                               discount = item.product.discount;
                            if(discount >0){
                              price = (item.product.price * (100 - item.product.discount) * 0.01);
                              //priceDiscount = item.product.price * item.product.discount * 0.01;
                            } else {
                              price = item.product.price;
                              //priceDiscount = 0;
                            }
                               // setState(() {
                               //   quantity = qty;
                               // });


                            return SlidableWidget(
                              onDismissed: (action) =>
                                  dismissSlidableItem(context, index, action, id),
                              child: Card(
                                child: Container(
                                  height: 210,
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
                                                          image: NetworkImage(image)
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${name.toString().toUpperCase()}",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: AppColors.baseBlackColor,
                                                          fontWeight: FontWeight.bold
                                                      ),),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [

                                                        Text("${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(price)}",
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: AppColors.baseBlackColor,
                                                              fontWeight: FontWeight.bold
                                                          ),),
                                                        price == item.product.price ? SizedBox()
                                                        : Text("${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(item.product.price)}",
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              color: AppColors.baseGrey40Color,
                                                              decoration: TextDecoration.lineThrough
                                                          ),),
                                                      ],
                                                    ),

                                                    Text("Quantity: ${qty}",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: AppColors.baseBlackColor,
                                                          fontWeight: FontWeight.bold
                                                      ),),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // Expanded(
                                            //   child: Container(
                                            //     padding: EdgeInsets.all(10.0),
                                            //     child: CircleAvatar(
                                            //       radius: 25,
                                            //       backgroundColor: AppColors.baseGrey30Color,
                                            //       child: IconButton(onPressed: () async {
                                            //         await removeItem(id, index);
                                            //       },
                                            //           icon: SvgPicture.asset(
                                            //             SvgImages.delete,
                                            //             color: AppColors.baseBlackColor,
                                            //             width: 40,
                                            //           )),
                                            //     ),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),

                                      Expanded(
                                        child: Row(
                                          children: [

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
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    "Change Quantity For ",
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        color: AppColors.baseBlackColor,
                                                                        fontWeight: FontWeight.bold
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 6,),
                                                                  Text("${name.toString().toUpperCase()}",
                                                                  style: TextStyle(fontSize: 16,color: AppColors.baseBlackColor),)
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
                                                              child: CustomTextInputQtyInCart(
                                                                hintText: "type quantity you want to buy", controller: qtyController,),
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

                                                                      if(int.parse(qtyController.text) < item.product.countInStock){
                                                                        var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/cart/qty-update/${id}"),
                                                                            headers: <String, String>{
                                                                              'Content-Type': 'application/json; charset=UTF-8',
                                                                              'Authorization': 'Bearer $token'
                                                                            },
                                                                            body: jsonEncode({
                                                                              "quantity": int.parse(qtyController.text),
                                                                            }
                                                                            )
                                                                        );

                                                                        if(response.statusCode == 200){
                                                                          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added Product to Cart"),));
                                                                          setState(() {
                                                                            item.qty = int.parse(qtyController.text);

                                                                          });
                                                                          //getList();
                                                                          // calculateTotalAmount(listItem);
                                                                          // calculateDiscount(totalAmount);
                                                                          calculateDiscountPrice(listItem);
                                                                          setState(() {
                                                                            totalAmount = itemsPrice - priceDiscount;
                                                                          });
                                                                          // Navigator.pop(context);  // pop current page
                                                                          // Navigator.of(context).push(
                                                                          //     MaterialPageRoute(builder: (context) => YourBagScreen())); // push it back in

                                                                        } else if(response.statusCode == 400){
                                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You're buying with quantity greater than count in stock. Please select quantity again"),));
                                                                        } else {
                                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid quantity. Please select quantity again"),));
                                                                        }
                                                                        Navigator.of(context).pop();
                                                                      } else{
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You're buying with quantity greater than count in stock. Please select quantity again"),));
                                                                        Navigator.of(context).pop();
                                                                      }

                                                                    },
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                      children: const [

                                                                        SizedBox(width: 40),
                                                                        Text("Submit"),
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
                                                "Change Quantity",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16
                                                ),
                                              ),
                                            ),

                                            SizedBox(width: 10,),

                                            Flexible(
                                                child: Row(
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: () async{
                                                        if(item.qty > 1){

                                                          setState(()  {
                                                            item.qty = --item.qty;
                                                            // calculateTotalAmount(listItem);
                                                            // calculateDiscount(totalAmount);
                                                            calculateDiscountPrice( listItem);
                                                            setState(() {
                                                              totalAmount = itemsPrice - priceDiscount;
                                                            });
                                                          });
                                                          var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/cart/qty-update/${id}"),
                                                              headers: <String, String>{
                                                                'Content-Type': 'application/json; charset=UTF-8',
                                                                'Authorization': 'Bearer $token'
                                                              },
                                                              body: jsonEncode({
                                                                "quantity": item.qty,
                                                              }
                                                              )
                                                          );

                                                          if(response.statusCode == 200){
                                                            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added Product to Cart"),));
                                                            setState(() {
                                                              qty = item.qty;
                                                              print("qty after tru: "+qty.toString());

                                                            });
                                                            // getList();

                                                            // PageRouting.goToNextPage(context: context, navigateTo: YourBagScreen());
                                                          } else {
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update qty Fail"),));
                                                          }

                                                        }
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColors.baseBlackColor.withOpacity(0.5)
                                                            )
                                                        ),
                                                        width: 30,
                                                        height: 30,
                                                        child: Icon(LineIcons.minus,color: AppColors.baseBlackColor.withOpacity(0.5),),
                                                      ),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    // CustomTextInputQty(
                                                    //   hintText: "", controller: item.qty.toString(),),
                                                    Text(item.qty.toString(),style: const TextStyle(
                                                        fontSize: 17
                                                    ),),
                                                    SizedBox(width: 20,),
                                                    InkWell(
                                                      onTap: () async{
                                                        if(item.qty < item.product.countInStock){
                                                          setState(() {
                                                            item.qty = ++item.qty;
                                                            // calculateTotalAmount(listItem);
                                                            // calculateDiscount(totalAmount);
                                                            calculateDiscountPrice(listItem);
                                                            setState(() {
                                                              totalAmount = itemsPrice - priceDiscount;
                                                            });
                                                          });

                                                          print("item qty:"+item.qty.toString());
                                                          print("id: "+id);
                                                          var response = await http.put(Uri.parse("${AppUrl.baseUrl}/api/cart/qty-update/${id}"),
                                                              headers: <String, String>{
                                                                'Content-Type': 'application/json; charset=UTF-8',
                                                                'Authorization': 'Bearer $token'
                                                              },
                                                              body: jsonEncode({
                                                                "quantity": item.qty,
                                                              }
                                                              )
                                                          );

                                                          print("stt code: "+response.statusCode.toString());
                                                          if(response.statusCode == 200){
                                                            //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added Product to Cart"),));
                                                            setState(() {
                                                              qty = item.qty;
                                                              print("qty after cong: "+qty.toString());
                                                              //getList();

                                                            });
                                                            // PageRouting.goToNextPage(context: context, navigateTo: YourBagScreen());
                                                          } else {
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update qty Fail"),));
                                                          }

                                                        } else {
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Quantity you buy must be less than in stock"),));

                                                        }



                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColors.baseBlackColor.withOpacity(0.5)
                                                            )
                                                        ),
                                                        width: 30,
                                                        height: 30,
                                                        child: Icon(LineIcons.plus,color: AppColors.baseBlackColor.withOpacity(0.5),),
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),


                                            // Expanded(
                                            //     child: DropdownButtonFormField<String>(
                                            //       decoration: InputDecoration(
                                            //           fillColor: AppColors.baseWhiteColor,
                                            //           filled: true,
                                            //           border: OutlineInputBorder(
                                            //               borderSide: BorderSide.none,
                                            //               borderRadius: BorderRadius.circular(10.0)
                                            //           )
                                            //       ),
                                            //       hint: Text("Count in Stock ",
                                            //         style: DetailScreenStylies.productDropDownValueStyle,),
                                            //       value: myController,
                                            //       items: ["1", "2", "3", "4", "5"].map(
                                            //               (e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
                                            //       onChanged: (String? value){
                                            //         setState(() {
                                            //           myController = value;
                                            //         });
                                            //       },
                                            //     )
                                            // ),
                                          ],
                                        ),
                                      )
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
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.only(right: 20),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: AppColors.baseWhiteColor,
                            borderRadius: BorderRadius.circular(10.0),

                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: nameVoucher.isEmpty ?
                          Text("Please choose a voucher",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColors.baseBlackColor
                            ),)
                          : Text(nameVoucher,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.baseBlackColor
                          ),),
                        ),
                      ),
                      Expanded(
                          child:
                      //     MaterialButton(
                      //   elevation: 0,
                      //   height: 40,
                      //   color: AppColors.baseLightOrangeColor,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(7),
                      //     side: BorderSide.none
                      //   ),
                      //   child: Text("Employ", style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //     color: AppColors.baseWhiteColor
                      //   ),),
                      //   onPressed: () {},
                      // )
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
                                                  "Choose a voucher",
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


                                          loading == true ? const Center(child: CircularProgressIndicator(color: Colors.orangeAccent,),) :
                                          vouchers.isEmpty
                                              ? const Center(child: Text('You do not have any voucher'))
                                          : ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            primary: true,
                                            itemCount: vouchers.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              var voucher = vouchers[index];

                                              return ListTile(
                                                contentPadding: EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 16,
                                                ),
                                                leading:
                                                Image.asset(
                                                    "./images/sale.png",
                                                  width: 75,
                                                  height: 50,
                                                  //color: Colors.white,
                                                ),
                                                title: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        voucher.name,
                                                        style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,)

                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(voucher.discount.toString()+"%", style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold,)
                                                    )
                                                  ],
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    nameVoucher = voucher.name;
                                                    sale = voucher.discount;
                                                    voucherId = voucher.sId;
                                                  });
                                                  // calculateDiscount(totalAmount);
                                                  calculateDiscountPrice( listItem);
                                                  setState(() {
                                                    totalAmount = itemsPrice - priceDiscount;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                          ),


                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: const Text(
                              "Choose a voucher",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent
                              ),
                            ),
                          ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Total amount",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.baseBlackColor,
                        fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 2,),
                      Text("Your Total Amount of discount",
                        style: TextStyle(
                            color: AppColors.baseBlackColor,
                        ),)
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(totalAmount)}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.baseBlackColor,
                        fontWeight: FontWeight.bold
                      )),
                      SizedBox(height: 2,),
                      Text("-${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(priceDiscount)}",
                          style: TextStyle(
                              color: AppColors.baseBlackColor,
                          ))
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  child: listItem.length == 0 ? SizedBox()
                  : MaterialButton(
                    color: AppColors.baseLightOrangeColor,
                    height: 45,
                    elevation: 0,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    onPressed:(){
                      // PageRouting.goToNextPage(context: context, navigateTo: PaymentScreen());
                      PageRouting.goToNextPage(context: context, navigateTo: ConfirmationScreen(cartList: listItem, total: totalAmount, voucherId: voucherId,));
                    },
                    child: Text(
                      "Checkout",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )

              ],
            ),
          )
        ],
      ),
    ),
    ]
    )
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
//            Navigator.pop(context);
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


  showAlertDialogRemoveAll(BuildContext context) {
    // Create button
    Widget okButton = Row(
      children: [
        TextButton(
          child: Text("Yes"),
          onPressed: () async{
            await removeAllItem();
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
      title: Text("Remove All Item"),
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





class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [RemoveMutation]);
    final CartModel _cart = (VxState.store as MyStore).cart;
    return _cart.items.isEmpty
        ? "Nothing to show".text.xl3.makeCentered()
        : ListView.builder(
      itemCount: _cart.items.length,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.done),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () => RemoveMutation(_cart.items[index]),
        ),
        title: _cart.items[index].productName.text.make(),
      ),
    );
  }
}
