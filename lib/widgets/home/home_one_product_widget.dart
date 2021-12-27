import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:flutter_t_watch/appColors/app_colors.dart';
import 'package:intl/intl.dart';

class HomeOneProductWidget extends StatelessWidget {
  final String id;
  final String productImage;
  final String productName;
  final String productModel;
  final double productPrice;
  final int qty;
  final VoidCallback onPressed;
  final VoidCallback addToCart;

  HomeOneProductWidget({
    required this.id,
    required this.productImage,
    required this.productName,
    required this.productModel,
    required this.productPrice,
    required this.qty,
    required this.onPressed,
    required this.addToCart,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 250,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.transparent,
                child: img.Image.network(
                  productImage,
                  // fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    productName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    productModel,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.baseDarkPinkColor,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "\$ ${NumberFormat.currency(locale: 'vi', symbol: 'đ').format(productPrice)}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Quantity: ${qty}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5,),


                      // ButtonBar(
                      //   alignment: MainAxisAlignment.spaceBetween,
                      //   buttonPadding: EdgeInsets.zero,
                      //   buttonHeight: 20,
                      //   buttonMinWidth: 20,
                      //   children: [
                      //     AddToCart(product: widget),
                      //   ],
                      // ).pOnly(left: 8.0,right: 8.0, bottom: 8.0,top: 8.0)
                    ],

                  ),
                  Container(
                    color: AppColors.baseGrey10Color,
                    //width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 23),
                    child: MaterialButton(
                      color: Colors.black,
                      height: 25,
                      elevation: 0,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      onPressed:
                      addToCart,

                      child: Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}







// class HomeOneProductWidget extends StatefulWidget {
//   final String id;
//   final String productImage;
//   final String productName;
//   final String productModel;
//   final double productPrice;
//   final int qty;
//   final Function onPressed;
//   final Function addToCart;
//
//   HomeOneProductWidget({
//     required this.id,
//     required this.productImage,
//     required this.productName,
//     required this.productModel,
//     required this.productPrice,
//     required this.qty,
//     required this.onPressed,
//     required this.addToCart,
//   });
//
//   @override
//   _HomeOneProductWidgetState createState() => _HomeOneProductWidgetState();
// }
//
// class _HomeOneProductWidgetState extends State<HomeOneProductWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onPressed(),
//       child: Container(
//         height: 250,
//         margin: EdgeInsets.all(10.0),
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 color: Colors.transparent,
//                 child: img.Image.network(
//                   widget.productImage,
//                   // fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     widget.productName,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     widget.productModel,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       color: AppColors.baseDarkPinkColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         "\$ ${widget.productPrice}",
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         width: 15,
//                       ),
//                       Text(
//                         "Quantity: ${widget.qty}",
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 5,),
//
//
//                       // ButtonBar(
//                       //   alignment: MainAxisAlignment.spaceBetween,
//                       //   buttonPadding: EdgeInsets.zero,
//                       //   buttonHeight: 20,
//                       //   buttonMinWidth: 20,
//                       //   children: [
//                       //     AddToCart(product: widget),
//                       //   ],
//                       // ).pOnly(left: 8.0,right: 8.0, bottom: 8.0,top: 8.0)
//                     ],
//
//                   ),
//                   Container(
//                     color: AppColors.baseGrey10Color,
//                     //width: double.infinity,
//                     margin: EdgeInsets.symmetric(horizontal: 23),
//                     child: MaterialButton(
//                       color: Colors.black,
//                       height: 25,
//                       elevation: 0,
//                       shape: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide: BorderSide.none,
//                       ),
//                       onPressed: () {
//                         widget.addToCart();
//                       },
//                       child: Text(
//                         "Add to Cart",
//                         style: TextStyle(
//                           fontSize: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
