/*

class UserProfileModel {
  String? sId;
  String? name;
  String? email;
  String? phone;
  String? img;
  String? role;
  bool? block;
  bool? isVerified;
  String? provider;
  String? accessToken;
  String? useType;
  String? taxId;
  bool? isIdentityVerified;
  List<String>? documents;
  String? dateOfBirth;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? age;

  UserProfileModel(
      {this.sId,
        this.name,
        this.email,
        this.phone,
        this.img,
        this.role,
        this.block,
        this.isVerified,
        this.provider,
        this.accessToken,
        this.useType,
        this.taxId,
        this.isIdentityVerified,
        this.documents,
        this.dateOfBirth,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.age});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    img = json['img'];
    role = json['role'];
    block = json['block'];
    isVerified = json['is_verified'];
    provider = json['provider'];
    accessToken = json['accessToken'];
    useType = json['use_type'];
    taxId = json['tax_id'];
    isIdentityVerified = json['is_identity_verified'];
    documents = json['documents'] != null
        ? List<String>.from(json['documents'])
        : [];    dateOfBirth = json['date_of_birth'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['img'] = img;
    data['role'] = role;
    data['block'] = block;
    data['is_verified'] = isVerified;
    data['provider'] = provider;
    data['accessToken'] = accessToken;
    data['use_type'] = useType;
    data['tax_id'] = taxId;
    data['is_identity_verified'] = isIdentityVerified;
    data['documents'] = documents;
    data['date_of_birth'] = dateOfBirth;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['age'] = age;
    return data;
  }
}


*/

class UserProfileModel {
  String? sId;
  String? name;
  String? email;
  String? phone;
  String? img;
  String? role;
  bool? block;
  bool? isVerified;
  String? provider;
  String? accessToken;
  String? useType;
  String? taxId;
  bool? isIdentityVerified;
  List<String>? documents;
  String? dateOfBirth;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? age;

  UserProfileModel({
    this.sId,
    this.name,
    this.email,
    this.phone,
    this.img,
    this.role,
    this.block,
    this.isVerified,
    this.provider,
    this.accessToken,
    this.useType,
    this.taxId,
    this.isIdentityVerified,
    this.documents,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.age,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserProfileModel();

    return UserProfileModel(
      sId: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      provider: json['provider']?.toString(),
      accessToken: json['accessToken']?.toString(),
      useType: json['use_type']?.toString(),
      taxId: json['tax_id']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      block: _toBool(json['block']),
      isVerified: _toBool(json['is_verified']),
      isIdentityVerified: _toBool(json['is_identity_verified']),
      iV: _toInt(json['__v']),
      age: _toInt(json['age']),
      documents: _parseStringList(json['documents']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name,
      'email': email,
      'phone': phone,
      'img': img,
      'role': role,
      'block': block,
      'is_verified': isVerified,
      'provider': provider,
      'accessToken': accessToken,
      'use_type': useType,
      'tax_id': taxId,
      'is_identity_verified': isIdentityVerified,
      'documents': documents,
      'date_of_birth': dateOfBirth,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
      'age': age,
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

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }
}
