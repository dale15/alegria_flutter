import 'package:alegria_flutter/features/dashboard/view_models/cart_view_model.dart';
import 'package:flutter/material.dart';

class CheckoutSheet extends StatefulWidget {
  final CartViewModel cartVm;

  const CheckoutSheet({super.key, required this.cartVm});

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  final TextEditingController _cashController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.cartVm.subtotal;
    final discount = widget.cartVm.discountAmount;
    final total = widget.cartVm.total;
    final change = widget.cartVm.change;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          const Text(
            "Checkout",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          /// Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildRow("Subtotal", subtotal),

                if (discount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _buildRow(
                      "Discount",
                      -discount,
                      valueColor: Colors.green,
                    ),
                  ),

                const Divider(height: 24),

                _buildRow("Total", total, isBold: true, fontSize: 18),
              ],
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Payment Method",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildPaymentButton(PaymentMethod.cash, "💵 Cash"),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildPaymentButton(PaymentMethod.gcash, "📱 GCash"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Cash Input (Modern)
          if (widget.cartVm.selectedPayment == PaymentMethod.cash) ...[
            const SizedBox(height: 20),

            TextField(
              controller: _cashController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Cash Received",
                prefixText: "₱ ",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                widget.cartVm.cashReceived = double.tryParse(value) ?? 0;
                setState(() {});
              },
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: widget.cartVm.change >= 0
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: _buildRow(
                "Change",
                widget.cartVm.change < 0 ? 0 : widget.cartVm.change,
                valueColor: widget.cartVm.change >= 0
                    ? Colors.green
                    : Colors.red,
                isBold: true,
              ),
            ),
          ],

          const SizedBox(height: 20),

          /// Confirm Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 241, 66, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: widget.cartVm.cashReceived >= total
                  ? () => _processOrder(context)
                  : null,
              child: const Text(
                "Confirm Payment",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    double value, {
    bool isBold = false,
    double fontSize = 14,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
        Text(
          "₱${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Future<void> _processOrder(BuildContext context) async {
    try {
      final result = await widget.cartVm.createInvoice();

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invoice: ${result['invoiceNumber']}")),
      );
    } catch (e) {
      debugPrint("Order failed: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Order failed: $e")));
    }
  }

  Widget _buildPaymentButton(PaymentMethod method, String label) {
    final isSelected = widget.cartVm.selectedPayment == method;

    return GestureDetector(
      onTap: () {
        widget.cartVm.selectedPayment = method;
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 241, 66, 45)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
