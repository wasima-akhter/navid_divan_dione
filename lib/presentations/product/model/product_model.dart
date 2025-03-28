class ProductModel {
  String? id;
  String? name;
  String? description;
  num? price;
  Category? category;
  bool? wholeSale;
  int? quantity;
  num? previousPrice;
  Map<String, List<String>>? variantImages;
  List<String>? banner;
  List<String>? variantColors;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.category,
    this.wholeSale,
    this.quantity,
    this.previousPrice,
    this.variantImages,
    this.banner,
    this.variantColors,
  });

  // FromJson Constructor
  factory ProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProductModel();

    return ProductModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
      wholeSale: json['whole_sale'],
      quantity: json['quantity'],
      previousPrice: json['previous_price'],
      variantImages: (json['variantImages'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key,
            value != null
                ? List<String>.from(value)
                : <String>[]),
      ),
      banner: json['banner'] != null
          ? List<String>.from(json['banner'])
          : null,
      variantColors: json['variantColors'] != null
          ? List<String>.from(json['variantColors'])
          : null,
    );
  }

  // ToJson Method
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category?.toJson(),
      'whole_sale': wholeSale,
      'quantity': quantity,
      'previous_price': previousPrice,
      'variantImages': variantImages,
      'banner': banner,
      'variantColors': variantColors,
    };
  }
}

class Category {
  String? id;
  String? name;
  String? img;

  Category({
    this.id,
    this.name,
    this.img,
  });

  // FromJson Constructor
  factory Category.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Category();

    return Category(
      id: json['_id'],
      name: json['name'],
      img: json['img'],
    );
  }

  // ToJson Method
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'img': img,
    };
  }
}