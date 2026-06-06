/*
class OrderModel {
  String? sId;
  OrderUser? user;
  List<Items>? items;
  double? totalAmount;
  String? paymentStatus;
  String? paymentMethod;
  String? deliveryStatus;
  PickUpAddress? deliveryAddress;
  PickUpAddress? pickUpAddress;
  int? iV;
  String? createdAt;
  String? updatedAt;

  OrderModel({
    this.sId,
    this.user,
    this.items,
    this.totalAmount,
    this.paymentStatus,
    this.paymentMethod,
    this.deliveryStatus,
    this.deliveryAddress,
    this.pickUpAddress,
    this.iV,
    this.createdAt,
    this.updatedAt,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? OrderUser.fromJson(json['user']) : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) => items!.add(Items.fromJson(v)));
    }
    // ✅ num covers both int and double from JSON
    totalAmount = (json['total_amount'] as num?)?.toDouble();
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    deliveryStatus = json['delivery_status'];
    deliveryAddress =
        json['delivery_address'] != null ? PickUpAddress.fromJson(json['delivery_address']) : null;
    pickUpAddress =
        json['pick_up_address'] != null ? PickUpAddress.fromJson(json['pick_up_address']) : null;
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'user': user?.toJson(),
        'items': items?.map((v) => v.toJson()).toList(),
        'total_amount': totalAmount,
        'payment_status': paymentStatus,
        'payment_method': paymentMethod,
        'delivery_status': deliveryStatus,
        'delivery_address': deliveryAddress?.toJson(),
        'pick_up_address': pickUpAddress?.toJson(),
        '__v': iV,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class OrderUser {
  String? sId;
  String? name;
  String? email;
  String? phone;
  String? img;

  OrderUser({this.sId, this.name, this.email, this.phone, this.img});

  OrderUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'name': name,
        'email': email,
        'phone': phone,
        'img': img,
      };
}

class Items {
  Product? product;
  OrderVariant? variant;
  int? quantity; // ✅ int — JSON always sends whole numbers for quantity
  String? sId;

  Items({this.product, this.variant, this.quantity, this.sId});

  Items.fromJson(Map<String, dynamic> json) {
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    variant = json['variant'] != null ? OrderVariant.fromJson(json['variant']) : null;
    // ✅ num → int
    quantity = (json['quantity'] as num?)?.toInt();
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() => {
        'product': product?.toJson(),
        'variant': variant?.toJson(),
        'quantity': quantity,
        '_id': sId,
      };
}

class OrderVariant {
  String? sId;
  List<String>? img;
  String? color;
  String? size;
  int? quantity; // ✅ stock quantity — always int
  double? priceAfterDiscount;
  double? price;
  double? discount;

  OrderVariant({
    this.sId,
    this.img,
    this.color,
    this.size,
    this.quantity,
    this.priceAfterDiscount,
    this.price,
    this.discount,
  });

  OrderVariant.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    img = json['img'] != null ? List<String>.from(json['img']) : [];
    color = json['color'];
    size = json['size'];
    // ✅ num → int / double
    quantity = (json['quantity'] as num?)?.toInt();
    priceAfterDiscount = (json['price_after_discount'] as num?)?.toDouble();
    price = (json['price'] as num?)?.toDouble();
    discount = (json['discount'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'img': img,
        'color': color,
        'size': size,
        'quantity': quantity,
        'price_after_discount': priceAfterDiscount,
        'price': price,
        'discount': discount,
      };
}

class Product {
  String? sId;
  String? name;

  Product({this.sId, this.name});

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    // ✅ num → double (price can be null in order items response)
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'name': name,
      };
}

class PickUpAddress {
  String? sId;
  String? address;
  String? phone;
  String? name;

  PickUpAddress({this.sId, this.address, this.phone, this.name});

  PickUpAddress.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    address = json['address'];
    phone = json['phone'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'address': address,
        'phone': phone,
        'name': name,
      };
}
*/

class OrderModel {
  String? sId;
  OrderUser? user;
  List<Items> items;
  double totalAmount;
  String paymentStatus;
  String paymentMethod;
  String deliveryStatus;
  PickUpAddress? deliveryAddress;
  PickUpAddress? pickUpAddress;
  int? iV;
  String createdAt;
  String updatedAt;

