import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/OrderModel.dart';
import 'package:flutter_t_watch/models/UserModel.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/edit_profile_screen.dart';
import 'package:flutter_t_watch/screens/login_screen.dart';
import 'package:flutter_t_watch/screens/my_order_screen.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/util/app_url.dart';
import 'package:flutter_t_watch/widgets/outlined_button_text_widget.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:xfile/xfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //final baseUrl = "https://graduate-flutter-api.herokuapp.com";
  String token = "";
  List<Profile> users = [];
  List<dynamic> orders = [];
  bool loading = false;
  final String tabSpace = "\t\t";

  final ImagePicker _picker = ImagePicker();
  PickedFile? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();

  }

  void getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("login");
      getProfile();
      getMyOrder();
    });
  }

  Future<Null> getProfile() async {
    setState(() {
      loading = true;
    });
    print("TOKEN IS HERE: "+token);
    final response = await http.get(
        Uri.parse("${AppUrl.baseUrl}/api/users/profile"),
            headers: <String, String>{
              'Accept': 'application/json',
              'Authorization': 'Bearer $token'
            },
          );
   // print("RESPONSE: " +response.body+"===-="+response.statusCode.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode("[${response.body}]");
    //  print("data : ${data}");

      setState(() {
        for (Map<String, dynamic> i in data) {
          users.add(Profile.fromJson(i));

        }
        loading = false;

      });
    }
  }

  Future<Null> getMyOrder() async {
    final response = await http.get(
      Uri.parse("${AppUrl.baseUrl}/api/orders/myorders"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    print("RESPONSE OF MY ORDER: " +response.body+"===-="+response.statusCode.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode("${response.body}");
      final json = jsonEncode(data);
      print("data OF MY ORDER : ${json}");

      setState(() {
        orders = jsonDecode(response.body);
        print("LENGTH OF MY ORDERS: "+orders.length.toString());
        // for (Map<String, dynamic> i in data) {
        //   orders.add(Order.fromJson(i));
        //
        // }

      });
    }
  }


  void filePicker() async {
    final PickedFile? selectImage = (await _picker.getImage(source: ImageSource.gallery));
    print("IMAGE PATHl: "+selectImage!.path.toString());
    setState(() {
      image = selectImage;
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0.70,
      centerTitle: true,
      backgroundColor: AppColors.baseWhiteColor,
      title: Text(
        "Account",
        style: TextStyle(
          color: AppColors.baseBlackColor
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(SvgImages.edit,color: AppColors.baseBlackColor, width: 25,)
        )
      ],
      shadowColor: AppColors.baseGrey10Color,
    );
  }

  Widget buildListWidget({required String leading, required String trailing}) {
    return ListTile(
      tileColor: AppColors.baseWhiteColor,
      leading: Text(leading,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),),
      trailing: Text(
          trailing,
          style: TextStyle(
              fontSize: 16
          ),
        ),
    );
  }

  Widget buildBottomList({required String leading, required String trailing}) {
    return ListTile(
      onTap: () {},
      tileColor: AppColors.baseWhiteColor,
      leading: Text(
        leading,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),
      ),
      trailing: Wrap(
        spacing: 5,
        children: [
          Text(trailing, textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20
            ),),
          Icon(Icons.arrow_forward_ios_outlined,
            size: 20,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseGrey10Color,
      appBar: buildAppBar(),
      body: loading == true ? Center(child: CircularProgressIndicator(color: Colors.orange,),)
          : ListView(
        //physics: NeverScrollableScrollPhysics(),
        children: [
          // Container(
          //   height: 200,
          //   margin: EdgeInsets.only(bottom: 10),
          //   color: AppColors.baseWhiteColor,
          //   child: Padding(
          //     padding: EdgeInsets.all(20.0),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         Center(
          //           child: image == null ? Text("No image found") : Image.file(File(image!.path), width: 75, height: 75, fit: BoxFit.cover,)
          //           // CircleAvatar(
          //           //   radius: 35,
          //           //   backgroundColor: Colors.transparent,
          //           //   backgroundImage: NetworkImage("https://scontent.fsgn13-2.fna.fbcdn.net/v/t31.18172-8/28238338_2013913362183592_2795599183800582728_o.jpg?_nc_cat=106&ccb=1-5&_nc_sid=174925&_nc_ohc=OA2gYExxnosAX-i4lob&_nc_ht=scontent.fsgn13-2.fna&oh=d55bba7b3490b1f16018c5aed7b3b30b&oe=617BC974"),
          //           //
          //           // ),
          //         ),
          //         OutlinedButton(
          //             onPressed: (){filePicker();},
          //             child: const Text("Select Image"))
          //         // Text("Thang Huynh",
          //         // style: TextStyle(
          //         //   fontSize: 18,
          //         //   fontWeight: FontWeight.bold
          //         // ),),
          //         // Text("thanghuynh@gmail.com",
          //         // textAlign: TextAlign.center,)
          //       ],
          //     ),
          //   ),
          // ),

           ListView.builder(
            physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, i) {
            var x = users[i];
            return Container(
              margin: EdgeInsets.only(bottom: 20),
              color: AppColors.baseWhiteColor,
              child: Column(
                children: [
                  // Container(
                  //   height: 120,
                  //   margin: EdgeInsets.only(bottom: 5),
                  //   color: AppColors.baseWhiteColor,
                  //   child: Padding(
                  //     padding: EdgeInsets.all(20.0),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       children: [
                  //         Center(
                  //           child: CircleAvatar(
                  //             radius: 35,
                  //             backgroundColor: Colors.transparent,
                  //             backgroundImage: NetworkImage("${x.avatar}"),
                  //
                  //           ),
                  //         ),
                  //
                  //       ],
                  //     ),
                  //   ),
                  // ),


                  Container(
                      width: 40 * 4,
                      height: 40 * 4,
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: ClipOval(
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(x.avatar),
                          ))),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${x.name}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                  ),
                  Text("${x.email}",
                      style: TextStyle(
                          color: Colors.black45, fontSize: 17)),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: OutlinedButtonWithText(
                        width: 75,
                        content: "Edit",
                        onPressed: () {
                          // Navigator.of(context).pushAndRemoveUntil(
                          //     MaterialPageRoute(builder: (context) => EditProfileScreen(dataProfile: x,)), (route) => false);
                          PageRouting.goToNextPage(context: context, navigateTo: EditProfileScreen(dataProfile: x,));
                        }),
                  ),



                  // buildListWidget(
                  //     leading: "Name",
                  //     trailing: x.name
                  // ),
                  //
                  // Divider(),
                  // buildListWidget(
                  //     leading: "Email",
                  //     trailing: x.email
                  // ),

                  Divider(),
                  buildListWidget(
                      leading: "Phone",
                      trailing: x.phone
                  ),

                  Divider(),
                  ListTile(
                    tileColor: AppColors.baseWhiteColor,
                    leading: Text("Address",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),),
                    trailing: SizedBox(
                      width: 230,
                      child: Text(
                        x.shippingAddress.address + ", " +
                            x.shippingAddress.ward + ", " + x.shippingAddress.district + ", " +
                            x.shippingAddress.city,
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ),
                    ),
                  ),

                  Divider(),

                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    color: AppColors.baseWhiteColor,
                    child: Column(
                      children: [
                        buildBottomList(leading: "Wishlist", trailing: x.wishItems.length.toString()),
                        Divider(),
                        // buildBottomList(leading: "My Cart", trailing: x.cartItems.length.toString()),
                        // Divider(),
                        ListTile(
                          onTap: () {
                            PageRouting.goToNextPage(context: context, navigateTo: MyOrderScreen());
                          },
                          tileColor: AppColors.baseWhiteColor,
                          leading: Text(
                            "My Order",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          trailing: Wrap(
                            spacing: 5,
                            children: [
                              Text(orders.length.toString(), textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20
                                ),),
                              Icon(Icons.arrow_forward_ios_outlined,
                                size: 20,)
                            ],
                          ),
                        ),
                        //buildBottomList(leading: "My Order", trailing: orders.length.toString())
                      ],
                    ),
                  ),

                ],
              ),
            );
          }
        ),


          Container(
            margin: EdgeInsets.all(20.0),
            child:  MaterialButton(
              color: Colors.black,
              height: 45,
              elevation: 0,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              onPressed:() {
                // SharedPreferences pref = await SharedPreferences.getInstance();
                // await pref.clear();
                // //Navigator.popUntil(context, (route) => false);
                //
                // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
                showAlertDialog(context);
              },
              child: Text(
                "Log out",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = Row(
      children: [
        TextButton(
          child: Text("Yes"),
          onPressed: () async{
            SharedPreferences pref = await SharedPreferences.getInstance();
            await pref.clear();

            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
          },
        ),
        TextButton(
          child: Text("No"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to Logout?"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}




// ignore: must_be_immutable
class ProfileTextOption extends StatelessWidget {
  final String label;
  final String trailing;
  final IconData icon;
  final double? margin;

  ProfileTextOption(
      {Key? key, required this.label, required this.icon, required this.trailing, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: this.margin ?? 10.0), // 8.0 as default margin.
            child: ListTile(
                title: Row(
                  children: [
                    Icon(icon, color: Colors.grey, size: 24),
                    Text(label,
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
                trailing: Expanded(
                  child: Text(
                    trailing,
                    style: TextStyle(
                        fontSize: 16
                    ),
                  ),
                ),),
          ),
          Divider(height: 1, color: Colors.grey)
          // Divider(height: 1, color: HexColor.fromHex("616575"))
        ],
      ),
    );
  }
}




