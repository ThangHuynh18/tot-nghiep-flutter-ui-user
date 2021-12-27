import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/VoucherModel.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/widgets/slidable_widget.dart';
import 'package:flutter_t_watch/widgets/voucher_single_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({Key? key}) : super(key: key);

  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {

  bool loading = false;


  List<Voucher> vouchersFiltered = [];
  List<Voucher> vouchers = [];
  Future<Null> getVoucher() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/api/vouchers/discount"),
        headers: {"Accept": "application/json",
          'connection': 'keep-alive'});

    if (response.statusCode == 200) {
      final data = jsonDecode("${response.body}");

      setState(() {
        for (Map<String, dynamic> i in data) {
          vouchers.add(Voucher.fromJson(i));
        }
        loading = false;
      });
    }
  }


  Future<void> addVoucher(String discountName) async {
    var response = await http.post(Uri.parse("${AppUrl.baseUrl}/api/users/voucher/add"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          "id": discountName
          // "name": discountName
        }
        ));
    if(response.statusCode == 201) {
      EasyLoading.showSuccess('Added Voucher');
    } else if(response.statusCode == 400) {
      EasyLoading.showError('You already have this voucher');
    } else {
      print("stt code voucher: "+response.statusCode.toString());
      print("err: "+response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Add Voucher Fail"),));
    }
  }


  String token = "";
  void getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("login")!;

    });
  }


  @override
  void initState() {
    super.initState();

    vouchersFiltered = vouchers;
    getVoucher();
    getToken();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text("Vouchers",
          style: TextStyle(
              fontSize: 20,
              color: AppColors.baseWhiteColor,
              fontWeight: FontWeight.bold
          ),),
        // leading: IconButton(icon: Icon(Icons.arrow_back),
        //     onPressed: () {
        //       // Get.to(() => Timeline());
        //       Navigator.of(context).pushAndRemoveUntil(
        //           MaterialPageRoute(builder: (context) => Timeline()), (
        //           route) => false);
        //     }),
        // title:  ListTile(
        //   leading: Icon(Icons.search, color: Colors.white,),
        //   title: TextField(
        //       style: TextStyle(color: Colors.white),
        //       controller: controller,
        //       decoration: const InputDecoration(
        //           hintText: 'Search vocuher name...', border: InputBorder.none, hintStyle: TextStyle(color: Colors.white)),
        //       onChanged: (value) {
        //         setState(() {
        //           _searchResult = value;
        //
        //           vouchersFiltered = vouchers.where((voucher) => voucher.name.contains(
        //               _searchResult))
        //               .toList();
        //         });
        //       }),
        //   trailing:  IconButton(
        //     icon:  Icon(Icons.cancel, color: Colors.grey,),
        //     onPressed: () {
        //       setState(() {
        //         controller.clear();
        //         _searchResult = '';
        //         vouchersFiltered = vouchers;
        //       });
        //     },
        //   ),
        // ),

      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              //color: Colors.,
              child: Column(
                children: [
                  const SizedBox(height: 5,),
                  const Text("Swipe the voucher to left to add voucher to your wallet",
                    style: TextStyle(
                      color: AppColors.baseGrey60Color,
                    ),),
                  const SizedBox(height: 3,),

                  vouchers.isEmpty && loading == true ?
                  Center(child: CircularProgressIndicator(color: Colors.orange,))
                      :
                  vouchers.isEmpty ?
                  const Padding(
                    padding: EdgeInsets.only(top: 23.0),
                    child: Center(child: Text("No voucher", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),)),
                  ) :
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: true,
                    itemCount: vouchers.length,
                    itemBuilder: (context, index) {
                      var item = vouchers[index];


                      return SlidableVoucherWidget(
                          onDismissed: (action) =>
                          dismissSlidableItem(context, action, item.sId),
                      child: VoucherSingleWidget(
                          name: item.name, discount: item.discount.toString(),
                        )
                      );

                    }, separatorBuilder: (context, index) => Divider(),
                  ),

                ],
              ),
            ),
          ),


        ],
      ),
    );
  }


  void dismissSlidableItem(BuildContext context, SlidableVoucherAction action, String name) {
    switch (action) {
      case SlidableVoucherAction.add:
        addVoucher(name);
        break;
    }
  }

}
