import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/data/home_page_data.dart';
import 'package:flutter_t_watch/models/BrandModel.dart' as brand;
import 'package:flutter_t_watch/models/CartItemModel.dart';

import 'package:flutter_t_watch/models/ProductModel.dart' as model;
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/chatbot_screen.dart';
import 'package:flutter_t_watch/screens/detail/detail_product_screen.dart';
import 'package:flutter_t_watch/screens/detail_screen.dart';
import 'package:flutter_t_watch/screens/filter_screen.dart';
import 'package:flutter_t_watch/screens/get_product_by/get_all_product_screen.dart';
import 'package:flutter_t_watch/screens/get_product_by/get_by_brand_screen.dart';
import 'package:flutter_t_watch/screens/home/search_by_api_screen.dart';
import 'package:flutter_t_watch/screens/tabbar_couple.dart';

import 'package:flutter_t_watch/screens/tabbar_man.dart';
import 'package:flutter_t_watch/screens/tabbar_woman.dart';
import 'package:flutter_t_watch/styles/home_screen_stylies.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/util/constants.dart';
import 'package:flutter_t_watch/util/size_config.dart';
import 'package:flutter_t_watch/widgets/home/home_product_rating_widget.dart';
import 'package:flutter_t_watch/widgets/home/home_singleProduct_widget.dart';
import 'package:flutter_t_watch/widgets/home/single_item_count_widget.dart';
import 'package:flutter_t_watch/widgets/show_all_widget.dart';
import 'package:flutter_t_watch/widgets/singleProduct_widget.dart';
import 'package:flutter_t_watch/widgets/star_rating_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

import '../search_product_screen.dart';
import '../search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  // List<Map<String, dynamic>> categories = [
  //   {"icon": "images/icons/Flash Icon.svg", "text": "Flash Deal"},
  //   {"icon": "images/icons/Bill Icon.svg", "text": "Bill"},
  //   {"icon": "images/icons/Game Icon.svg", "text": "Game"},
  //   {"icon": "images/icons/Gift Icon.svg", "text": "Daily Gift"},
  //   {"icon": "images/icons/ellipsis.svg", "text": "More"},
  // ];


  List<model.Product> list = [];
  //Map<String, dynamic> productList = "";
  List<model.Products> products = [];
  var loading = false;

  TextEditingController controller = new TextEditingController();
  List<model.Products> _searchResult = [];

  // final baseUrl = "http://localhost:5000";
  //final baseUrl = "https://graduate-flutter-api.herokuapp.com";
