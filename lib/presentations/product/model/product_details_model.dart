/*
class ProductDetailsModel {
  final String? id;
  final String? name;
  final String? description;
  final ProductDetailsCategoryModel? category;
  final ProductDetailsSubCategoryModel? subCategory;
  final bool? wholeSale;
  final String? video;
  final List<ProductVariantModel>? variants;
  final List<String>? banners;

  ProductDetailsModel({
    this.id,
    this.name,
    this.description,
    this.category,
    this.subCategory,
    this.wholeSale,
    this.video,
    this.variants,
    this.banners,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'] != null
          ? ProductDetailsCategoryModel.fromJson(json['category'])
          : null,
      subCategory: json['sub_category'] != null
          ? ProductDetailsSubCategoryModel.fromJson(json['sub_category'])
          : null,
      wholeSale: json['whole_sale'],
      video: json['video'],
      variants: json['variants'] != null
          ? List<ProductVariantModel>.from(
              json['variants'].map((x) => ProductVariantModel.fromJson(x)))
          : [],
      banners:
          json['banners'] != null ? List<String>.from(json['banners']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'category': category?.toJson(),
      'sub_category': subCategory?.toJson(),
      'whole_sale': wholeSale,
      'video': video,
      'variants': variants?.map((x) => x.toJson()).toList(),
      'banners': banners,
    };
  }
}

class ProductDetailsCategoryModel {
  final String? id;
  final String? name;
  final String? img;

  ProductDetailsCategoryModel({
    this.id,
    this.name,
    this.img,
  });

  factory ProductDetailsCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsCategoryModel(
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

class ProductDetailsSubCategoryModel {
  final String? id;
  final String? name;
  final String? img;

  ProductDetailsSubCategoryModel({
    this.id,
    this.name,
    this.img,
  });

  factory ProductDetailsSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsSubCategoryModel(
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

class ProductVariantModel {
  final String? id;
  final List<String>? img;
  final String? color;
  final String? size;
  final int? quantity;
  final double? price;
  final double? discount;
  final String? product;
  final double? priceAfterDiscount;

  ProductVariantModel({
    this.id,
    this.img,
    this.color,
    this.size,
    this.quantity,
    this.price,
    this.discount,
    this.product,
    this.priceAfterDiscount,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['_id'],
      img: json['img'] != null ? List<String>.from(json['img']) : [],
      color: json['color'],
      size: json['size'],
      quantity: json['quantity'],
      price: (json['price'] as dynamic)?.toDouble(),
      discount: (json['discount'] as dynamic)?.toDouble(),
      product: json['product'],
      priceAfterDiscount: (json['price_after_discount'] as dynamic)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'img': img,
      'color': color,
      'size': size,
      'quantity': quantity,
      'price': price,
      'discount': discount,
      'product': product,
      'price_after_discount': priceAfterDiscount,
    };
  }
}
*/

//
/*
class ProductDetailsModel {
  final String? id;
  final String? name;
  final String? description;
  final ProductDetailsCategoryModel? category;
  final ProductDetailsSubCategoryModel? subCategory;
  final bool? wholeSale;
  final String? video;
  final List<ProductVariantModel>? variants;
  final List<String>? banners;

  ProductDetailsModel({
    this.id,
    this.name,
    this.description,
    this.category,
    this.subCategory,
    this.wholeSale,
    this.video,
    this.variants,
    this.banners,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'] != null
          ? ProductDetailsCategoryModel.fromJson(json['category'])
          : null,
      subCategory: json['sub_category'] != null
          ? ProductDetailsSubCategoryModel.fromJson(json['sub_category'])
          : null,
      wholeSale: json['whole_sale'],
      video: json['video'],

      // ✅ each variant map could be null or malformed
      variants: (json['variants'] as List?)
              ?.where((e) => e != null)
              .map((e) =>
                  ProductVariantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],

      // ✅ individual banner strings could be null
      banners: (json['banners'] as List?)
              ?.where((e) => e != null)
              .map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'category': category?.toJson(),
      'sub_category': subCategory?.toJson(),
      'whole_sale': wholeSale,
      'video': video,
      'variants': variants?.map((x) => x.toJson()).toList(),
      'banners': banners,
    };
  }
}

class ProductDetailsCategoryModel {
  final String? id;
  final String? name;
  final String? img;

  ProductDetailsCategoryModel({this.id, this.name, this.img});

  factory ProductDetailsCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsCategoryModel(
      id: json['_id'],
      name: json['name'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'img': img};
}

class ProductDetailsSubCategoryModel {
  final String? id;
  final String? name;
  final String? img;

  ProductDetailsSubCategoryModel({this.id, this.name, this.img});

  factory ProductDetailsSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsSubCategoryModel(
      id: json['_id'],
      name: json['name'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'img': img};
}

class ProductVariantModel {
  final String? id;
  final List<String>? img;
  final String? color;
  final String? size;
  final int? quantity;
  final double? price;
  final double? discount;
  final String? product;
  final double? priceAfterDiscount;

  ProductVariantModel({
    this.id,
    this.img,
    this.color,
    this.size,
    this.quantity,
    this.price,
    this.discount,
    this.product,
    this.priceAfterDiscount,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['_id'],

      // ✅ img array items could be null
      img: (json['img'] as List?)
              ?.where((e) => e != null)
              .map((e) => e.toString())
              .toList() ??
          [],

      // ✅ color/size could be non-string (e.g. null or object)
      color: json['color']?.toString(),
      size: json['size']?.toString(),

      // ✅ quantity could come as double from some backends
      quantity: (json['quantity'] as dynamic)?.toInt(),

      price: (json['price'] as dynamic)?.toDouble(),
      discount: (json['discount'] as dynamic)?.toDouble(),

      // ✅ product field could be an object if populated by backend
      product:
          json['product'] is String ? json['product'] : json['product']?['_id'],

      priceAfterDiscount: (json['price_after_discount'] as dynamic)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'img': img,
      'color': color,
      'size': size,
      'quantity': quantity,
      'price': price,
      'discount': discount,
      'product': product,
      'price_after_discount': priceAfterDiscount,
    };
  }
}
*/
import '../../../core/helper/helper_function.dart';

