class ProductModel {
  String id;
  String name;
  String description;
  double price;
  double priceAfterDiscount;
  double discount;

  Category? category;
  SubCategory? subCategory;

  String subCategoryId;
  bool wholeSale;
  String image;

  List<String> colors;
  List<String> size;

  ProductModel({
    this.id = '',
    this.name = '',
    this.description = '',
    this.price = 0.0,
    this.priceAfterDiscount = 0.0,
    this.discount = 0.0,
    this.category,
    this.subCategory,
    this.subCategoryId = '',
    this.wholeSale = false,
    this.image = '',
    this.colors = const [],
    this.size = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProductModel();

    return ProductModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      priceAfterDiscount:
          (json['price_after_discount'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] is Map<String, dynamic>
          ? Category.fromJson(json['category'])
          : null,
      subCategory: json['sub_categories'] is Map<String, dynamic>
          ? SubCategory.fromJson(json['sub_categories'])
          : null,
      subCategoryId: json['sub_category'] is String
          ? json['sub_category']
          : json['sub_category']?['_id']?.toString() ?? '',
      wholeSale: json['whole_sale'] ?? false,
      image: json['img']?.toString() ?? '',
      colors: (json['colors'] is List)
          ? (json['colors'] as List)
              .whereType<dynamic>()
              .map((e) => e.toString())
              .toList()
          : [],
      size: (json['size'] is List)
          ? (json['size'] as List)
              .whereType<dynamic>()
              .map((e) => e.toString())
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'price_after_discount': priceAfterDiscount,
      'discount': discount,
      'category': category?.toJson(),
      'sub_category': subCategoryId,
      'sub_categories': subCategory?.toJson(),
      'whole_sale': wholeSale,
      'img': image,
      'colors': colors,
      'size': size,
    };
  }
}

class Category {
  String name;
  String img;

  Category({
    this.name = '',
    this.img = '',
  });

  factory Category.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Category();

    return Category(
      name: json['name']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'img': img,
    };
  }
}

class SubCategory {
  String name;
  String img;

  SubCategory({
    this.name = '',
    this.img = '',
  });

  factory SubCategory.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SubCategory();

    return SubCategory(
      name: json['name']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'img': img,
    };
  }
}
