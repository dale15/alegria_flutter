import 'package:alegria_flutter/features/dashboard/data/sales_invoice/sales_invoice_request_repository.dart';
import 'package:alegria_flutter/features/dashboard/models/cart_item_model.dart';
import 'package:alegria_flutter/features/dashboard/models/product_model.dart';
import 'package:alegria_flutter/features/dashboard/models/sales_invoice_request_model.dart';
import 'package:flutter/material.dart';

class CartViewModel extends ChangeNotifier {
  final SalesInvoiceRequestRepository _invoiceRepo;

  CartViewModel(this._invoiceRepo);

  final List<CartItemModel> _cartItems = [];

  List<CartItemModel> get cartItems => _cartItems;

  double _discountValue = 0;
  double get discountValue => _discountValue;

  String _discountType = "none"; // none | percent |
  String get discountType => _discountType;

  int _selectedDiscount = 0;
  int get selectedDiscount => _selectedDiscount;

  bool get hasDiscount => _discountType != "none";

  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice.toInt());

  double get subtotal {
    return _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get discountAmount {
    if (_discountType == "percent") {
      return subtotal * (_discountValue / 100);
    }

    if (_discountType == "fixed") {
      return _discountValue > subtotal ? subtotal : _discountValue;
    }

    return 0;
  }

  double get total {
    return subtotal - discountAmount;
  }

  bool _isSameModifiers(List<dynamic> a, List<dynamic> b) {
    if (a.length != b.length) return false;

    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }

    return true;
  }

  void applyDiscount({
    required int discountId,
    required double value,
    required String type,
  }) {
    _selectedDiscount = discountId;
    _discountValue = value;
    _discountType = type;
    notifyListeners();
  }

  void clearDiscount() {
    _selectedDiscount = 0;
    _discountValue = 0;
    _discountType = "none";
    notifyListeners();
  }

  void addToCart(
    ProductModel product, {
    List<dynamic>? selectedOptions,
    double extraPrice = 0,
  }) {
    selectedOptions ??= [];

    final index = _cartItems.indexWhere((item) {
      return item.product.id == product.id &&
          _isSameModifiers(item.selectedOptions, selectedOptions!);
    });

    if (index != -1) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(
        CartItemModel(
          product: product,
          selectedOptions: selectedOptions,
          extraPrice: extraPrice,
        ),
      );
    }

    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void increaseQuantity(int productId) {
    final item = _cartItems.firstWhere((item) => item.product.id == productId);

    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(int productId) {
    final item = _cartItems.firstWhere((item) => item.product.id == productId);

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _cartItems.remove(item);
    }

    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    clearDiscount();

    notifyListeners();
  }

  SalesInvoiceRequestModel buildInvoice() {
    return SalesInvoiceRequestModel(
      discountId: _selectedDiscount,
      tax: null, // or your tax logic later
      items: _cartItems.map((item) {
        return SalesInvoiceItemRequest(
          productId: item.product.id,
          quantity: item.quantity,
          modifiers: item.selectedOptions.map((option) {
            return SalesInvoiceModifierRequest(
              modifierName: option.name, // make sure exists
              optionName: option.name,
              priceAdjustment: option.priceAdjustment,
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Future<Map<String, dynamic>> createInvoice() async {
    final request = buildInvoice();

    final result = await _invoiceRepo.createSalesInvoice(request);

    clearCart();

    return result;
  }
}
