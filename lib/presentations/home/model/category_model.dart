import 'package:get/get.dart';

class CategoryModel {
  String? sId;
  String? name;
  String? img;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? subTotal;
  bool? isService;

  RxBool isLoadingSub = false.obs;

  CategoryModel({
    this.sId,
    this.name,
    this.img,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.subTotal,
    this.isService,
  });

  factory CategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CategoryModel();

    return CategoryModel(
      sId: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
      isActive: _toBool(json['is_active']),
      isService: _toBool(json['is_service']),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      iV: _toInt(json['__v']),
      subTotal: _toInt(
        json['subTotal'] ?? json['sub_total'] ?? json['subCategoriesCount'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name,
      'img': img,
      'is_active': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
      'subTotal': subTotal,
      'is_service': isService,
    };
  }

  // ---------------- SAFE HELPERS ----------------

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }
}

class SubCategoryModel {
  String? sId;
  String? name;
  String? img;

  SubCategoryModel({
    this.sId,
    this.name,
    this.img,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SubCategoryModel();

    return SubCategoryModel(
      sId: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name,
      'img': img,
    };
  }
}

class BannerModel {
  String? sId;
  String? img;

  BannerModel({
    this.sId,
    this.img,
  });

  factory BannerModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BannerModel();

    return BannerModel(
      sId: json['_id']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'img': img,
    };
  }
}
