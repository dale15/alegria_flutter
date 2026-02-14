import 'package:alegria_flutter/core/api/api_service.dart';
import 'package:alegria_flutter/features/dashboard/models/product_model.dart';

class ProductRemoteDatasource {
  final ApiService apiService;

  ProductRemoteDatasource(this.apiService);

  Future<List<ProductModel>> getProducts() async {
    final response = await apiService.get('/api/Products');

    final data = response.data;

    print(data);

    if (data is List) {
      return data.map((json) => ProductModel.fromJson(json)).toList();
    }

    throw Exception('Unexpected API response: $data');
  }
}
