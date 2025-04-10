class CartModel {
  ProductId? productId;
  String? variant;
  int? quantity;
  int? price;
  String? sId;

  CartModel(
      {this.productId, this.variant, this.quantity, this.price, this.sId});

  CartModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'] != null
        ? ProductId.fromJson(json['product_id'])
        : null;
    variant = json['variant'];
    quantity = json['quantity'];
    price = json['price'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productId != null) {
      data['product_id'] = productId!.toJson();
    }
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
  int? price;

  ProductId({this.sId, this.name, this.price});

  ProductId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}
