class CartModel {
  ProductId? productId;
  String? variant;
  String? size;
  int? quantity;
  num? price;  // Changed to num?
  String? sId;

  CartModel({this.productId, this.variant, this.size, this.quantity, this.price, this.sId});

  CartModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'] != null
        ? ProductId.fromJson(json['product_id'])
        : null;
    size = json['size'];
    variant = json['variant'];
    quantity = json['quantity'];
    price = json['price'];  // No need to convert, since price can be num (both int and double)
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productId != null) {
      data['product_id'] = productId!.toJson();
    }
    data['size'] = size;
    data['variant'] = variant;
    data['quantity'] = quantity;
    data['price'] = price;
    data['_id'] = sId;
    return data;
  }
}

class ProductId {
  String? sId;
  String? name;
  num? price;  // Changed to num?

  ProductId({this.sId, this.name, this.price});

  ProductId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];  // No need to convert, since price can be num (both int and double)
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}

