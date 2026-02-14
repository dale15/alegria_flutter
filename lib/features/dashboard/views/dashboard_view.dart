import 'package:alegria_flutter/features/dashboard/views/cart_view.dart';
import 'package:alegria_flutter/features/dashboard/views/product_view.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(flex: 3, child: ProductView()),
            Expanded(flex: 2, child: CartView()),
          ],
        ),
      ),
    );
  }
}
