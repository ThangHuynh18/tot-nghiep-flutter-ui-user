import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/detail/detail_product_screen.dart';
import 'package:flutter_t_watch/screens/detail_screen.dart';
import 'package:flutter_t_watch/styles/sub_category_stylies.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/widgets/home/home_singleProduct_widget.dart';
import 'package:flutter_t_watch/widgets/product_by_brand_widget.dart';
import 'package:http/http.dart' as http;

class ProductByBrandScreen extends StatefulWidget {
  late String id;
  late String brandName;

  ProductByBrandScreen({required this.id, required this.brandName});

  @override
  State<ProductByBrandScreen> createState() => _ProductByBrandScreenState();
}

class _ProductByBrandScreenState extends State<ProductByBrandScreen> {
  List<Products> listProduct =[];
  List<Product> list = [];

  int isSelect = 1;
  List<bool> isSelected = [true, false, false];
  FocusNode focusNodeButton1 = FocusNode();
  FocusNode focusNodeButton2 = FocusNode();
  FocusNode focusNodeButton3 = FocusNode();
  List<FocusNode> focusToggle = [];

  Future<Null> _fetchData() async {

    final response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/api/products/brand/${widget.id}"),
        headers: {"Accept": "application/json",
          'connection': 'keep-alive'});

    if (response.statusCode == 200) {
      final data = jsonDecode("[${response.body}]");
      print("data of product by brand: ${data}");

      setState(() {
        for (Map<String, dynamic> i in data) {
          list.add(Product.fromJson(i));
        }

        var result = list[0];
        listProduct = result.products;

      });
    }

  }


  @override
  void initState() {
    focusToggle = [
      focusNodeButton1,
      focusNodeButton2,
      focusNodeButton3,
    ];
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    focusNodeButton1.dispose();
    focusNodeButton2.dispose();
    focusNodeButton3.dispose();

    super.dispose();
  }


  Widget buildToggleButton() {
    return ToggleButtons(
      borderWidth: 0,
      focusColor: null,
      fillColor: Colors.transparent,
      selectedColor: AppColors.baseDarkPinkColor,
      disabledColor: AppColors.baseBlackColor,
      selectedBorderColor: Colors.transparent,
      borderColor: Colors.transparent,
      focusNodes: focusToggle,
      children: [
        Icon(
          Icons.grid_view,
          size: 25,
        ),
        Icon(
          Icons.view_agenda_outlined,
          size: 25,
        ),
        Icon(
          Icons.crop_landscape_sharp,
          size: 25,
        ),
      ],
      onPressed: (int index) {
        if (index == 0) {
          setState(() {
            isSelect = 1;
          });
        } else if (index == 1) {
          setState(() {
            isSelect = 2;
          });
        } else if (index == 2) {
          setState(() {
            isSelect = 3;
          });
        }

        setState(() {
          for (int buttonIndex = 0;
          buttonIndex < isSelected.length;
          buttonIndex++) {
            if (buttonIndex == index) {
              isSelected[buttonIndex] = true;
            } else {
              isSelected[buttonIndex] = false;
            }
          }
        });
      },
      isSelected: isSelected,
    );
  }


  AppBar buildAppBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: (){},
          icon: RotationTransition(
            turns: AlwaysStoppedAnimation(90/360),
            child: SvgPicture.asset(
              SvgImages.fillter,
              color: AppColors.baseBlackColor,
              width: 35,),
          ),
        ),
        IconButton(
          onPressed: (){},
          icon: SvgPicture.asset(
            SvgImages.search,
            color: AppColors.baseBlackColor,
            width: 35,),
        )

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.brandName.toUpperCase(),
                  style: SubCategoryStylies.subCategoryTitleStyle,),
                SizedBox(height: 5,),
                Text("${listProduct.length} Products",
                  style: SubCategoryStylies.subCategoryProductItemStyle,),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list_alt_sharp,
                          color: AppColors.baseBlackColor,
                          size: 25,
                        ),
                        SizedBox(width: 5,),
                        Text("View Mode",style: SubCategoryStylies.subCategoryModelNameStyle,)
                      ],)),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildToggleButton(),
                        ],
                      ),
                    )
                  ],
                ),

                Divider(),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: listProduct.length,
                  physics: NeverScrollableScrollPhysics(),
                  primary: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isSelect == 1 ? 2 : isSelect == 2 ? 1 : isSelect == 3 ? 1 : 2,
                      childAspectRatio: isSelect == 1 ? 0.7 : isSelect == 2 ? 1.5 : isSelect == 3 ? 0.8 : 0.7
                  ),
                  itemBuilder: (context, index){
                    var data = listProduct[index];
                    var productPrice;
                    if(data.discount >0){
                      productPrice = (data.price * (100 - data.discount) * 0.01);
                    } else {
                      productPrice = data.price.toDouble();
                    }

                    return HomeSingleProductWidget(
                        id: data.sId,
                        productImage: data.images[0].url,
                        productName: data.name,
                        productModel: data.category.name,
                        productPrice: productPrice,
                        qty: data.countInStock,
                        rating: data.rating.toDouble(),
                        onPressed: () {
                          PageRouting.goToNextPage(context: context, navigateTo: DetailProductScreen(data: data));
                        }, productOldPrice: data.price.toDouble(), discount: data.discount,);
                  },
                )
              ],
            ),),

        ],
      ),
    );
  }
}

class Product {
  late String status;
  late List<Products> products;
  late String errors;

  Product({required this.status, required this.products, required this.errors});

  Product.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      products = <Products>[];
      json['data'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    errors = json['errors'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['status'] = this.status;
  //   if (this.data != null) {
  //     data['data'] = this.data.toJson();
  //   }
  //   data['errors'] = this.errors;
  //   return data;
  // }
}
