import 'package:alegria_flutter/features/dashboard/models/category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategories();
}
