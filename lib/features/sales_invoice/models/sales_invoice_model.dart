class SalesInvoiceModel {
  final int id;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final double subTotal;
  final double discountAmount;
  final double totalAmount;

  SalesInvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.subTotal,
    required this.discountAmount,
    required this.totalAmount,
  });

  factory SalesInvoiceModel.fromJson(Map<String, dynamic> json) {
    return SalesInvoiceModel(
      id: json['id'],
      invoiceNumber: json['invoiceNumber'],
      invoiceDate: DateTime.parse(json['invoiceDate']),
      subTotal: (json['subTotal'] as num).toDouble(),
      discountAmount: (json['discount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}
