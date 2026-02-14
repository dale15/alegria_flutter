import 'package:alegria_flutter/features/dashboard/data/category/category_remote_datasource.dart';
import 'package:alegria_flutter/features/dashboard/data/category/category_repository.dart';
import 'package:alegria_flutter/features/dashboard/models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDatasource remoteDatasource;

  CategoryRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<CategoryModel>> getCategories() {
    return remoteDatasource.getCategories();
  }
}
