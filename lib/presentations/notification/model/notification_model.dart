/*

class NotificationModel {
  String? sId;
  User? user;
  String? title;
  String? message;
  bool? readByAdmin;
  bool? readByUser;
  int? iV;
  String? createdAt;
  String? updatedAt;

  NotificationModel(
      {this.sId,
        this.user,
        this.title,
        this.message,
        this.readByAdmin,
        this.readByUser,
        this.iV,
        this.createdAt,
        this.updatedAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    title = json['title'];
    message = json['message'];
    readByAdmin = json['read_by_admin'];
    readByUser = json['read_by_user'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['title'] = title;
    data['message'] = message;
    data['read_by_admin'] = readByAdmin;
    data['read_by_user'] = readByUser;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class User {
  String? sId;
  String? name;
  String? img;

  User({this.sId, this.name, this.img});

  User.fromJson(Map<String, dynamic> json) {
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


*/

class NotificationModel {
  String? sId;

  User? user;

  String? title;

  String? message;

  bool? readByAdmin;

  bool? readByUser;

  int? iV;

  String? createdAt;

  String? updatedAt;

  NotificationModel({
    this.sId,
    this.user,
    this.title,
    this.message,
    this.readByAdmin,
    this.readByUser,
    this.iV,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return NotificationModel();

    return NotificationModel(
      sId: json['_id']?.toString() ?? '',
      user: json['user'] is Map<String, dynamic>
          ? User.fromJson(json['user'])
          : null,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      readByAdmin: _toBool(json['read_by_admin']),
      readByUser: _toBool(json['read_by_user']),
      iV: _toInt(json['__v']),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'user': user?.toJson(),
      'title': title,
      'message': message,
      'read_by_admin': readByAdmin,
      'read_by_user': readByUser,
      '__v': iV,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
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

class User {
  String? sId;

  String? name;

  String? img;

  User({
    this.sId,
    this.name,
    this.img,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) return User();

    return User(
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
