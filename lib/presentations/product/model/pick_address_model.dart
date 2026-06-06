/*
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
*/

class PickAddressModel {
  String? sId;
  String? user;
  String? address;
  String? phone;
  String? name;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PickAddressModel({
    this.sId,
    this.user,
    this.address,
    this.phone,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  factory PickAddressModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PickAddressModel();

    return PickAddressModel(
      sId: json['_id']?.toString() ?? '',

      /// user can come as String (id) or Map (populated object)
      user: json['user'] is String
          ? json['user'].toString()
          : json['user'] is Map
              ? (json['user']['_id']?.toString() ??
                  json['user']['id']?.toString() ??
                  '')
              : '',

      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      name: json['name']?.toString() ?? '',

      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),

      iV: _toInt(json['__v']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'user': user,
      'address': address,
      'phone': phone,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
    };
  }

  // ---------------- SAFE HELPERS ----------------

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
