class ProductModel {
  String? id;
  String? name;
  String? description;
  double? price;
  double? priceAfterDiscount;
  double? discount;
  Category? category;

  String? subCategoryId; // from "sub_category"
  SubCategory? subCategory; // from "sub_categories"

  bool? wholeSale;
  String? image; // from "img"

  List<String>? colors;
  List<String>? size;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.priceAfterDiscount,
    this.discount,
    this.category,
    this.subCategoryId,
    this.subCategory,
    this.wholeSale,
    this.image,
    this.colors,
    this.size,
  });

  factory ProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProductModel();

    return ProductModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as dynamic?)?.toDouble(),
      priceAfterDiscount: (json['price_after_discount'] as dynamic)?.toDouble(),
      discount: (json['discount'] as dynamic?)?.toDouble(),
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      subCategoryId: json['sub_category'],
      subCategory:
          json['sub_categories'] != null ? SubCategory.fromJson(json['sub_categories']) : null,
      wholeSale: json['whole_sale'],
      image: json['img'],
      colors: json['colors'] != null ? List<String>.from(json['colors']) : [],
      size: json['size'] != null ? List<String>.from(json['size']) : [],
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
  String? name;
  String? img;

  Category({
    this.name,
    this.img,
  });

  factory Category.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Category();

    return Category(
      name: json['name'],
      img: json['img'],
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
  String? name;
  String? img;

  SubCategory({
    this.name,
    this.img,
  });

  factory SubCategory.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SubCategory();

    return SubCategory(
      name: json['name'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'img': img,
    };
  }
}
