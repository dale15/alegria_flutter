import 'package:flutter/material.dart';

class ModifierSheet extends StatefulWidget {
  final dynamic product;
  final Function(List<dynamic> selectedOptions, double extraPrice) onConfirm;

  const ModifierSheet({
    super.key,
    required this.product,
    required this.onConfirm,
  });

  @override
  State<ModifierSheet> createState() => _ModifierSheetState();
}

class _ModifierSheetState extends State<ModifierSheet> {
  final Map<String, dynamic> _selectedOptions = {};
  double _extraPrice = 0;

  @override
  Widget build(BuildContext context) {
    final modifiers = widget.product.modifiers;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Drag Handle
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          width: 40,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        /// Product Name
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(height: 20),

        /// Modifier List
        SizedBox(
          height: 250,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: modifiers
                .map<Widget>((modifier) => _buildModifierSection(modifier))
                .toList(),
          ),
        ),

        /// Bottom Confirm Bar
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 241, 66, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                widget.onConfirm(_selectedOptions.values.toList(), _extraPrice);
              },
              child: Text(
                "Add to Cart (+ ₱${_extraPrice.toStringAsFixed(2)})",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModifierSection(dynamic modifier) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              modifier.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            ...modifier.options.map<Widget>((option) {
              final isSelected = _selectedOptions[modifier.id] == option;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOptions[modifier.id] = option;

                    _extraPrice = 0;
                    for (var opt in _selectedOptions.values) {
                      _extraPrice += opt.priceAdjustment;
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(option.name),

                      if (option.priceAdjustment > 0)
                        Text(
                          "+ ₱${option.priceAdjustment.toStringAsFixed(2)}",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),

                      if (isSelected)
                        const Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
