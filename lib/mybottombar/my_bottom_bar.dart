import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/CartItemModel.dart';
import 'package:flutter_t_watch/screens/category_screen.dart';
import 'package:flutter_t_watch/screens/home/home_screen.dart';
import 'package:flutter_t_watch/screens/home/home_screen_bloc.dart';
import 'package:flutter_t_watch/screens/home_page.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:custom_navigator/custom_scaffold.dart';
import 'package:flutter_t_watch/screens/profile_screen.dart';
import 'package:flutter_t_watch/screens/voucher_screen.dart';
import 'package:flutter_t_watch/screens/wish_list_screen.dart';
import 'package:flutter_t_watch/screens/your_bag_screen.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has four [BottomNavigationBarItem]
// widgets, which means it defaults to [BottomNavigationBarType.shifting], and
// the [currentIndex] is set to index 0. The selected item is amber in color.
// With each [BottomNavigationBarItem] widget, backgroundColor property is
// also defined, which changes the background color of [BottomNavigationBar],
// when that item is selected. The `_onItemTapped` function changes the
// selected item's index and displays a corresponding message in the center of
// the [Scaffold].


/// This is the stateful widget that the main application instantiates.
class MyBottomBar extends StatefulWidget {
   int selectIndex;
  MyBottomBar({required this.selectIndex});
  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

/// This is the private State class that goes with MyBottomBar.
class _MyBottomBarState extends State<MyBottomBar> {
  int _selectedIndex = 0;
  String token = "";
  List<CartItem> items = [];
  List<Data> listItem = [];
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    //HomeScreenBloc(),
    //CategoryScreen(),
    YourBagScreen(),
    WishListScreen(),
    ProfileScreen(),
    VoucherScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.selectIndex = index;

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.selectIndex;
    print("+++++++ widget select index: "+widget.selectIndex.toString());
    print("=============selected index: "+_selectedIndex.toString());
   // getToken();
  }


  void getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("login");
      getList();
    });
  }


  Future<Null> getList() async {
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

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.orange[300]!,
              hoverColor: Colors.orange[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.deepOrangeAccent,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.shoppingCart,
                  text: 'Cart',
                ),
                GButton(
                  icon: LineIcons.heart,
                  text: 'Likes',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
                GButton(
                  icon: LineIcons.wallet,
                  text: 'Voucher',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                  widget.selectIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );


    // return CustomScaffold(
    //   children: _widgetOptions,
    //   onItemTap: _onItemTapped,
    //   scaffold: Scaffold(
    //
    //     body: Center(
    //       child: _widgetOptions.elementAt(_selectedIndex),
    //     ),
    //     bottomNavigationBar: BottomNavigationBar(
    //       //backgroundColor: Colors.orange,
    //       showSelectedLabels: false,
    //       showUnselectedLabels: false,
    //       type: BottomNavigationBarType.fixed,
    //       unselectedItemColor: AppColors.baseGrey40Color,
    //       items: const <BottomNavigationBarItem>[
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.home),
    //           label: '',
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.grid_view),
    //           label: '',
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.shopping_cart_outlined),
    //           label: '',
    //
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.favorite_border),
    //           label: '',
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.person),
    //           label: '',
    //         ),
    //       ],
    //       currentIndex: _selectedIndex,
    //       selectedIconTheme: IconThemeData(
    //         color: AppColors.baseDarkOrangeColor,
    //       ),
    //       // selectedItemColor: AppColors.baseDarkPinkColor,
    //       onTap: _onItemTapped,
    //     ),
    //   ),
    // );
  }
}