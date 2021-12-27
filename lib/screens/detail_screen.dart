
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/data/detail_screen_data.dart';
import 'package:flutter_t_watch/models/SingleProductModel.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/styles/detail_screen_stylies.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/widgets/drop_button_widget.dart';
import 'package:flutter_t_watch/widgets/singleProductForDetailScreen_widget.dart';
import 'package:flutter_t_watch/widgets/singleProduct_widget.dart';

class DetailScreen extends StatefulWidget {
  final SingleProductModel data;


  DetailScreen({ required this.data});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? ratingController;
  PreferredSize buildAppBar(){
    return PreferredSize(
      preferredSize: Size.fromHeight(70),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Reebok",
          style: TextStyle(
            color: AppColors.baseBlackColor,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: SvgPicture.asset(
            SvgImages.heart,
            color: AppColors.baseBlackColor,
            width: 35,
            semanticsLabel: "Fave",
          )),
          IconButton(onPressed: () {}, icon: SvgPicture.asset(
            SvgImages.upload,
            color: AppColors.baseBlackColor,
            width: 35,
            semanticsLabel: "Fave",
          )),
        ],
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
          ListTile(
            leading: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(
                "images/Logo.png"
              ),
            ),
            title: Column(
              children: [
                Text(widget.data.productName,
                style: DetailScreenStylies.commpanyTitleStyle,),
                SizedBox(height: 5,),
                Text(widget.data.productModel,
                  style: DetailScreenStylies.productModelStyle,),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data.productPrice.toString(),
                  style: DetailScreenStylies.productPriceStyle,
                ),
                SizedBox(height: 5,),
                Text(
                  widget.data.productOldPrice.toString(),
                  style: DetailScreenStylies.productOldPriceStyle,
                ),
              ],
            ),
          ),

          Padding(padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  widget.data.productImage,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                children: [
                  Expanded(child: Container(
                    margin: EdgeInsets.only(right: 15, top: 15),
                    child: Image.network(widget.data.productSecondImage),
                  ),
                  ),
                  Expanded(child: Container(
                    margin: EdgeInsets.only(right: 15, top: 15),
                    child: Image.network(widget.data.productThirdImage),
                  ),
                  ),
                  Expanded(child: Container(
                    margin: EdgeInsets.only(right: 15, top: 15),
                    child: Image.network(widget.data.productImage),
                  ),
                  ),
                ],
              )
            ],
          ),),

          Row(
            children: [
              Expanded(child: DropButton(
                hintText: "Color",
                items: ["red", "blue", "white", "black", "pink"],
                ratringController: ratingController,
                  ))
            ],
          ),

          Padding(
            padding: EdgeInsets.all(16.0),
            child: MaterialButton(
              elevation: 0,
              height: 50,
              color: AppColors.baseDarkGreenColor,
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Text(
                "Add to Cart",
                style: DetailScreenStylies.buttonTextStyle,
              ),
              onPressed: () {},
            )
          ),

          ExpansionTile(title: Text(
            "Description",
            style: DetailScreenStylies.descriptionTextStyle
          ),
          children: [
            ListTile(
              title: Wrap(
                children: [
                  Text("this is description for this product",
                  style: TextStyle(fontSize: 16),),

                ],
              ),
            )
          ],),

          ListTile(
            leading: Text(
              "You may also like",
              style: DetailScreenStylies.youmayalsolikeTextStyle
            ),
            trailing: Text(
              "Show All",
              style: DetailScreenStylies.showAllTextStyle,
            ),
          ),

          Container(
            height: 240,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                primary: true,
                itemCount: detailScreenData.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7
                ),
                itemBuilder: (context, index) {
                  var dataDetail = detailScreenData[index];
                  return SingleProductForDetailScreenWidget(
                      productImage: dataDetail.productImage,
                      productName: dataDetail.productName,
                      productModel: dataDetail.productModel,
                      productPrice: dataDetail.productPrice,
                      productOldPrice: dataDetail.productOldPrice,
                      onPressed: () {
                        PageRouting.goToNextPage(context: context, navigateTo: DetailScreen(
                          data: dataDetail,
                        ));
                      });
                }),
          )

        ],
      ),
    );
  }
}
