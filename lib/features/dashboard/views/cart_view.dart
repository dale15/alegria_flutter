import 'package:alegria_flutter/features/dashboard/models/cart_item_model.dart';
import 'package:alegria_flutter/features/dashboard/view_models/cart_view_model.dart';
import 'package:alegria_flutter/features/dashboard/view_models/dashboard_view_model.dart';
import 'package:alegria_flutter/features/dashboard/views/widget/checkout_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartVm = context.watch<CartViewModel>();

    return Scaffold(
      body: cartVm.cartItems.isEmpty
          ? Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: emptyCart(),
            )
          : Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Expanded(child: cartItemList(cartVm)),
                  cartSummary(context, cartVm),
                ],
              ),
            ),
    );
  }
}

Widget emptyCart() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shopping_cart_outlined, size: 80),
        SizedBox(height: 16),
        Text("Your cart is empty", style: TextStyle(fontSize: 18)),
      ],
    ),
  );
}

Widget cartItemList(CartViewModel cartVm) {
  return ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: cartVm.cartItems.length,
    separatorBuilder: (_, __) => const SizedBox(height: 16),
    itemBuilder: (context, index) {
      final item = cartVm.cartItems[index];

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05)),
          ],
        ),
        child: Row(
          children: [
            /// Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (item.selectedOptions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: item.selectedOptions.map<Widget>((option) {
                          return Text(
                            "${option.name} ${option.priceAdjustment > 0 ? "(₱${option.priceAdjustment.toStringAsFixed(2)})" : ""}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                  const SizedBox(height: 6),
                  Text(
                    "₱${(item.product.sellingPrice + item.extraPrice).toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            /// Quantity Stepper
            quantityStepper(item: item, cartVm: cartVm),
          ],
        ),
      );
    },
  );
}

Widget quantityStepper({
  required CartItemModel item,
  required CartViewModel cartVm,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey.shade100,
    ),
    child: Row(
      children: [
        IconButton(
          onPressed: () => cartVm.decreaseQuantity(item.product.id),
          icon: const Icon(Icons.remove),
        ),
        Text(
          item.quantity.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => cartVm.increaseQuantity(item.product.id),
          icon: const Icon(Icons.add),
        ),
      ],
    ),
  );
}

Widget cartSummary(BuildContext context, CartViewModel cartVm) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (cartVm.discountType != "none")
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cartVm.discountType == "percent"
                    ? "Discount (${cartVm.discountValue.toStringAsFixed(0)}%)"
                    : "Discount",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "- ₱${cartVm.discountAmount.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),

        summaryRow(
          label: "Total",
          value: "₱${cartVm.total.toStringAsFixed(2)}",
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<CartViewModel>(
              builder: (_, cartVm, __) {
                final hasDiscount = cartVm.hasDiscount;

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    _showDiscountDialog(context);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: hasDiscount
                          ? Colors.green.shade50
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: hasDiscount
                            ? Colors.green
                            : Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.local_offer_outlined, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "Discount",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(width: 10),

            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => cartVm.clearCart(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.delete_outline, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Clear Cart",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 241, 66, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              _showCheckout(context, cartVm);
            },
            child: const Text(
              "Checkout",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget summaryRow({required String label, required String value}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 16)),
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ],
  );
}

void _showCheckout(BuildContext context, CartViewModel cartVm) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => CheckoutSheet(cartVm: cartVm),
  );
}

void _showDiscountDialog(BuildContext context) {
  final cartVm = context.read<CartViewModel>();
  final dashboardVm = context.read<DashboardViewModel>();

  showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Discount",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              ...dashboardVm.discounts.map((discount) {
                final isSelected = cartVm.selectedDiscount == discount.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      cartVm.applyDiscount(
                        discountId: discount.id,
                        value: discount.value,
                        type: discount.type,
                      );
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: isSelected
                            ? Colors.blue.shade50
                            : Colors.grey.shade100,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_offer,
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey.shade700,
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  discount.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  discount.type == "percent"
                                      ? "${discount.value}%"
                                      : "₱${discount.value.toStringAsFixed(2)}",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),

                          if (isSelected)
                            const Icon(Icons.check_circle, color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    cartVm.clearDiscount();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.black),
                  label: const Text(
                    "Remove Discount",
                    style: TextStyle(color: Color.fromARGB(255, 241, 66, 45)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
