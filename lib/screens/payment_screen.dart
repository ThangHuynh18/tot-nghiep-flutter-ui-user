import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:flutter_t_watch/routes/routes.dart';
import 'package:flutter_t_watch/screens/confirmation_screen.dart';
import 'package:flutter_t_watch/svgimages/svg_images.dart';
import 'package:flutter_t_watch/widgets/my_textfromfield_widget.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  AppBar buildAppBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(SvgImages.plus,
          color: AppColors.baseBlackColor,
          width: 40,)
        ),
        IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(SvgImages.delete,
              color: AppColors.baseBlackColor,
              width: 25,)
        ),
      ],
    );
  }


  Widget buildTextField({required double leftPadding, required double rightPadding, required String hintText}){
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 20, left: leftPadding, right: rightPadding),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: Colors.grey[100],
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)
          )
        ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Payment",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 5,),
                    Text("Order number is 432412313",
                      style: TextStyle(
                          fontSize: 10,
                         color: AppColors.baseGrey50Color
                      ),),
                  ],
                ),
              ),
              Divider(),
              Container(
                height: 180,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: SweepGradient(
                    center: AlignmentDirectional(1, -1),
                    startAngle: 1.7,
                    endAngle: 3,
                      colors: const <Color>[
                        Color(0xff148535),
                        Color(0xff148535),
                        Color(0xff0D6630),
                        Color(0xff0D6630),
                        Color(0xff148535),
                        Color(0xff148535),
                      ],
                      stops: const <double>[
                        0.0,
                        0.3,
                        0.3,
                        0.7,
                        0.7,
                        1.0
                      ]
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Paypal",
                          style: TextStyle(
                            fontSize: 24.30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.baseWhiteColor
                          ),
                        ),
                        Text(
                          "paypal electron",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.baseWhiteColor
                          ),
                        )
                      ],
                    ),
                    Text("****  ****  ****  **** 1811",
                        style: TextStyle(
                            fontSize: 24.30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.baseWhiteColor
                        ),),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Card holder",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.baseWhiteColor
                                  ),),
                                  SizedBox(height: 5,),
                                  Text("Thang Huynh",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.baseWhiteColor
                                    ),),

                                ],
                              ),
                            ),

                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Expries",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.baseWhiteColor
                                      ),),
                                    SizedBox(height: 5,),
                                    Text("05/23",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.baseWhiteColor
                                      ),),

                                  ],
                                ),
                              ),

                            Expanded(child: Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor: AppColors.baseLightGreenColor,
                                child: Icon(
                                  Icons.check,
                                  color: AppColors.baseWhiteColor,
                                ),
                              ),
                            ))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),

              MyTextFromField(hintText: "Card holder", obscureText: false),
              MyTextFromField(hintText: "Card number", obscureText: false),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      hintText: "Exp",
                      leftPadding: 20,
                      rightPadding: 0
                    ),
                  ),
                  Expanded(
                    child: buildTextField(
                        hintText: "CVV",
                        leftPadding: 3,
                        rightPadding: 10
                    ),),
                    Expanded(
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(right: 20),
                        child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              primary: AppColors.baseLightOrangeColor,
                              onSurface: Colors.grey
                            ),
                            icon: SvgPicture.asset(SvgImages.plus,
                            color: AppColors.baseWhiteColor,
                            width: 20,),
                            label: Text(
                              "Add",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.baseWhiteColor
                              ),
                            )),
                      ),
                    ),

                ],
              ),

              SizedBox(
                height: 10,
              ),
              ListTile(
                tileColor: AppColors.baseGrey10Color,
                title: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order amount",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.baseBlackColor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        "Your total amount of discount",
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.baseBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$181.19",
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.baseBlackColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 2,),
                      Text(
                        "\$-23.05",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.baseBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                color: AppColors.baseGrey10Color,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 23),
                child: MaterialButton(
                  color: Colors.black,
                  height: 45,
                  elevation: 0,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                  onPressed:(){
                    //PageRouting.goToNextPage(context: context, navigateTo: ConfirmationScreen());
                  },
                  child: Text(
                    "Confirmation",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
