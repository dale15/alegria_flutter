import 'package:alegria_flutter/core/api/api_service.dart';
import 'package:alegria_flutter/features/dashboard/models/category_model.dart';

class CategoryRemoteDatasource {
  final ApiService _apiService;

  CategoryRemoteDatasource(this._apiService);

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiService.get('/api/Categories');

    final data = response.data;

    if (data is List) {
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    }

    throw Exception('Unexpected API response: $data');
  }
}
