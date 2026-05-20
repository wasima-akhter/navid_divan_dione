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

  CategoryModel(
      {this.sId,
      this.name,
      this.img,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.subTotal,
      this.isService});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    img = json['img'];
    isActive = json['is_active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    subTotal = json['subTotal'] ?? json['sub_total'] ?? json['subCategoriesCount'];
    isService = json['is_service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['img'] = img;
    data['is_active'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['subTotal'] = subTotal;
    data['is_service'] = isService;
    return data;
  }
}

class SubCategoryModel {
  String? sId;
  String? name;
  String? img;

  SubCategoryModel({this.sId, this.name, this.img});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['img'] = img;
    return data;
  }
}

class BannerModel {
  String? sId;
  String? img;

  BannerModel({this.sId, this.img});

  BannerModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['img'] = img;
    return data;
  }
}
