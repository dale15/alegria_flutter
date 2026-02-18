class SalesInvoiceRequestModel {
  final int? discountId;
  final double? tax;
  final List<SalesInvoiceItemRequest> items;
  final List<SalesInvoicePaymentRequest> payments; // 👈 ADD THIS

  SalesInvoiceRequestModel({
    this.discountId,
    this.tax,
    required this.items,
    required this.payments,
  });

  Map<String, dynamic> toJson() => {
    "discountId": discountId,
    "tax": tax,
    "items": items.map((e) => e.toJson()).toList(),
    "payments": payments.map((e) => e.toJson()).toList(),
  };
}

class SalesInvoiceItemRequest {
  final int productId;
  final int quantity;
  final List<SalesInvoiceModifierRequest> modifiers;

  SalesInvoiceItemRequest({
    required this.productId,
    required this.quantity,
    required this.modifiers,
  });

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "quantity": quantity,
      "modifiers": modifiers.map((e) => e.toJson()).toList(),
    };
  }
}

class SalesInvoiceModifierRequest {
  final String modifierName;
  final String optionName;
  final double priceAdjustment;

  SalesInvoiceModifierRequest({
    required this.modifierName,
    required this.optionName,
    required this.priceAdjustment,
  });

  Map<String, dynamic> toJson() {
    return {
      "modifierName": modifierName,
      "optionName": optionName,
      "priceAdjustment": priceAdjustment,
    };
  }
}

class SalesInvoicePaymentRequest {
  final int paymentMethod;
  final double amount;

  SalesInvoicePaymentRequest({
    required this.paymentMethod,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    "paymentMethod": paymentMethod,
    "amount": amount,
  };
}
