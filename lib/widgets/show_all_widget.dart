import 'package:flutter/material.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/get_product_by/get_all_product_screen.dart';

class ShowAllWidget extends StatelessWidget {

  late final String leftText;
  ShowAllWidget({required this.leftText});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
              fontSize: 17,
              color: AppColors.baseBlackColor,
              fontWeight: FontWeight.bold
            ),),
            TextButton(
              onPressed: () {
                PageRouting.goToNextPage(context: context, navigateTo: AllProductScreen());
              },
              child: Text("Show All",
              style: TextStyle(
                fontSize: 17,
                color: AppColors.orange,
                fontWeight: FontWeight.bold
              ),),
            )

        ],
      ),
    );
  }
}
