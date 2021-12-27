class SingleProductModel {
  final String productName;
  final String productImage;
  final String productModel;
  final double productPrice;
  final double productOldPrice;
  String productSecondImage;
  String productThirdImage;
  String productFourImage;
  SingleProductModel({
    required this.productThirdImage,
    required this.productFourImage,
    required this.productImage,
    required this.productModel,
    required this.productName,
    required this.productOldPrice,
    required this.productPrice,
    required this.productSecondImage,
  });
}