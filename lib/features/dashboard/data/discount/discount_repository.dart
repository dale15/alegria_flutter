import 'package:alegria_flutter/features/dashboard/models/discount_model.dart';

abstract class DiscountRepository {
  Future<List<DiscountModel>> getDiscounts();
}
