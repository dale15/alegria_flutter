import 'dart:async';

import 'package:alegria_flutter/features/dashboard/data/category/category_repository.dart';
import 'package:alegria_flutter/features/dashboard/data/discount/discount_repository.dart';
import 'package:alegria_flutter/features/dashboard/data/product/product_repository.dart';
import 'package:alegria_flutter/features/dashboard/models/category_model.dart';
import 'package:alegria_flutter/features/dashboard/models/discount_model.dart';
import 'package:alegria_flutter/features/dashboard/models/product_model.dart';
import 'package:flutter/material.dart';

class DashboardViewModel extends ChangeNotifier {
  final CategoryRepository categoryRepository;
  final ProductRepository productRepository;
  final DiscountRepository discountRepository;

  DashboardViewModel(
    this.categoryRepository,
    this.productRepository,
    this.discountRepository,
  );

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  List<DiscountModel> _discounts = [];
  List<DiscountModel> get discounts => _discounts;

  int? _selectedCategoryId;
  int? get selectedCategoryId => _selectedCategoryId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  Timer? _debounce;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await categoryRepository.getCategories();
      _products = await productRepository.getProducts();
      _discounts = await discountRepository.getDiscounts();
    } catch (e) {
      debugPrint('Init error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(int? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void updateSearchProducts(String query) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _searchQuery = query;
      notifyListeners();
    });
  }

  List<ProductModel> get filteredProducts {
    return _products.where((product) {
      final matchesCategory =
          _selectedCategoryId == null ||
          product.categoryId == _selectedCategoryId;

      final matchesSearch =
          _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