  OrderModel({
    this.sId,
    this.user,
    this.items = const [],
    this.totalAmount = 0.0,
    this.paymentStatus = '',
    this.paymentMethod = '',
    this.deliveryStatus = '',
    this.deliveryAddress,
    this.pickUpAddress,
    this.iV,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory OrderModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return OrderModel();

    return OrderModel(
      sId: json['_id']?.toString(),
      user: json['user'] is Map<String, dynamic>
          ? OrderUser.fromJson(json['user'])
          : null,
      items: (json['items'] is List)
          ? (json['items'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => Items.fromJson(e))
              .toList()
          : [],
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['payment_status']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? '',
      deliveryStatus: json['delivery_status']?.toString() ?? '',
      deliveryAddress: json['delivery_address'] is Map<String, dynamic>
          ? PickUpAddress.fromJson(json['delivery_address'])
          : null,
      pickUpAddress: json['pick_up_address'] is Map<String, dynamic>
          ? PickUpAddress.fromJson(json['pick_up_address'])
          : null,
      iV: json['__v'],
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'user': user?.toJson(),
        'items': items.map((v) => v.toJson()).toList(),
        'total_amount': totalAmount,
        'payment_status': paymentStatus,
        'payment_method': paymentMethod,
        'delivery_status': deliveryStatus,
        'delivery_address': deliveryAddress?.toJson(),
        'pick_up_address': pickUpAddress?.toJson(),
        '__v': iV,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class OrderUser {
  String? sId;
  String name;
  String email;
  String phone;
  String img;

  OrderUser({
    this.sId,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.img = '',
  });

  factory OrderUser.fromJson(Map<String, dynamic>? json) {
    if (json == null) return OrderUser();

    return OrderUser(
      sId: json['_id']?.toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'name': name,
        'email': email,
        'phone': phone,
        'img': img,
      };
}

class Items {
  Product? product;
  OrderVariant? variant;
  int quantity;
  String? sId;

  Items({
    this.product,
    this.variant,
    this.quantity = 0,
    this.sId,
  });

  factory Items.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Items();

    return Items(
      product: json['product'] is Map<String, dynamic>
          ? Product.fromJson(json['product'])
          : null,
      variant: json['variant'] is Map<String, dynamic>
          ? OrderVariant.fromJson(json['variant'])
          : null,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      sId: json['_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'product': product?.toJson(),
        'variant': variant?.toJson(),
        'quantity': quantity,
        '_id': sId,
      };
}

class OrderVariant {
  String? sId;
  List<String> img;
  String color;
  String size;
  int quantity;
  double priceAfterDiscount;
  double price;
  double discount;

  OrderVariant({
    this.sId,
    this.img = const [],
    this.color = '',
    this.size = '',
    this.quantity = 0,
    this.priceAfterDiscount = 0.0,
    this.price = 0.0,
    this.discount = 0.0,
  });

  factory OrderVariant.fromJson(Map<String, dynamic>? json) {
    if (json == null) return OrderVariant();

    return OrderVariant(
      sId: json['_id']?.toString(),
      img: (json['img'] is List)
          ? List<String>.from(json['img'].map((e) => e.toString()))
          : [],
      color: json['color']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      priceAfterDiscount:
          (json['price_after_discount'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'img': img,
        'color': color,
        'size': size,
        'quantity': quantity,
        'price_after_discount': priceAfterDiscount,
        'price': price,
        'discount': discount,
      };
}

class Product {
  String? sId;
  String name;
  String video;

  Product({
    this.sId,
    this.name = '',
    this.video = '',
  });

  factory Product.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Product();

    return Product(
      sId: json['_id']?.toString(),
      name: json['name']?.toString() ?? '',
      video: json['video']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'name': name,
        'video': video,
      };
}

class PickUpAddress {
  String? sId;
  String address;
  String phone;
  String name;

  PickUpAddress({
    this.sId,
    this.address = '',
    this.phone = '',
    this.name = '',
  });

  factory PickUpAddress.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PickUpAddress();

    return PickUpAddress(
      sId: json['_id']?.toString(),
      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'address': address,
        'phone': phone,
        'name': name,
      };
}
