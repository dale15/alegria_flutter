import 'dart:ui';

import 'package:alegria_flutter/features/dashboard/view_models/cart_view_model.dart';
import 'package:alegria_flutter/features/dashboard/view_models/dashboard_view_model.dart';
import 'package:alegria_flutter/features/dashboard/views/widget/modifier_sheet_widget.dart';
import 'package:alegria_flutter/features/dashboard/views/widget/product_card_widget.dart';
import 'package:alegria_flutter/features/sales_invoice/views/sales_invoice_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        _buildSearchBar(context),
        _buildCategoryChips(context),
        Expanded(child: _buildProductGrid(context)),
      ],
    );
  }
}

Widget _buildHeader(BuildContext context) {
  final now = DateTime.now();
  final cartVm = context.watch<CartViewModel>();

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Alegria Bakeshop",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "${now.month}/${now.day}/${now.year}",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),

        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.receipt_long, color: Colors.black),
              tooltip: "Order History",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SalesInvoiceView()),
                );
              },
            ),

            Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartVm.totalItems > 0)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      child: Text(
                        cartVm.totalItems.toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildSearchBar(BuildContext context) {
  final vm = context.read<DashboardViewModel>();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Search product...",
        prefixIcon: const Icon(Icons.search),
        prefixIconColor: Colors.black,
        hintStyle: TextStyle(color: Colors.black),
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      onChanged: (value) {
        vm.updateSearchProducts(value);
      },
    ),
  );
}

Widget _buildCategoryChips(BuildContext context) {
  return Consumer<DashboardViewModel>(
    builder: (context, vm, child) {
      if (vm.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      return SizedBox(
        height: 60,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: vm.categories.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (_, index) {
            if (index == 0) {
              return ChoiceChip(
                backgroundColor: Colors.white,
                selectedColor: Color.fromARGB(255, 241, 66, 45),
                label: Text(
                  "All",
                  style: TextStyle(
                    color: vm.selectedCategoryId == null
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                selected: vm.selectedCategoryId == null,
                onSelected: (_) => vm.selectCategory(null),
              );
            }

            final category = vm.categories[index - 1];

            return ChoiceChip(
              backgroundColor: Colors.white,
              selectedColor: Color.fromARGB(255, 241, 66, 45),
              label: Text(
                category.name,
                style: TextStyle(
                  color: vm.selectedCategoryId == category.id
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              selected: vm.selectedCategoryId == category.id,
              onSelected: (_) => vm.selectCategory(category.id),
            );
          },
        ),
      );
    },
  );
}

Widget _buildProductGrid(BuildContext context) {
  final cartVm = context.read<CartViewModel>();
  const String baseUrl = "http://10.0.2.2:5000";

  return Consumer<DashboardViewModel>(
    builder: (_, vm, __) {
      if (vm.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (vm.filteredProducts.isEmpty) {
        return const Center(child: Text("No products found"));
      }

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vm.filteredProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (_, i) {
          final product = vm.filteredProducts[i];

          return ProductTile(
            product: product,
            onTap: () {
              if (product.modifiers.isEmpty) {
                cartVm.addToCart(product);
              } else {
                _showModifierSheet(context, product, cartVm);
              }
            },
            baseUrl: baseUrl,
          );
        },
      );
    },
  );
}

void _showModifierSheet(BuildContext context, product, CartViewModel cartVm) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return ModifierSheet(
        product: product,
        onConfirm: (selectedOptions, extraPrice) {
          cartVm.addToCart(
            product,
            selectedOptions: selectedOptions,
            extraPrice: extraPrice,
          );
          Navigator.pop(context);
        },
      );
    },
  );
}
