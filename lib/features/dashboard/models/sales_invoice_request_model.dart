class SalesInvoiceRequestModel {
  final int? discountId;
  final double? tax;
  final List<SalesInvoiceItemRequest> items;

  SalesInvoiceRequestModel({this.discountId, this.tax, required this.items});

  Map<String, dynamic> toJson() {
    return {
      "discountId": discountId,
      "tax": tax,
      "items": items.map((e) => e.toJson()).toList(),
    };
  }
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
