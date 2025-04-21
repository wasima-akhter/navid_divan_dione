class OrderModel {
  String? sId;
  String? user;
  List<Items>? items;
  num? totalAmount;
  String? paymentStatus;
  String? paymentMethod;
  String? deliveryStatus;
  PickUpAddress? deliveryAddress;
  PickUpAddress? pickUpAddress;
  num? iV;
  String? createdAt;
  String? updatedAt;

  OrderModel(
      {this.sId,
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
        this.updatedAt});

  OrderModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    totalAmount = json['total_amount'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    deliveryStatus = json['delivery_status'];
    deliveryAddress = json['delivery_address'] != null
        ? PickUpAddress.fromJson(json['delivery_address'])
        : null;
    pickUpAddress = json['pick_up_address'] != null
        ? PickUpAddress.fromJson(json['pick_up_address'])
        : null;
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['total_amount'] = totalAmount;
    data['payment_status'] = paymentStatus;
    data['payment_method'] = paymentMethod;
    data['delivery_status'] = deliveryStatus;
    if (deliveryAddress != null) {
      data['delivery_address'] = deliveryAddress!.toJson();
    }    if (pickUpAddress != null) {
      data['pick_up_address'] = pickUpAddress!.toJson();
    }
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Items {
  Product? product;
  num? quantity;
  String? color;
  String? sId;

  Items({this.product, this.quantity, this.color, this.sId});

  Items.fromJson(Map<String, dynamic> json) {
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
    color = json['color'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['quantity'] = quantity;
    data['color'] = color;
    data['_id'] = sId;
    return data;
  }
}

class Product {
  String? sId;
  String? name;
  num? price;

  Product({this.sId, this.name, this.price});

  Product.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['address'] = address;
    data['phone'] = phone;
    data['name'] = name;
    return data;
  }
}
