
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/data/home_page_data.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/detail_screen.dart';
import 'package:flutter_t_watch/screens/filter_screen.dart';
import 'package:flutter_t_watch/screens/tabbar_man.dart';
import 'package:flutter_t_watch/styles/home_screen_stylies.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/widgets/show_all_widget.dart';
import 'package:flutter_t_watch/widgets/singleProduct_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      bottom: const TabBar(
        labelPadding: EdgeInsets.symmetric(horizontal: 22),
        indicator: BoxDecoration(
          color: Colors.transparent,
        ),
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold
        ),
        unselectedLabelColor: AppColors.baseBlackColor,
        labelColor: AppColors.baseDarkPinkColor,
        tabs: [
          Text("All"),
          Text("Clothing"),
          Text("Shoes"),
          Text("Accessories"),
        ],
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0.0,
      title: Column(
        children: [
          Text("Welcome",
          style: HomeScreenStylies.appBarUpperTitleStylies,),
          Text("Shopping", style: HomeScreenStylies.appBarBottomTitleStylies,)
        ],
      ),
      actions: [
        IconButton(
            onPressed: (){
              PageRouting.goToNextPage(context: context, navigateTo: FilterScreen());
            },
            icon: RotationTransition(
            turns: AlwaysStoppedAnimation(90 / 360),
              child: SvgPicture.asset(
              SvgImages.fillter,
              color: AppColors.baseBlackColor,
              width: 30,))
        ),
        IconButton(
        onPressed: (){},
        icon: SvgPicture.asset(SvgImages.search,
        color: AppColors.baseBlackColor,
        width: 30,)
        )
      ],
    );
  }


  Widget buildAdvertisementPlace() {
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: Container(
        height: 170,
        child: Carousel(
          autoplay: true,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(microseconds: 1000),
          showIndicator: false,
          images: [
            Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage("https://photo-cms-nghenhinvietnam.zadn.vn/w700/Uploaded/2021/unvjohp/2021_08_05/pubg/gsdh_hzsh.jpg")
                ),
                borderRadius: BorderRadius.circular(10.0)
              ),
            ),
            Container(

              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage("https://asia.battlegrounds.pubg.com/wp-content/uploads/sites/6/2021/08/BPUBG_%E1%84%89%E1%85%B5%E1%86%AF%E1%84%89%E1%85%A101-1185x657.jpg")
                  ),
                  borderRadius: BorderRadius.circular(10.0)
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget buildTrendingProduct({required String productImage, required String productName, required String productModel, required double productPrice}) {
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

                buildAdvertisementPlace(),

                ShowAllWidget(leftText: "New Arrival"),
                Padding(padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                      primary: true,
                      itemCount: sigleProductData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7
                      ),
                      itemBuilder: (context, index) {
                      var data = sigleProductData[index];
                        return SingleProductWidget(
                            productImage: data.productImage,
                            productName: data.productName,
                            productModel: data.productModel,
                            productPrice: data.productPrice,
                            productOldPrice: data.productOldPrice,
                            onPressed: () {
                              PageRouting.goToNextPage(context: context, navigateTo: DetailScreen(
                                data: data,
                              ));
                            });
                      }),
                  
                ),

                Divider(
                  indent: 16,
                  endIndent: 16,
                ),
                ShowAllWidget(leftText: "Trending"),
                buildTrendingProduct(
                  productImage:
                  'https://vcdn1-giaitri.vnecdn.net/2020/11/03/lisa-3-1604394414.jpg?w=1200&h=0&q=100&dpr=1&fit=crop&s=Uzqm3erCQJd3bC_65SfkrQ',
                  productModel: 'BlackPink',
                  productName: 'Lalisa Manoban',
                  productPrice: 15,
                ),
                buildTrendingProduct(
                  productImage:
                  'https://cdnmedia.thethaovanhoa.vn/Upload/BLtvcXjb72tSqs1jiHr8g/files/2020/10/Rose-att1.jpg',
                  productModel: 'BlackPink',
                  productName: 'Rosé',
                  productPrice: 15,
                ),
                buildTrendingProduct(
                  productImage:
                  'https://i1.wp.com/www.fashionchingu.com/wp-content/uploads/2019/02/BlackPink-Jennie-White-Blouse.jpg',
                  productModel: 'BlackPink',
                  productName: 'Jennie Kim',
                  productPrice: 15,
                ),
                buildTrendingProduct(
                  productImage:
                  'https://upload.wikimedia.org/wikipedia/commons/b/b5/190919_Jisoo_attended_Cartier_Event_2.jpg',
                  productModel: 'BlackPink',
                  productName: 'Jisoo Kim',
                  productPrice: 15,
                ),
                ShowAllWidget(
                  leftText: "Your History",
                ),
                Container(
                  height: 240,
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      primary: true,
                      itemCount: sigleProductData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 1.5
                      ),
                      itemBuilder: (context, index) {
                        var data = sigleProductData[index];
                        return SingleProductWidget(
                            productImage: data.productImage,
                            productName: data.productName,
                            productModel: data.productModel,
                            productPrice: data.productPrice,
                            productOldPrice: data.productOldPrice,
                            onPressed: () {
                              PageRouting.goToNextPage(context: context, navigateTo: DetailScreen(
                                data: data,
                              ));
                            });
                      })
                ),
              ],
            ),

            // TabBarBar(
            //   productData: colothsData,
            // ),
            // TabBarBar(
            //   productData: shoesData,
            // ),
            // TabBarBar(
            //   productData: accessoriesData,
            // ),
          ],
        ),
      ),
    );
  }
}
