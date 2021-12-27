import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/mybottombar/my_bottom_bar.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/home/home_screen.dart';
import 'package:flutter_t_watch/screens/home_page.dart';
import 'package:flutter_t_watch/screens/payment_screen.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/util/helper.dart';

class ConfirmationSuccessScreen extends StatelessWidget {
  const ConfirmationSuccessScreen({Key? key}) : super(key: key);

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Text("Success",
      style: TextStyle(
        color: AppColors.baseBlackColor
      ),),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyBottomBar(selectIndex: 0)), (Route<dynamic> route) => false);
          },
          icon: SvgPicture.asset(SvgImages.close,
          width: 30,
          color: AppColors.baseBlackColor,),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   height: 200,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Column(
          //             children: [
          //               Text(
          //                 "Congratulations",
          //                 style: TextStyle(
          //                     fontSize: 25,
          //                     fontWeight: FontWeight.bold,
          //                     color: AppColors.baseBlackColor
          //                 ),
          //               ),
          //               Text(
          //                 "Your order is accepted",
          //                 style: TextStyle(
          //                     fontSize: 25,
          //                     fontWeight: FontWeight.bold,
          //                     color: AppColors.baseBlackColor
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Column(
          //             children: [
          //               Text(
          //                 "Your items are on the way",
          //                 style: TextStyle(
          //                     color: AppColors.baseGrey50Color
          //                 ),
          //               ),
          //               Text(
          //                 "and should arrive shortly",
          //                 style: TextStyle(
          //                     color: AppColors.baseGrey50Color
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       )
          //     ],
          //   ),
          // ),


          Image.asset(
            "./images/virtual/vector4.png"
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Thank You!",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "for your order",
            style: Helper.getTheme(context)
                .headline4
                ?.copyWith(color: AppColors.primary),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0),
            child: Text(
                "Your order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your order"),
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyBottomBar(selectIndex: 0)), (Route<dynamic> route) => false);
                },
                child: Text("Back To Home"),
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 20,
          //   ),
          //   child: TextButton(
          //     onPressed: () {
          //       PageRouting.goToNextPage(context: context, navigateTo: HomeScreen());
          //     },
          //     child: const Text(
          //       "Back To Home",
          //       style: TextStyle(
          //         color: AppColors.primary,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),


          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //   child: MaterialButton(
          //     color: Colors.black,
          //     height: 45,
          //     elevation: 0,
          //     shape: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5),
          //       borderSide: BorderSide.none,
          //     ),
          //     onPressed:(){
          //       PageRouting.goToNextPage(context: context, navigateTo: HomeScreen());
          //     },
          //     child: Text(
          //       "Back to Home",
          //       style: TextStyle(
          //         fontSize: 20,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
