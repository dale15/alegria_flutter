import 'package:alegria_flutter/features/sales_invoice/view_model/sales_invoice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SalesInvoiceTypeWidget extends StatelessWidget {
  final bool isRefunded;

  const SalesInvoiceTypeWidget({super.key, required this.isRefunded});

  @override
  Widget build(BuildContext context) {
    return Consumer<SalesInvoiceViewModel>(
      builder: (_, vm, __) {
        final invoices = vm.filteredInvoices.toList();

        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (invoices.isEmpty) {
          return const Center(child: Text("No records found"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: invoices.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final invoice = invoices[index];

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isRefunded ? Colors.red.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  invoice.invoiceNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  DateFormat(
                    "MMM d, yyyy • hh:mm a",
                  ).format(invoice.invoiceDate.toLocal()),
                ),
                trailing: Text(
                  "₱${invoice.totalAmount.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