// sao nó đỏ thế
  Future<Null> _fetchData() async {
    setState(() {
      loading = true;
    });

      final response = await http.get(
          Uri.parse("${AppUrl.baseUrl}/api/products"),
          headers: {"Accept": "application/json",
            'connection': 'keep-alive'});

      if (response.statusCode == 200) {
        final data = jsonDecode("[${response.body}]");
        //print("data : ${data}");


        setState(() {
          for (Map<String, dynamic> i in data) {
            list.add(model.Product.fromJson(i));
          }

          var result = list[0];
          //products = result.data.products;
          for(int i = 0; i< 4; i++){
           // listProduct = result.products;
            products.add(result.data.products[i]);
          }

          // for(var j=0; j < list.length; j++){
          //   li = Products.fromJson(productList[j]);
          //   products.add(li);
          // }

          loading = false;
        });
        print("PRODUCTS LENGTH: "+products.length.toString());
      }

  }

  Future<List<model.Products>> getData(String query) async {
    print("KEYWORD IS: "+query);
    final url = Uri.parse(
        '${AppUrl.baseUrl}/api/products?keyword=$query');
    print("URL  "+url.toString());
    List<model.Product> list2 = [];
    List<model.Products> products2 = [];

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode("[${response.body}]");

      setState(() {
        for (Map<String, dynamic> i in data) {
          list2.add(model.Product.fromJson(i));
        }

        var result = list2[0];
        products2 = result.data.products;
      });
    }
    setState(() {
      list = list2;
      products = products2;
    });

    return products;
  }

  //var valueChoose;
  //String valueChoose = "61781427bb9c332424927ac1";
  List<brand.Brand> brands = [];
  Future<Null> getBrand() async {
    final response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/api/brands"),
        headers: {"Accept": "application/json",
          'connection': 'keep-alive'});

    if (response.statusCode == 200) {
      final data = jsonDecode("${response.body}");

      setState(() {
        for (Map<String, dynamic> i in data) {
          brands.add(brand.Brand.fromJson(i));
        }

      });
    }
}


  List<model.Products> listTopProduct =[];
  List<Product> listFirst = [];
  Future<Null> getTopProductRating() async {

    final response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/api/products/top"),
        headers: {"Accept": "application/json",
          'connection': 'keep-alive'});

    if (response.statusCode == 200) {
      final data = jsonDecode("[${response.body}]");

      setState(() {
        for (Map<String, dynamic> i in data) {
          listFirst.add(Product.fromJson(i));
        }

        var result = listFirst[0];
        listTopProduct = result.products;

      });
    }

  }


  List<model.Products> listSaleProduct =[];
  List<Product> listSecond = [];
  Future<Null> getTopProductSale() async {

    final response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/api/products/discount"),
        headers: {"Accept": "application/json",
          'connection': 'keep-alive'});

    if (response.statusCode == 200) {
      final data = jsonDecode("[${response.body}]");
      print("data of product by discount: ${data}");

      setState(() {
        for (Map<String, dynamic> i in data) {
          listSecond.add(Product.fromJson(i));
        }
//co
        var result = listSecond[0];
        listSaleProduct = result.products;

      });
    }

  }


  String token = "";
  void getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("login");
      getListCart();
    });
  }

  List<CartItem> cartItems = [];
  List<Data> listItemCart = [];
  Future<Null> getListCart() async {
    final response = await http.get(
      Uri.parse("${AppUrl.baseUrl}/api/cart"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode("[${response.body}]");

      setState(() {
        for (Map<String, dynamic> i in data) {
          cartItems.add(CartItem.fromJson(i));

        }

        var result = cartItems[0];
        listItemCart = result.data;

      });
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
    getBrand();
    //getToken();
    getTopProductRating();
    getTopProductSale();
    //getListCart();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      bottom: TabBar(
        labelPadding: EdgeInsets.only(left: 22, top: 10, right: 22, bottom: 10),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          //color: Colors.orange,
        ),
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),
        unselectedLabelColor: AppColors.baseBlackColor,
        labelColor: AppColors.baseWhiteColor,
        tabs: const [
          // GridView.builder(
          // shrinkWrap: true,
          // primary: true,
          // itemCount: brands.length,
          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     childAspectRatio: 0.7
          // ),
          // itemBuilder: (context, index) {
          //   var item = brands[index];
          //   var name = item.name;
          //   return Text("$name");
          // }),
          Text("All"),
          Text("Nam"),
          Text("Nữ"),
          Text("Couple"),
        ],
      ),
      backgroundColor: Colors.deepOrangeAccent,
      centerTitle: true,
      elevation: 3.0,
      title: Column(
        children: [
          // Text("Welcome",
          //   style: HomeScreenStylies.appBarUpperTitleStylies,),
          // Text("Shopping", style: HomeScreenStylies.appBarBottomTitleStylies,),
          Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                child: ListTile(
                  leading: IconButton(
                      onPressed: () async{
                        // setState(() {
                        //   _fetchData();
                        // });

                        String q = controller.text;
                        // var result = await getData(q);
                        // setState(() {
                        //   this.products = result;
                        // });

                        PageRouting.goToNextPage(context: context, navigateTo: SearchScreen(query: q,));
                      },
                      icon: SvgPicture.asset(SvgImages.search,
                        color: AppColors.baseBlackColor,
                        width: 30,)
                  ),
                  title: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: IconButton(icon: Icon(Icons.cancel), onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },),
                ),
              ),
            )

          // Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: "Search...."
          //     ),
          //     onChanged: (text){
          //       text = text.toLowerCase();
          //       // setState(() {
          //       //   products = products.where((element) => {
          //       //     var name = element.
          //       //   })
          //       // });
          //     },
          //   ),
          // )
        ],
      ),
      actions: [
        IconButton(
            onPressed: (){
              //PageRouting.goToNextPage(context: context, navigateTo: FilterScreen());
              PageRouting.goToNextPage(context: context, navigateTo: ChatBotScreen());
            },
            icon: Icon(FontAwesomeIcons.comment,)
        ),
        // Badge(
        //   showBadge: true,
        //   shape: BadgeShape.square,
        //   badgeColor: Colors.white,
        //   animationDuration: Duration(milliseconds: 300),
        //   animationType: BadgeAnimationType.scale,
        //   position: BadgePosition.topEnd(top: 0, end: 3),
        //   badgeContent: Text(listItemCart.length.toString()),
        //   borderRadius: BorderRadius.circular(10),
        //   child: Icon(Icons.shopping_cart,size: 50,),
        // )

        // IconButton(
        //     onPressed: (){
        //       PageRouting.goToNextPage(context: context, navigateTo: SearchAPI());
        //     },
        //     icon: SvgPicture.asset(SvgImages.search,
        //       color: AppColors.baseBlackColor,
        //       width: 30,)
        // )
      ],
    );
  }



  Widget buildTrendingProduct({required String productImage, required String productName, required String productModel, required double productPrice, required double rating}) {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 20, bottom: 20),
      height: 65,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Material(
              shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Image.network(productImage),
            ),
          ),
          Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName, style: HomeScreenStylies.trendingProductNameStyle),
                    SizedBox(width: 5,),
                    Text(productModel, style: HomeScreenStylies.trendingProductModelStyle,),
                    SizedBox(width: 5,),
                    StarRating(rating: rating, size: 10),

                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 30.0
            ),
            child: MaterialButton(
              color: AppColors.baseLightPinkColor,
              elevation: 0,
              height: 45,
              shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(0.7)
              ),
              onPressed: () {},
              child: Text("\$ $productPrice", style: HomeScreenStylies.trendingProductPriceStyle,),
            ),
          )
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: TabBarView(
              children: [
                ListView(
                  physics: BouncingScrollPhysics(),
                  children: [

                    //buildAdvertisementPlace(),
                    // Card(
                    //   child: DropdownButton(
                    //     hint: Text("Select Brand"),
                    //     dropdownColor: Colors.white,
                    //     icon: Icon(Icons.arrow_drop_down),
                    //     iconSize: 36,
                    //     isExpanded: true,
                    //     underline: SizedBox(),
                    //     style: TextStyle(color: Colors.black, fontSize: 15),
                    //     value: valueChoose,
                    //     onChanged: (newValue) {
                    //       setState(() {
                    //         valueChoose = newValue.toString();
                    //         //getBrand();
                    //         print("value selected: "+valueChoose);
                    //       });
                    //     },
                    //     items: brands.map((brand.Brand valueItem) {
                    //       return DropdownMenuItem<String>(
                    //         // value: valueItem['_id'],
                    //         // child: Text(valueItem['name']),
                    //         value: valueItem.sId,
                    //         child: Text(valueItem.name),
                    //       );
                    //     }).toList(),
                    //   ),
                    //   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 24.0),
                    // ),


                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...List.generate(
                            brands.length,
                                (index) => CategoryCard(
                              icon: brands[index].description,
                              text: brands[index].name,
                              press: () {
                                PageRouting.goToNextPage(context: context, navigateTo:
                                              ProductByBrandScreen(id: brands[index].sId, brandName: brands[index].name));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),


                    ShowAllWidget(leftText: "Trending"),


                    Container(
                      height: 240,
                      child: listTopProduct == null || listTopProduct.length == 0
                          ? const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent,))
                          :
                      GridView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          primary: true,
                          itemCount: listTopProduct.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1.5
                          ),
                          itemBuilder: (context, index) {
                            var item = listTopProduct[index];
                            var productImage, productName, productModel, productPrice, qty, id, data, rating;
                            for(var i = 0; i < listTopProduct.length; i++){

                              productImage = item.images[0].url;
                              productName = item.name;
                              productModel = item.brand.name;
                              if(item.discount >0){
                                productPrice = (item.price * (100 - item.discount) * 0.01) as double;
                              } else {
                                productPrice = item.price.toDouble();
                              }

                              qty = item.countInStock;
                              rating = item.rating.toDouble();

                              id = item.sId;
                              data = item;
                            }

                            return HomeProductRatingWidget(
                              id: id,
                              productImage: productImage,
                              productName: productName,
                              productModel: productModel,
                              productPrice: productPrice as double, rating: rating,
                              productOldPrice: item.price.toDouble(),
                              qty: qty,
                              onPressed: () {
                                PageRouting.goToNextPage(context: context, navigateTo: DetailProductScreen(
                                  data: data,
                                ));
                              }, discount: item.discount,);
                          }),

                    ),



                    ShowAllWidget(
                      leftText: "Sale",
                    ),
                    Container(
                        height: 240,
                        child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            primary: true,
                            itemCount: listSaleProduct.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 1.5
                            ),
                            itemBuilder: (context, index) {
                              var data = listSaleProduct[index];
                              var price;

                              if (data.discount > 0) {
                                price = (100 - data.discount) * data.price * 0.01;
                              } else {
                                price = data.price;
                              }

                              return HomeProductRatingWidget(
                                id: data.sId,
                                productImage: data.images[0].url,
                                productName: data.name,
                                productModel: data.brand.name,
                                productPrice: price as double,
                                productOldPrice: data.price.toDouble(),
                                rating: data.rating.toDouble(),
                                qty: data.countInStock,
                                onPressed: () {
                                  PageRouting.goToNextPage(context: context, navigateTo: DetailProductScreen(
                                    data: data,
                                  ));
                                }, discount: data.discount,);
                            })
                    ),


                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "New Arrival",
                            style: TextStyle(
                                fontSize: 17,
                                color: AppColors.baseBlackColor,
                                fontWeight: FontWeight.bold
                            ),),

                          TextButton(
                            onPressed: () {
                             PageRouting.goToNextPage(context: context, navigateTo: AllProductScreen());
                            },
                            child: Text(
                              "Show All",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                                fontSize: 17
                              ),
                            ),
                          ),

                          // Text("Show All",
                          //   style: TextStyle(
                          //     fontSize: 17,
                          //     color: AppColors.baseDarkPinkColor,
                          //   ),)

                        ],
                      ),
                    ),

                    //ShowAllWidget(leftText: "New Arrival"),
                    Padding(padding: EdgeInsets.only(left: 12.0, right: 12),
                      child: products == null || products.length == 0
                          ? const Center(child: CircularProgressIndicator(color: Colors.deepOrangeAccent,))
                          :
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          primary: true,
                          itemCount: products.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7
                          ),
                          itemBuilder: (context, index) {
                            //var data = list[0].data.products[index];
                            // var item = list[index];
                            // var productImage, productName, productModel, productPrice, qty, id, data;
                            // for(var i = 0; i < item.data.products.length; i++){
                            //
                            //       productImage = item.data.products[i].images[0].url;
                            //       productName = item.data.products[i].name;
                            //       productModel = item.data.products[i].brand.name;
                            //       productPrice = item.data.products[i].price;
                            //       qty = item.data.products[i].countInStock;
                            //
                            //       id = item.data.products[i].sId;
                            //       data = item.data.products[i];
                            // }


                            var item = products[index];
                            var productImage, productName, productModel, productPrice, qty, id, data, rating, discount;
                            for(var i = 0; i < products.length; i++){

                              productImage = item.images[0].url;
                              productName = item.name;
                              productModel = item.brand.name;
                              if(item.discount >0){
                                productPrice = (item.price * (100 - item.discount) * 0.01) as double;
                              } else {
                                productPrice = item.price.toDouble();
                              }
                              qty = item.countInStock;
                              rating = item.rating.toDouble();
                              discount = item.discount;

                              id = item.sId;
                              data = item;
                            }

                            // return HomeProductRatingWidget(
                            //     id: id,
                            //     productImage: productImage,
                            //     productName: productName,
                            //     productModel: productModel,
                            //     productPrice: productPrice,
                            //     qty: qty,
                            //     rating: rating,
                            //     onPressed: () {
                            //       PageRouting.goToNextPage(context: context, navigateTo: DetailProductScreen(
                            //         data: data,
                            //       ));
                            //     },
                            //     productOldPrice: item.price.toDouble(),);

                            return HomeSingleProductWidget(
                              id: id,
                              productImage: productImage,
                              productName: productName,
                              productModel: productModel,
                              productPrice: productPrice,
                              qty: qty,
                              rating: rating,
                              onPressed: () {
                                PageRouting.goToNextPage(context: context, navigateTo: DetailProductScreen(
                                  data: data,
                                ));
                              },
                              productOldPrice: item.price.toDouble(), discount: discount,
                            );

                          }),

                    ),

                    Divider(
                      indent: 16,
                      endIndent: 16,
                    ),



                  ],
                ),

                TabBarMan(),
                TabBarWoman(),
                TabBarCouple(),
                // TabBarBar(
                //   productData: colothsData,
                // ),
                // TabBarBar(
                //   productData: shoesData,
                // ),
                // TabBarBar(
                //   productData: accessoriesData,
                // ),

    ]),

        ));
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    products.forEach((userDetail) {
      if (userDetail.name.contains(text))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}


class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.icon,
    required this.text,
    required this.press,
  });

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 45,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 1.0),
                decoration: BoxDecoration(
                  color: AppColors.baseWhiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: img.Image.network(icon),
                // child: SvgPicture.asset(
                //   icon,
                //   width: 18.0,
                //   height: 18.0,
                //   color: kPrimaryColor.withOpacity(.8),
                // ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(text.toUpperCase(), style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
