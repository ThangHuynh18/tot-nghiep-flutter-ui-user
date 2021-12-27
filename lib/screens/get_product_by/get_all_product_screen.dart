import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/ProductModel.dart';
import 'package:flutter_t_watch/mybottombar/my_bottom_bar.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/detail/detail_product_screen.dart';
import 'package:flutter_t_watch/screens/home/home_screen.dart';
import 'package:flutter_t_watch/styles/sub_category_stylies.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/widgets/home/home_singleProduct_widget.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({Key? key}) : super(key: key);

  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  List<DataAllProduct> listDataAll =[];
  List<Products> listProduct =[];
  List<Products> _listMore =[];

  int isSelect = 1;
  List<bool> isSelected = [true, false, false];
  FocusNode focusNodeButton1 = FocusNode();
  FocusNode focusNodeButton2 = FocusNode();
  FocusNode focusNodeButton3 = FocusNode();
  List<FocusNode> focusToggle = [];

  ScrollController _scrollController = ScrollController();
  int currentMax = 4;
  bool _isLoading = false;

  int _nextPage = 1;
  bool _loading = true;
  bool _canLoadMore = true;
  static const double _endReachedThreshold = 200;
  static const int _itemsPerPage = 6;


  Future<List<Products>> _fetchData({required int page, required int limit}) async {
    final response = await http.get(Uri.parse(
        "${AppUrl.baseUrl}/api/products/all"),
            headers: {"Accept": "application/json",
                      'connection': 'keep-alive'}
    );

    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode("[${response.body}]");
        // print("data all product api: ${data}");

        setState(() {
          for (Map<String, dynamic> i in data) {
            listDataAll.add(DataAllProduct.fromJson(i));
          }

          var result = listDataAll[0];
          listProduct = result.products;
          // for(int i = 0; i< currentMax; i++){
          //  // listProduct = result.products;
          //   listProduct.add(result.products[i]);
          // }


        });

      });
    }
    print("LIST PRODUCTS LENGTH: "+listProduct.length.toString());
    return listProduct.skip((page - 1) * limit).take(limit).toList();

  }


  @override
  void initState() {
    focusToggle = [
      focusNodeButton1,
      focusNodeButton2,
      focusNodeButton3,
    ];
    super.initState();
    _getProducts();
    _scrollController.addListener(_onScroll);
  }



  Future<void> _getProducts() async {
    _loading = true;

    final newProducts = await _fetchData(page: _nextPage, limit: _itemsPerPage);

    setState(() {
      _listMore.addAll(newProducts);

      _nextPage++;

      if (newProducts.length < _itemsPerPage) {
        _canLoadMore = false;
      }

      _loading = false;
    });
  }
  void _onScroll() {
    if (!_scrollController.hasClients || _loading) return;

    final thresholdReached = _scrollController.position.extentAfter < _endReachedThreshold;

    if (thresholdReached) {
      _getProducts();
    }
  }
  Future<void> _refresh() async {
    _canLoadMore = true;
    _listMore.clear();
    _nextPage = 1;
    await _getProducts();
  }


  @override
  void dispose() {
    focusNodeButton1.dispose();
    focusNodeButton2.dispose();
    focusNodeButton3.dispose();
    //_scrollController.dispose();
    super.dispose();
  }


  Widget buildToggleButton() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'View Mode',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        SizedBox(width: 25,),
        ToggleButtons(
          borderWidth: 0,
          focusColor: null,
          fillColor: Colors.transparent,
          selectedColor: AppColors.baseLightOrangeColor,
          disabledColor: AppColors.baseBlackColor,
          selectedBorderColor: Colors.transparent,
          borderColor: Colors.transparent,
          focusNodes: focusToggle,
          children: [
            const Icon(
              Icons.grid_view,
              size: 25,
            ),
            const Icon(
              Icons.view_agenda_outlined,
              size: 25,
            ),
            const Icon(
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
        ),

      ],
    );
  }


  AppBar buildAppBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      // actions: [
      //   IconButton(
      //     onPressed: (){},
      //     icon: RotationTransition(
      //       turns: const AlwaysStoppedAnimation(90/360),
      //       child: SvgPicture.asset(
      //         SvgImages.fillter,
      //         color: AppColors.baseBlackColor,
      //         width: 35,),
      //     ),
      //   ),
      //   IconButton(
      //     onPressed: (){},
      //     icon: SvgPicture.asset(
      //       SvgImages.search,
      //       color: AppColors.baseBlackColor,
      //       width: 35,),
      //   )
      //
      // ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:buildAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
              ),
              child: Text(
                'All Product',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.message),
            //   title: Text('Messages'),
            // ),
            // ListTile(
            //   leading: Icon(Icons.account_circle),
            //   title: Text('Profile'),
            // ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text('Settings'),
            // ),
            buildToggleButton(),
            // ListTile(
            //   leading: Icon(Icons.arrow_back),
            //   title: Text('Back To Home'),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 34),
              child: Row(
                children: [
                  IconButton( onPressed: () {
                    // Navigator.of(context).pushAndRemoveUntil(
                    //     MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);

                    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MyBottomBar(selectIndex: 0,)), (route) => false);

                  }, icon: Icon(Icons.arrow_back,),),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
                      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => MyBottomBar(selectIndex: 0,)), (route) => false);
                    },
                    child: Text(
                      "Back To Home",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.orange,
                        fontSize: 16
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        shrinkWrap: true,
        controller: _scrollController,
        slivers: <Widget>[

          CupertinoSliverRefreshControl(
            onRefresh: _refresh,
          ),
          SliverPadding(
            padding: EdgeInsets.all(8),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // childAspectRatio: 0.7,
                // crossAxisCount: 2,
                crossAxisSpacing: 3,
                mainAxisSpacing: 16,
                crossAxisCount: isSelect == 1 ? 2 : isSelect == 2 ? 1 : isSelect == 3 ? 1 : 2,
                  childAspectRatio: isSelect == 1 ? 0.7 : isSelect == 2 ? 1.5 : isSelect == 3 ? 0.8 : 0.7
              ),
              delegate: SliverChildBuilderDelegate(
                _buildProductItem,
                childCount: _listMore.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _canLoadMore
                ? Container(
                    padding: EdgeInsets.only(bottom: 16),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
            )
                : SizedBox(),
          ),
        ],
      ),
    );


    // return Scaffold(
    //   appBar: buildAppBar(),
    //   body: ListView(
    //     controller: _scrollController,
    //     children: [
    //       Padding(padding: const EdgeInsets.all(8.0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             const Text("All Product",
    //               style: SubCategoryStylies.subCategoryTitleStyle,),
    //             const SizedBox(height: 5,),
    //             Text("${listProduct.length} Products",
    //               style: SubCategoryStylies.subCategoryProductItemStyle,),
    //             const SizedBox(height: 20,),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Expanded(child: Row(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     const Icon(
    //                       Icons.list_alt_sharp,
    //                       color: AppColors.baseBlackColor,
    //                       size: 25,
    //                     ),
    //                     const SizedBox(width: 5,),
    //                     const Text("View Mode",style: SubCategoryStylies.subCategoryModelNameStyle,)
    //                   ],)),
    //                 Expanded(
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: [
    //                       buildToggleButton(),
    //                     ],
    //                   ),
    //                 )
    //               ],
    //             ),
    //
    //             const Divider(),
    //             GridView.builder(
    //                 shrinkWrap: true,
    //                 //controller: _scrollController,
    //                 //itemCount: _isLoading ? listProduct.length + 1 : listProduct.length,
    //                 itemCount: _listMore.length,
    //                 physics: const NeverScrollableScrollPhysics(),
    //                 primary: true,
    //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                     crossAxisCount: isSelect == 1 ? 2 : isSelect == 2 ? 1 : isSelect == 3 ? 1 : 2,
    //                     childAspectRatio: isSelect == 1 ? 0.7 : isSelect == 2 ? 1.5 : isSelect == 3 ? 0.8 : 0.7
    //                 ),
    //                 itemBuilder: (context, index){
    //                   // if(index == listProduct.length){
    //                   //   return CupertinoActivityIndicator();
    //                   // }
    //                   var data = _listMore[index];
    //
    //
    //                   return HomeSingleProductWidget(
    //                       id: data.sId,
    //                       productImage: data.images[0].url,
    //                       productName: data.name,
    //                       productModel: data.category.name,
    //                       productPrice: data.price.toDouble(),
    //                       qty: data.countInStock,
    //                       rating: data.rating.toDouble(),
    //                       onPressed: () {
    //                         PageRouting.goToNextPage(context: context, navigateTo: DetailProductScreen(data: data));
    //                       });
    //                 },
    //               ),
    //
    //           ],
    //         ),),
    //
    //     ],
    //   ),
    // );
  }

  Widget _buildTop() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("All Product",
                        style: SubCategoryStylies.subCategoryTitleStyle,),
                      const SizedBox(height: 5,),
                      Text("${listProduct.length} Products",
                        style: SubCategoryStylies.subCategoryProductItemStyle,),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.list_alt_sharp,
                                color: AppColors.baseBlackColor,
                                size: 25,
                              ),
                              const SizedBox(width: 5,),
                              const Text("View Mode",style: SubCategoryStylies.subCategoryModelNameStyle,)
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

                      const Divider(),
      ]
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, int index) {
    var productPrice;
    if(_listMore[index].discount >0){
      productPrice = (_listMore[index].price * (100 - _listMore[index].discount) * 0.01);
    } else {
      productPrice = _listMore[index].price.toDouble();
    }

    return HomeSingleProductWidget(
        id: _listMore[index].sId,
        productImage: _listMore[index].images[0].url,
        productName: _listMore[index].name,
        productModel: _listMore[index].category.name,
        productPrice: productPrice,
        qty: _listMore[index].countInStock,
        rating: _listMore[index].rating.toDouble(),
        onPressed: () {
          PageRouting.goToNextPage(context: context, navigateTo: DetailProductScreen(data: _listMore[index]));
        }, productOldPrice: _listMore[index].price.toDouble(), discount: _listMore[index].discount,);
  }
}
