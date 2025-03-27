class ProductModel {
  String? sId;
  String? name;
  String? description;
  num? price; // Changed from int? to num?
  num? previousPrice; // Changed from int? to num?
  bool? wholeSale;
  int? quantity;
  VariantImages? variantImages;
  List<String>? banner;
  List<String>? variantColors;

  ProductModel({
    this.sId,
    this.name,
    this.description,
    this.price,
    this.previousPrice,
    this.wholeSale,
    this.quantity,
    this.variantImages,
    this.banner,
    this.variantColors,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      sId: json['_id'],
      name: json['name'],
      description: json['description'],
      price: _parseNumber(json['price']),
      previousPrice: _parseNumber(json['previous_price']),
      wholeSale: json['whole_sale'],
      quantity: json['quantity'],
      variantImages: json['variantImages'] != null
          ? VariantImages.fromJson(json['variantImages'])
          : null,
      banner: _parseStringList(json['banner']),
      variantColors: _parseStringList(json['variantColors']),
    );
  }

  static num? _parseNumber(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  static List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['previous_price'] = previousPrice;
    data['whole_sale'] = wholeSale;
    data['quantity'] = quantity;
    if (variantImages != null) {
      data['variantImages'] = variantImages!.toJson();
    }
    data['banner'] = banner;
    data['variantColors'] = variantColors;
    return data;
  }
}

class VariantImages {
  List<String>? red;
  List<String>? blue;

  VariantImages({this.red, this.blue});

  factory VariantImages.fromJson(Map<String, dynamic> json) {
    return VariantImages(
      red: ProductModel._parseStringList(json['red']),
      blue: ProductModel._parseStringList(json['blue']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['red'] = red;
    data['blue'] = blue;
    return data;
  }
}