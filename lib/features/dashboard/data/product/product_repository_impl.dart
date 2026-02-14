import 'package:alegria_flutter/features/dashboard/data/product/product_remote_datasource.dart';
import 'package:alegria_flutter/features/dashboard/data/product/product_repository.dart';
import 'package:alegria_flutter/features/dashboard/models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDatasource;

  ProductRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<ProductModel>> getProducts() {
    return remoteDatasource.getProducts();
  }
}
