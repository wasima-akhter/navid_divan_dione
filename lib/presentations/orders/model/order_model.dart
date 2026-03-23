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
