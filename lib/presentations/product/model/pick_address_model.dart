class PickAddressModel {
  String? sId;
  String? user;
  String? address;
  String? phone;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PickAddressModel({this.sId, this.user, this.address, this.phone, this.name, this.createdAt, this.updatedAt, this.iV});

  PickAddressModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    address = json['address'];
    phone = json['phone'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['address'] = address;
    data['phone'] = phone;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
