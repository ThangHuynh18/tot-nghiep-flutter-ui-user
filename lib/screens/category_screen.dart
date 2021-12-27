import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/data/category_screen_data.dart';
import 'package:flutter_t_watch/screens/category_all_tabbar.dart';
import 'package:flutter_t_watch/screens/category_men_tabbar.dart';
import 'package:flutter_t_watch/styles/category_screen_stylies.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/widgets/category_product_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text("Welcome", style: CategoryScreenStylies.categoryAppBarTitleStyle,),
      actions: [
        RotationTransition(
          turns: AlwaysStoppedAnimation(90/360),
          child: IconButton(
            onPressed: () {},
            icon:SvgPicture.asset(
              SvgImages.fillter,
              color: AppColors.baseBlackColor,
              width: 35,),
          ),
        ),
        IconButton(
          icon: SvgPicture.asset(SvgImages.search,
            color: AppColors.baseBlackColor,
            width: 35,),
          onPressed: () {},
        )
      ],
      bottom: TabBar(
        indicator: BoxDecoration(color: Colors.transparent),
        labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600
        ),
        unselectedLabelColor: AppColors.baseBlackColor,
        labelColor: AppColors.baseDarkPinkColor,
        automaticIndicatorColorAdjustment: false,
        tabs: [
          Text("All"),
          Text("Men"),
          Text("Woman"),
          Text("Kid")
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.baseWhiteColor,
        appBar: buildAppBar(),
        body: TabBarView(
          children: [
            //all
            CategoryAllTabBar(),

            //men
            CategoryMenTabBar(
              categoryProductModel: menCategoryData,
            ),

            //woman
            CategoryMenTabBar(
              categoryProductModel: womenCategoryData,
            ),

            //kid
            CategoryMenTabBar(
              categoryProductModel: forKids,
            ),
          ],
        ),
      ),
    );
  }
}
