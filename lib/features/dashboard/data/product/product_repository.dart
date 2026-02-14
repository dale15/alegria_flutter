import 'package:alegria_flutter/features/dashboard/models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts();
}