class ProductDetailsModel {
  final String id;
  final String name;
  final String description;
  final ProductDetailsCategoryModel? category;
  final ProductDetailsSubCategoryModel? subCategory;
  final bool wholeSale;
  final String video;
  final List<ProductVariantModel> variants;
  final List<String> banners;

  const ProductDetailsModel({
    this.id = '',
    this.name = '',
    this.description = '',
    this.category,
    this.subCategory,
    this.wholeSale = false,
    this.video = '',
    this.variants = const [],
    this.banners = const [],
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic>? json) {
    final map = SafeParser.map(json);
    if (map == null) return const ProductDetailsModel();

    return ProductDetailsModel(
      id: SafeParser.str(map['_id']),
      name: SafeParser.str(map['name']),
      description: SafeParser.str(map['description']),
      category: SafeParser.map(map['category']) != null
          ? ProductDetailsCategoryModel.fromJson(map['category'])
          : null,
      subCategory: SafeParser.map(map['sub_category']) != null
          ? ProductDetailsSubCategoryModel.fromJson(map['sub_category'])
          : null,
      wholeSale: SafeParser.boolVal(map['whole_sale']),
      video: SafeParser.str(map['video']),
      variants: SafeParser.list(map['variants'], ProductVariantModel.fromJson),
      banners: SafeParser.stringList(map['banners']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'description': description,
        'category': category?.toJson(),
        'sub_category': subCategory?.toJson(),
        'whole_sale': wholeSale,
        'video': video,
        'variants': variants.map((e) => e.toJson()).toList(),
        'banners': banners,
      };
}

class ProductDetailsCategoryModel {
  final String id;
  final String name;
  final String img;

  const ProductDetailsCategoryModel({
    this.id = '',
    this.name = '',
    this.img = '',
  });

  factory ProductDetailsCategoryModel.fromJson(Map<String, dynamic>? json) {
    final map = SafeParser.map(json);
    if (map == null) return const ProductDetailsCategoryModel();

    return ProductDetailsCategoryModel(
      id: SafeParser.str(map['_id']),
      name: SafeParser.str(map['name']),
      img: SafeParser.str(map['img']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'img': img,
      };
}

class ProductDetailsSubCategoryModel {
  final String id;
  final String name;
  final String img;

  const ProductDetailsSubCategoryModel({
    this.id = '',
    this.name = '',
    this.img = '',
  });

  factory ProductDetailsSubCategoryModel.fromJson(Map<String, dynamic>? json) {
    final map = SafeParser.map(json);
    if (map == null) return const ProductDetailsSubCategoryModel();

    return ProductDetailsSubCategoryModel(
      id: SafeParser.str(map['_id']),
      name: SafeParser.str(map['name']),
      img: SafeParser.str(map['img']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'img': img,
      };
}

class ProductVariantModel {
  final String id;
  final List<String> img;
  final String color;
  final String size;
  final int quantity;
  final double price;
  final double discount;
  final String product;
  final double priceAfterDiscount;

  const ProductVariantModel({
    this.id = '',
    this.img = const [],
    this.color = '',
    this.size = '',
    this.quantity = 0,
    this.price = 0.0,
    this.discount = 0.0,
    this.product = '',
    this.priceAfterDiscount = 0.0,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic>? json) {
    final map = SafeParser.map(json);
    if (map == null) return const ProductVariantModel();

    return ProductVariantModel(
      id: SafeParser.str(map['_id']),
      img: SafeParser.stringList(map['img']),
      color: SafeParser.str(map['color']),
      size: SafeParser.str(map['size']),
      quantity: SafeParser.intVal(map['quantity']),
      price: SafeParser.dbl(map['price']),
      discount: SafeParser.dbl(map['discount']),
      priceAfterDiscount: SafeParser.dbl(map['price_after_discount']),
      product: _parseProductId(map['product']),
    );
  }

  static String _parseProductId(dynamic v) {
    final map = SafeParser.map(v);
    if (map != null) return SafeParser.str(map['_id']);
    return SafeParser.str(v);
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'img': img,
        'color': color,
        'size': size,
        'quantity': quantity,
        'price': price,
        'discount': discount,
        'product': product,
        'price_after_discount': priceAfterDiscount,
      };
}
