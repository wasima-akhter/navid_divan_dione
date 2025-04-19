class OrderModel {
  String? sId;
  String? user;
  List<Items>? items;
  int? totalAmount;
  String? paymentStatus;
  String? paymentMethod;
  String? deliveryStatus;
  PickUpAddress? deliveryAddress;
  PickUpAddress? pickUpAddress;
  int? iV;
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
        items!.add(new Items.fromJson(v));
      });
    }
    totalAmount = json['total_amount'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    deliveryStatus = json['delivery_status'];
    deliveryAddress = json['delivery_address'];
    pickUpAddress = json['pick_up_address'] != null
        ? new PickUpAddress.fromJson(json['pick_up_address'])
        : null;
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['total_amount'] = this.totalAmount;
    data['payment_status'] = this.paymentStatus;
    data['payment_method'] = this.paymentMethod;
    data['delivery_status'] = this.deliveryStatus;
    data['delivery_address'] = this.deliveryAddress;
    if (this.pickUpAddress != null) {
      data['pick_up_address'] = this.pickUpAddress!.toJson();
    }
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Items {
  Product? product;
  int? quantity;
  String? color;
  String? sId;

  Items({this.product, this.quantity, this.color, this.sId});

  Items.fromJson(Map<String, dynamic> json) {
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
    color = json['color'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['quantity'] = this.quantity;
    data['color'] = this.color;
    data['_id'] = this.sId;
    return data;
  }
}

class Product {
  String? sId;
  String? name;
  int? price;

  Product({this.sId, this.name, this.price});

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['price'] = this.price;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['name'] = this.name;
    return data;
  }
}
