import 'package:alegria_flutter/core/api/api_service.dart';
import 'package:alegria_flutter/features/dashboard/models/discount_model.dart';

class DiscountRemoteDatasource {
  final ApiService apiService;

  DiscountRemoteDatasource(this.apiService);

  Future<List<DiscountModel>> getDiscounts() async {
    final response = await apiService.get('/api/Discounts');

    final data = (response.data as List)
        .map((e) => DiscountModel.fromJson(e))
        .where((d) => d.isActive) // 👈 IMPORTANT
        .toList();

    return data;
  }
}
