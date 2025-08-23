import 'package:navid_e_commerce/presentations/home/model/category_model.dart';

class ProductModel {
  String? id;
  String? name;
  String? description;
  num? price;
  Category? category;
 // SubCategoryModel? subCategory; // ✅ new field
  bool? wholeSale;
  int? quantity;
  num? previousPrice;
  Map<String, VariantData>? variantImages;
  List<String>? banner;
  List<String>? variantColors;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.category,
    // this.subCategory,
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
      // subCategory: subCategory is SubCategoryModel? json['sub_category']!= null
      //     ? SubCategory.fromJson(json['sub_category'])
      //     : null:json['sub_category'],
      wholeSale: json['whole_sale'],
      quantity: json['quantity'],
      previousPrice: json['previous_price'],
      variantImages: (json['variantImages'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
          key,
              value is Map<String, dynamic>
                  ? VariantData.fromJson(value)
                  : VariantData(),
        ),
      ),
      banner: json['banner'] != null ? List<String>.from(json['banner']) : null,
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
      // 'sub_category':subCategory is SubCategoryModel? subCategory?.toJson():subCategory, // ✅ added
      'whole_sale': wholeSale,
      'quantity': quantity,
      'previous_price': previousPrice,
      'variantImages':
      variantImages?.map((key, value) => MapEntry(key, value.toJson())),
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

  factory Category.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Category();

    return Category(
      id: json['_id'],
      name: json['name'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'img': img,
    };
  }
}



class SubCategory {
  String? id;
  String? name;
  String? img;

  SubCategory({
    this.id,
    this.name,
    this.img,
  });

  factory SubCategory.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SubCategory();

    return SubCategory(
      id: json['_id'],
      name: json['name'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'img': img,
    };
  }
}

class VariantData {
  List<String>? img;
  List<String>? size;
  int? quantity;

  VariantData({this.img, this.size, this.quantity});

  factory VariantData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return VariantData();

    return VariantData(
      img: json['img'] != null ? List<String>.from(json['img']) : [],
      size: json['size'] != null ? List<String>.from(json['size']) : [],
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'img': img,
    'size': size,
    'quantity': quantity,
  };
}

