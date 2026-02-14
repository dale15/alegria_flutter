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
  double _cash = 0;

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.cartVm.subtotal;
    final discount = widget.cartVm.discountAmount;
    final total = widget.cartVm.total;
    final change = _cash - total;

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

          const SizedBox(height: 20),

          /// Cash Input (Modern)
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
              setState(() {
                _cash = double.tryParse(value) ?? 0;
              });
            },
          ),

          const SizedBox(height: 16),

          /// Change Display
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: change >= 0 ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: _buildRow(
              "Change",
              change < 0 ? 0 : change,
              valueColor: change >= 0 ? Colors.green : Colors.red,
              isBold: true,
            ),
          ),

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
              onPressed: _cash >= total ? () => _processOrder(context) : null,
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
}
