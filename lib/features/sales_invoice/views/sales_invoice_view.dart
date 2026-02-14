import 'package:alegria_flutter/features/sales_invoice/view_model/sales_invoice_view_model.dart';
import 'package:alegria_flutter/features/sales_invoice/views/widget/sales_invoice_type_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SalesInvoiceView extends StatefulWidget {
  const SalesInvoiceView({super.key});

  @override
  State<SalesInvoiceView> createState() => _SalesInvoiceViewState();
}

class _SalesInvoiceViewState extends State<SalesInvoiceView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    Future.microtask(
      () => context.read<SalesInvoiceViewModel>().loadInvoices(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<SalesInvoiceViewModel>(
          builder: (_, vm, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Order History"),
                Text(
                  DateFormat("MMM d, yyyy").format(vm.selectedDate),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          },
        ),
        actions: [
          Consumer<SalesInvoiceViewModel>(
            builder: (_, vm, __) {
              return IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: vm.selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );

                  if (picked != null) {
                    vm.selectDate(picked);
                  }
                },
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color.fromARGB(255, 241, 66, 45),
          indicatorColor: Color.fromARGB(255, 241, 66, 45),
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: "Orders"),
            Tab(text: "Refunded"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SalesInvoiceTypeWidget(isRefunded: false),
          SalesInvoiceTypeWidget(isRefunded: true),
        ],
      ),
    );
  }
}
