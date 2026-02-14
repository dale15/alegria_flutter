import 'package:alegria_flutter/features/dashboard/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final List<dynamic> selectedOptions;
  final double extraPrice;
  int quantity;

  CartItemModel({
    required this.product,
    this.selectedOptions = const [],
    this.extraPrice = 0,
    this.quantity = 1,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.parse(json['quantity'].toString()),
    );
  }

  double get totalPrice => (product.sellingPrice + extraPrice) * quantity;
}
