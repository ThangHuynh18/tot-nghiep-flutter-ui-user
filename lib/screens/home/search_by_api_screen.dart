import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/detail/detail_product_screen.dart';
import 'package:flutter_t_watch/styles/home_screen_stylies.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/widgets/home/home_singleProduct_widget.dart';
import 'package:http/http.dart' as http;


class SearchAPI extends StatefulWidget {
  const SearchAPI({Key? key}) : super(key: key);

  @override
  _SearchAPIState createState() => _SearchAPIState();
}

class _SearchAPIState extends State<SearchAPI> {

  List<Product> list = [];
  List<Products> products = [];
  List<Products> _searchResult = [];
  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add
  // Future<Null> getProducts() async {
  //   final response = await http.get(
  //       Uri.parse("http://localhost:3030/api/products"));
  //   if (response.statusCode == 200) {
  //     final List books = jsonDecode("[${response.body}]");
  //     for (Map<String, dynamic> i in books) {
  //       list.add(Product.fromJson(i));
  //     }
  //     var result = list[0];
  //     List products = result.data.products;
  //   }
  // }

  Future<List<Products>> getData(String query) async {
    print("KEYWORD IS: "+query);
    final url = Uri.parse(
        'http://localhost:3030/api/products?keyword=$query');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List books = jsonDecode("[${response.body}]");
      for (Map<String, dynamic> i in books) {
        list.add(Product.fromJson(i));
      }
      var result = list[0];
      products = result.data.products;
      print("name: "+products.length.toString());
    }
    return products;
  }
  @override
  void initState() {
    super.initState();

   // getProducts();
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title:Column(
        children: [
        Text("Search",
        style: HomeScreenStylies.appBarUpperTitleStylies,),

      ]
      ),
      elevation: 0.0,

      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Search Product'),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: IconButton(
                      onPressed: () async{
                        String q = controller.text;
                        var result = await getData(q);

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
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                // return Card(
                //   child: new ListTile(
                //     leading: new CircleAvatar(backgroundImage: new NetworkImage(products[index].images[0].url,),),
                //     title: new Text(products[index].name),
                //   ),
                //   margin: const EdgeInsets.all(0.0),
                // );

                var item = products[index];
                var productImage, productName, productModel, productPrice, qty, id, data, rating, discount;
                for(var i = 0; i < products.length; i++){

                  productImage = item.images[0].url;
                  productName = item.name;
                  productModel = item.brand.name;
                  if(item.discount >0){
                    productPrice = (item.price * (100 - item.discount) * 0.01);
                  } else {
                    productPrice = item.price.toDouble();
                  }
                  //productPrice = item.price;
                  qty = item.countInStock;
                  rating = item.rating;
                  discount = item.discount;

                  id = item.sId;
                  data = item;
                }

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
                    }, productOldPrice: item.price.toDouble(), discount: discount,);

              },
            ),
          ),
        ],
      ),
    );
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

