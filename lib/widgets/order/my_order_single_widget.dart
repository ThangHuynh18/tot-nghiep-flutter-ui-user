import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:intl/intl.dart';

class MyOrderSingleWidget extends StatefulWidget {
  final String id;
  final String productImage;
  final String productName;
  final String address;
  final String ward;
  final String district;
  final String city;
  final double totalPrice;
  final int totalProduct;
  final String status;
  final VoidCallback onPressed;
  MyOrderSingleWidget({
    required this.id,
    required this.productImage,
    required this.productName,
    required this.address,
    required this.ward,
    required this.district,
    required this.city,
    required this.totalPrice,
    required this.totalProduct,
    required this.status,
    required this.onPressed,
  });

  @override
  _MyOrderSingleWidgetState createState() => _MyOrderSingleWidgetState();
}

class _MyOrderSingleWidgetState extends State<MyOrderSingleWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
      height: 240,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: NetworkImage(
                                widget.productImage),
                          )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.id,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.baseBlackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          ],
                        ),
                        Text(
                          widget.productName.toUpperCase(),
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.baseBlackColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Address: ${widget.address}, ${widget.ward}, ${widget.district}, ${widget.city}",
                          style: TextStyle(
                            fontSize: 12,

                            color: AppColors.baseGrey60Color,
                          ),
                        )
                      ],
                    ),
                  ),
                ),


              ],
            ),
          ),


          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 50.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.totalProduct.toString()+" product",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.baseBlackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                          "${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(widget.totalPrice)}",
                          style: TextStyle(
                              fontSize: 15,
                              color: AppColors.baseBlackColor,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.status == "WAIT" ?
                      Text(
                        "Status: ${widget.status}",
                        style: TextStyle(
                            fontSize: 15,
                            color: AppColors.baseDarkGreenColor,
                            fontWeight: FontWeight.bold
                        ),
                      ) : widget.status == "ACCEPT" ?
                      Text(
                        "Status: ${widget.status}",
                        style: TextStyle(
                            fontSize: 15,
                            color: AppColors.baseLightCyanColor,
                            fontWeight: FontWeight.bold
                        ),
                      ) : widget.status == "CANCEL" ?
                      Text(
                        "Status: ${widget.status}",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                            fontWeight: FontWeight.bold
                        ),
                      )  : widget.status == "FINISH" ?
                      Text(
                        "Status: ${widget.status}",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold
                        ),
                      )   : SizedBox()
                      // Text(
                      //     "Button for status",
                      //     style: TextStyle(
                      //         fontSize: 15,
                      //         color: AppColors.baseBlackColor,
                      //         fontWeight: FontWeight.bold
                      //     )
                      // ),
                    ],
                  ),

                ],
              ),
            ),
          ),
          Container(
            height: 10,
            width: double.infinity,
            color: AppColors.placeholderBg,
          ),


        ],
      ),
    ),
    );
  }
}
