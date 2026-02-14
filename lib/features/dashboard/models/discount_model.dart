class DiscountModel {
  final int id;
  final String name;
  final String type; // percent | fixed
  final double value;
  final bool isActive;

  DiscountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.isActive,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      value: (json['value'] as num).toDouble(),
      isActive: json['isActive'],
    );
  }
}
