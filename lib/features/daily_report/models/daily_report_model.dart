class DailyReportModel {
  final double totalSales;
  final double totalTax;
  final double totalDiscount;
  final int totalTransactions;
  final List<PaymentBreakdownModel> paymentBreakdown;
  final List<TopProduct> topProducts;

  DailyReportModel({
    required this.totalSales,
    required this.totalTax,
    required this.totalDiscount,
    required this.totalTransactions,
    required this.paymentBreakdown,
    required this.topProducts,
  });

  factory DailyReportModel.fromJson(Map<String, dynamic> json) {
    return DailyReportModel(
      totalSales: (json['totalSales'] as num).toDouble(),
      totalTax: (json['totalTax'] as num).toDouble(),
      totalDiscount: (json['totalDiscount'] as num).toDouble(),
      totalTransactions: json['totalTransactions'] ?? 0,
      paymentBreakdown: (json['paymentBreakdown'] as List<dynamic>)
          .map((e) => PaymentBreakdownModel.fromJson(e))
          .toList(),
      topProducts: (json['topProducts'] as List<dynamic>)
          .map((e) => TopProduct.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalSales": totalSales,
      "totalTax": totalTax,
      "totalDiscount": totalDiscount,
      "totalTransactions": totalTransactions,
      "paymentBreakdown": paymentBreakdown.map((e) => e.toJson()).toList(),
    };
  }
}

class PaymentBreakdownModel {
  final String paymentMethod;
  final double total;

  PaymentBreakdownModel({required this.paymentMethod, required this.total});

  factory PaymentBreakdownModel.fromJson(Map<String, dynamic> json) {
    return PaymentBreakdownModel(
      paymentMethod: json['paymentMethod'] ?? '',
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"paymentMethod": paymentMethod, "total": total};
  }
}

class TopProduct {
  final String productName;
  final double totalSales;
  final int totalQuantity;

  TopProduct({
    required this.productName,
    required this.totalSales,
    required this.totalQuantity,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      productName: json['productName'],
      totalSales: (json['totalSales'] as num).toDouble(),
      totalQuantity: json['totalQuantity'],
    );
  }
}
