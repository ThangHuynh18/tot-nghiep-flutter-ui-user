import 'package:flutter/material.dart';
import 'package:flutter_t_watch/data/category_screen_data.dart';
import 'package:flutter_t_watch/data/home_page_data.dart';
import 'package:flutter_t_watch/models/CategoryProductModel.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/sub_category.dart';
import 'package:flutter_t_watch/widgets/category_product_widget.dart';
class CategoryMenTabBar extends StatelessWidget {
  List<CategoryProductModel> categoryProductModel =[];
  CategoryMenTabBar({required this.categoryProductModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: categoryProductModel.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          var data = categoryProductModel[index];
          return CategoryProductWidget(
              productImage: data.productImage,
              productName: data.productName,
              productModel: data.productModel,
              onPressed: () {
                if(index == 0){
                  PageRouting.goToNextPage(context: context, navigateTo: SubCategory(
                    productData: colothsData,
                    productModel: colothsData[index].productModel,
                    productName: categoryProductModel[index].productName,
                  ));
                }
                else if (index == 1){
                  PageRouting.goToNextPage(context: context, navigateTo: SubCategory(
                    productData: shoesData,
                    productModel: shoesData[index].productModel,
                    productName: menCategoryData[index].productName,
                  ));
                }
                else if (index == 2){
                  PageRouting.goToNextPage(context: context, navigateTo: SubCategory(
                    productData: accessoriesData,
                    productModel: accessoriesData[index].productModel,
                    productName: menCategoryData[index].productName,
                  ));
                }
                else if (index == 3){
                  PageRouting.goToNextPage(context: context, navigateTo: SubCategory(
                    productData: accessoriesData,
                    productModel: accessoriesData[index].productModel,
                    productName: categoryProductModel[index].productName,
                  ));
                }
                else if (index == 4){
                  PageRouting.goToNextPage(context: context, navigateTo: SubCategory(
                    productData: accessoriesData,
                    productModel: accessoriesData[index].productModel,
                    productName: categoryProductModel[index].productName,
                  ));
                }

              });
        });
  }
}
