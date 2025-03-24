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
