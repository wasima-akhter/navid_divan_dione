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
      category:
          json['category'] != null ? ProductDetailsCategoryModel.fromJson(json['category']) : null,
      subCategory: json['sub_category'] != null
          ? ProductDetailsSubCategoryModel.fromJson(json['sub_category'])
          : null,
      wholeSale: json['whole_sale'],
      video: json['video'],
      variants: json['variants'] != null
          ? List<ProductVariantModel>.from(
              json['variants'].map((x) => ProductVariantModel.fromJson(x)))
          : [],
      banners: json['banners'] != null ? List<String>.from(json['banners']) : [],
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
