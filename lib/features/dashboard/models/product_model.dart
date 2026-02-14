class ProductModel {
  final int id;
  final String name;
  final String sku;
  final double sellingPrice;
  final double costPrice;
  final int categoryId;
  final String categoryName;
  final String? imageUrl;
  final List<Modifier> modifiers;

  ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.sellingPrice,
    required this.costPrice,
    required this.categoryId,
    required this.categoryName,
    required this.modifiers,
    this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      sku: json['sku'],
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      costPrice: (json['costPrice'] as num).toDouble(),
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      imageUrl: json['imageUrl'],
      modifiers:
          (json['modifiers'] as List<dynamic>?)
              ?.map((m) => Modifier.fromJson(m))
              .toList() ??
          [],
    );
  }
}

class Modifier {
  final String id;
  final String name;
  final bool isRequired;
  final bool isMultiple;
  final List<ModifierOption> options;

  Modifier({
    required this.id,
    required this.name,
    required this.isRequired,
    required this.isMultiple,
    required this.options,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) {
    return Modifier(
      id: json['id'].toString(),
      name: json['name'],
      isRequired: json['isRequired'],
      isMultiple: json['isMultiple'],
      options:
          (json['options'] as List<dynamic>?)
              ?.map((o) => ModifierOption.fromJson(o))
              .toList() ??
          [],
    );
  }
}

class ModifierOption {
  final String id;
  final String name;
  final double priceAdjustment;

  ModifierOption({
    required this.id,
    required this.name,
    required this.priceAdjustment,
  });

  factory ModifierOption.fromJson(Map<String, dynamic> json) {
    return ModifierOption(
      id: json['id'].toString(),
      name: json['name'],
      priceAdjustment: (json['priceAdjustment'] as num).toDouble(),
    );
  }
}
