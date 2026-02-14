import 'package:alegria_flutter/features/dashboard/data/discount/discount_remote_datasource.dart';
import 'package:alegria_flutter/features/dashboard/data/discount/discount_repository.dart';
import 'package:alegria_flutter/features/dashboard/models/discount_model.dart';

class DiscountRepositoryImpl implements DiscountRepository {
  final DiscountRemoteDatasource remoteDatasource;

  DiscountRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<DiscountModel>> getDiscounts() {
    return remoteDatasource.getDiscounts();
  }
}
