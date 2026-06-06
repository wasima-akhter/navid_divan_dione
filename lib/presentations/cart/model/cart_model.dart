/*
class CartModel {
  String? sId;
  Variant? variant;
  ProductId? product;
  int? quantity;
  double? totalPrice;

  CartModel({this.sId, this.variant, this.product, this.quantity, this.totalPrice});

  CartModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    variant = json['variant'] != null ? Variant.fromJson(json['variant']) : null;
    product = json['product'] != null ? ProductId.fromJson(json['product']) : null;
    quantity = json['quantity'];
    totalPrice = (json['total_price'] as dynamic?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (variant != null) {
      data['variant'] = variant!.toJson();
    }
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['quantity'] = quantity;
    data['total_price'] = totalPrice;
    return data;
  }
}

class Variant {
  String? sId;
  List<String>? img;
  String? color;
  String? size;
  int? quantity;
  double? price;

  Variant({this.sId, this.img, this.color, this.size, this.quantity, this.price});

  Variant.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    img = json['img'] != null ? List<String>.from(json['img']) : null;
    color = json['color'];
    size = json['size'];
    quantity = json['quantity'];
    price = (json['price'] as dynamic?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['img'] = img;
    data['color'] = color;
    data['size'] = size;
    data['quantity'] = quantity;
    data['price'] = price;
    return data;
  }
}

class ProductId {
  String? sId;
  String? name;
  String? video;

  ProductId({this.sId, this.name, this.video});

  ProductId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['video'] = video;
    return data;
  }
}
*/
class CartModel {
  String? sId;
  Variant? variant;
  ProductId? product;
  int quantity;
  double totalPrice;

  CartModel({
    this.sId,
    this.variant,
    this.product,
    this.quantity = 0,
    this.totalPrice = 0.0,
  });

  factory CartModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CartModel();

    return CartModel(
      sId: json['_id']?.toString() ?? '',
      variant: json['variant'] is Map<String, dynamic>
          ? Variant.fromJson(json['variant'])
          : null,
      product: json['product'] is Map<String, dynamic>
          ? ProductId.fromJson(json['product'])
          : null,
      quantity: _toInt(json['quantity']),
      totalPrice: _toDouble(json['total_price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId ?? '',
      'variant': variant?.toJson(),
      'product': product?.toJson(),
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }
}

class Variant {
  String sId;
  List<String> img;
  String color;
  String size;
  int quantity;
  double price;

  Variant({
    this.sId = '',
    this.img = const [],
    this.color = '',
    this.size = '',
    this.quantity = 0,
    this.price = 0.0,
  });

  factory Variant.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Variant();

    return Variant(
      sId: json['_id']?.toString() ?? '',
      img: (json['img'] is List)
          ? List<String>.from(
              json['img'].where((e) => e != null).map((e) => e.toString()),
            )
          : const [],
      color: json['color']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      quantity: _toInt(json['quantity']),
      price: _toDouble(json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'img': img,
      'color': color,
      'size': size,
      'quantity': quantity,
      'price': price,
    };
  }
}

class ProductId {
  String sId;
  String name;
  String video;

  ProductId({
    this.sId = '',
    this.name = '',
    this.video = '',
  });

  factory ProductId.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProductId();

    return ProductId(
      sId: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'N/A',
      video: json['video']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name,
      'video': video,
    };
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
