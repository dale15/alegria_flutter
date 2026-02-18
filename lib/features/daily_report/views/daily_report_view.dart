import 'package:alegria_flutter/features/daily_report/view_model/daily_report_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyReportPage extends StatefulWidget {
  const DailyReportPage({super.key});

  @override
  State<DailyReportPage> createState() => _DailyReportPageState();
}

class _DailyReportPageState extends State<DailyReportPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DailyReportViewModel>().loadReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text("Daily Report"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Consumer<DailyReportViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          }

          if (vm.error != null) {
            return Center(
              child: Text(
                vm.error!,
                style: const TextStyle(color: Colors.black54),
              ),
            );
          }

          final report = vm.dailyReport;

          if (report == null) {
            return const Center(
              child: Text(
                "No report available",
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        /// Total Sales (Minimal Highlight)
                        Text(
                          "Total Sales",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "₱${report.totalSales.toStringAsFixed(2)}",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${report.totalTransactions} transactions",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 20.0),

                    Column(
                      children: [
                        if (report.topProducts.isNotEmpty) ...[
                          Text(
                            "Top Product",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            report.topProducts.first.productName,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "₱${report.topProducts.first.totalSales.toStringAsFixed(2)} • "
                            "${report.topProducts.first.totalQuantity} sold",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                const Divider(height: 1),

                const SizedBox(height: 24),

                /// Overview Section
                _sectionTitle("Overview"),
                const SizedBox(height: 16),

                _buildRow("Tax", report.totalTax),
                _buildRow("Discount", report.totalDiscount),

                const SizedBox(height: 32),

                const Divider(height: 1),

                const SizedBox(height: 24),

                /// Payment Breakdown
                _sectionTitle("Payment Breakdown"),
                const SizedBox(height: 16),

                ...report.paymentBreakdown.map(
                  (p) => _buildRow(p.paymentMethod, p.total),
                ),

                const SizedBox(height: 32),
                const Divider(height: 1),
                const SizedBox(height: 24),

                /// Top Products
                // _sectionTitle("Top Products"),
                // const SizedBox(height: 16),

                // if (report.topProducts.isEmpty)
                //   const Text(
                //     "No products sold today",
                //     style: TextStyle(color: Colors.black45),
                //   )
                // else
                //   ...report.topProducts.asMap().entries.map((entry) {
                //     final index = entry.key;
                //     final product = entry.value;

                //     return _buildTopProductRow(
                //       rank: index + 1,
                //       name: product.productName,
                //       quantity: product.totalQuantity,
                //       total: product.totalSales,
                //     );
                //   }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          Text(
            "₱${value.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProductRow({
    required int rank,
    required String name,
    required int quantity,
    required double total,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Ranking number
          SizedBox(
            width: 24,
            child: Text(
              "$rank.",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),

          /// Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$quantity sold",
                  style: const TextStyle(fontSize: 13, color: Colors.black45),
                ),
              ],
            ),
          ),

          /// Total sales
          Text(
            "₱${total.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
