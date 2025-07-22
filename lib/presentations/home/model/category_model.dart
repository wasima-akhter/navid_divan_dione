class CategoryModel {
  String? sId;
  String? name;
  String? img;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CategoryModel(
      {this.sId,
        this.name,
        this.img,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.iV});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    img = json['img'];
    isActive = json['is_active'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
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
