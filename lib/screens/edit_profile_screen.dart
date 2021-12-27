import 'package:flutter/material.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/models/UserModel.dart';
import 'package:flutter_t_watch/mybottombar/my_bottom_bar.dart';
import 'package:flutter_t_watch/screens/profile_screen.dart';
import 'package:flutter_t_watch/styles/signup_screen_stylies.dart';
import 'package:flutter_t_watch/widgets/edit_profile_widget.dart';

class EditProfileScreen extends StatefulWidget {
  final Profile dataProfile;
  EditProfileScreen({required this.dataProfile});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  Widget buildTopPart(){

    return Column(
        children: [
          // Container(
          //   margin: EdgeInsets.all(20.0),
          //   child:  Center(
          //     child: Text(
          //       "Edit Profile",
          //       style: SignupScreenStylies.signUpButtonTextStyle,
          //     ),
          //   ),
          // ),


          EditProfileWidget(dataProfile: widget.dataProfile,),


        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepOrangeAccent,
        // leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
        //   Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        //       MaterialPageRoute(builder: (context) => MyBottomBar(selectIndex: 4)), (route) => false);
        //
        // }),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: AppColors.baseWhiteColor,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            buildTopPart(),
          ],
        ),
      ),
      //bottomNavigationBar: MyBottomBar(),
    );
  }
}
