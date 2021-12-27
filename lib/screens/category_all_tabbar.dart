import 'package:flutter/material.dart';
import 'package:flutter_t_watch/data/category_screen_data.dart';
import 'package:flutter_t_watch/models/SingleProductModel.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/detail_screen.dart';
import 'package:flutter_t_watch/widgets/show_all_widget.dart';
import 'package:flutter_t_watch/widgets/singleProduct_widget.dart';
class CategoryAllTabBar extends StatelessWidget {
  const CategoryAllTabBar({Key? key}) : super(key: key);


  Widget builderRender({required List<SingleProductModel> singleProduct}) {
    return Container(
      height: 250,
      child: GridView.builder(
        itemCount: singleProduct.length,
          shrinkWrap: true,
          primary: true,
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1.4
          ), itemBuilder: (context, index) {
          var data = singleProduct[index];
          return SingleProductWidget(
              productImage: data.productImage,
              productName: data.productName,
              productModel: data.productModel,
              productPrice: data.productPrice,
              productOldPrice: data.productOldPrice,
              onPressed: () {
                PageRouting.goToNextPage(context: context, navigateTo: DetailScreen(data: data));
              });
      }),
    );
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        ShowAllWidget(
          leftText: "Clothing",
        ),
        builderRender(singleProduct: categoryClothData),
        ShowAllWidget(
          leftText: "Shoes",
        ),
        builderRender(singleProduct: categoryShoesData),
        ShowAllWidget(
          leftText: "Accessories",
        ),
        builderRender(singleProduct: categoryAccessoriesData),
      ],
    );
  }
}
