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
