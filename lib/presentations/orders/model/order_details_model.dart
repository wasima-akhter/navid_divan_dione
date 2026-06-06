import '../../../core/helper/helper_function.dart';

/*
class OrderDetailsModel {
  final String id;
  final UserModel user;
  final List<OrderItemModel> items;
  final String paymentStatus;
  final double totalAmount;
  final String deliveryStatus;
  final AddressModel? deliveryAddress;
  final AddressModel? pickUpAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderDetailsModel({
    required this.id,
    required this.user,
    required this.items,
    required this.paymentStatus,
    required this.totalAmount,
    required this.deliveryStatus,
    this.deliveryAddress,
    this.pickUpAddress,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic>? json) {
    debugPrint("ORDER JSON TYPE CHECK:");
    debugPrint("user => ${json?['user'].runtimeType}");
    debugPrint("items => ${json?['items'].runtimeType}");
    debugPrint("delivery_address => ${json?['delivery_address'].runtimeType}");
    debugPrint("pick_up_address => ${json?['pick_up_address'].runtimeType}");

    return OrderDetailsModel(
      id: json?['_id']?.toString() ?? '',
      user: UserModel.fromJson(json?['user']),
      items: (json?['items'] is List)
          ? (json?['items'] as List)
              .map((e) => OrderItemModel.fromJson(e))
              .toList()
          : [],
      paymentStatus: json?['payment_status']?.toString() ?? 'unknown',
      totalAmount: (json?['total_amount'] is num)
          ? (json?['total_amount'] as num).toDouble()
          : double.tryParse(json?['total_amount']?.toString() ?? '') ?? 0.0,
      deliveryStatus: json?['delivery_status']?.toString() ?? 'unknown',
      // deliveryAddress: json?['delivery_address'] is Map<String, dynamic>
      //     ? AddressModel.fromJson(json?['delivery_address'])
      //     : null,
      // pickUpAddress: json?['pick_up_address'] is Map<String, dynamic>
      //     ? AddressModel.fromJson(json?['pick_up_address'])
      //     : null,

      deliveryAddress: json?['delivery_address'] is Map<String, dynamic>
          ? AddressModel.fromJson(json?['delivery_address'])
          : json?['delivery_address'] is String
              ? AddressModel(
                  id: json?['delivery_address'],
                  name: '',
                  phone: '',
                  address: '',
                )
              : null,
      pickUpAddress: json?['pick_up_address'] is Map<String, dynamic>
          ? AddressModel.fromJson(json?['pick_up_address'])
          : json?['pick_up_address'] is String
              ? AddressModel(
                  id: json?['pick_up_address'],
                  name: '',
                  phone: '',
                  address: '',
                )
              : null,
      createdAt: DateTime.tryParse(json?['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json?['updatedAt']?.toString() ?? ''),
    );
  }
  factory OrderDetailsModel.empty() {
    return OrderDetailsModel(
      id: '',
      user: UserModel.empty(),
      items: [],
      paymentStatus: 'unknown',
      totalAmount: 0.0,
      deliveryStatus: 'unknown',
      deliveryAddress: null,
      pickUpAddress: null,
      createdAt: null,
      updatedAt: null,
    );
  }
}
*/
class UserModel {
  final String id;
  final String name;
  final String email;
  final String img;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.img,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserModel.empty();

    return UserModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      email: json['email']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
    );
  }

  factory UserModel.empty() {
    return UserModel(
      id: '',
      name: 'Unknown',
      email: '',
      img: '',
    );
  }
}

/*
class OrderItemModel {
  final ProductModel product;
  final VariantModel variant;
  final int quantity;
  final String id;

  OrderItemModel({
    required this.product,
    required this.variant,
    required this.quantity,
    required this.id,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return OrderItemModel.empty();

    return OrderItemModel(
      product: ProductModel.fromJson(json['product']),
      variant: VariantModel.fromJson(json['variant']),
      quantity: (json['quantity'] is num)
          ? (json['quantity'] as num).toInt()
          : int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      id: json['_id']?.toString() ?? '',
    );
  }

  factory OrderItemModel.empty() {
    return OrderItemModel(
      product: ProductModel.empty(),
      variant: VariantModel.empty(),
      quantity: 0,
      id: '',
    );
  }
}
*/
class OrderItemModel {
  final ProductModel product;
  final VariantModel variant;
  final int quantity;
  final String id;

  OrderItemModel({
    required this.product,
    required this.variant,
    required this.quantity,
    required this.id,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic>? json) {
    final map = SafeParser.map(json);
    if (map == null) return OrderItemModel.empty();

    return OrderItemModel(
      product: ProductModel.fromJson(map['product']),
      variant: VariantModel.fromJson(map['variant']),
      quantity: SafeParser.intVal(map['quantity']),
      id: SafeParser.str(map['_id']),
    );
  }

  factory OrderItemModel.empty() {
    return OrderItemModel(
      product: ProductModel.empty(),
      variant: VariantModel.empty(),
      quantity: 0,
      id: '',
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final bool wholeSale;
  final String video;

  ProductModel({
    required this.id,
    required this.name,
    required this.wholeSale,
    required this.video,
  });

  factory ProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ProductModel.empty();

    return ProductModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      wholeSale: json['whole_sale'] ?? false,
      video: json['video']?.toString() ?? '',
    );
  }

  factory ProductModel.empty() {
    return ProductModel(
      id: '',
      name: '',
      wholeSale: false,
      video: '',
    );
  }
}

/*
class VariantModel {
  final String id;
  final List<String> images;
  final String color;
  final String size;
  final int quantity;
  final double price;
  final double priceAfterDiscount;
  final double discount;

  VariantModel({
    required this.id,
    required this.images,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
    required this.priceAfterDiscount,
    required this.discount,
  });

  factory VariantModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return VariantModel.empty();

    return VariantModel(
      id: json['_id']?.toString() ?? '',
      images: (json['img'] is List)
          ? List<String>.from(json['img'].map((e) => e.toString()))
          : [],
      color: json['color']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      quantity: (json['quantity'] is num)
          ? (json['quantity'] as num).toInt()
          : int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      priceAfterDiscount: (json['price_after_discount'] is num)
          ? (json['price_after_discount'] as num).toDouble()
          : double.tryParse(json['price_after_discount']?.toString() ?? '') ??
              0.0,
      discount: (json['discount'] is num)
          ? (json['discount'] as num).toDouble()
          : double.tryParse(json['discount']?.toString() ?? '') ?? 0.0,
    );
  }

  factory VariantModel.empty() {
    return VariantModel(
      id: '',
      images: [],
      color: '',
      size: '',
      quantity: 0,
      price: 0,
      priceAfterDiscount: 0,
      discount: 0,
    );
  }
}
*/
class VariantModel {
  final String id;
  final List<String> images;
  final String color;
  final String size;
  final int quantity;
  final double price;
  final double priceAfterDiscount;
  final double discount;

  VariantModel({
    required this.id,
    required this.images,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
    required this.priceAfterDiscount,
    required this.discount,
  });

  factory VariantModel.fromJson(Map<String, dynamic>? json) {
    final map = SafeParser.map(json);
    if (map == null) return VariantModel.empty();

    return VariantModel(
      id: SafeParser.str(map['_id']),
      images: SafeParser.stringList(map['img']),
      color: SafeParser.str(map['color']),
      size: SafeParser.str(map['size']),
      quantity: SafeParser.intVal(map['quantity']),
      price: SafeParser.dbl(map['price']),
      priceAfterDiscount: SafeParser.dbl(map['price_after_discount']),
      discount: SafeParser.dbl(map['discount']),
    );
  }

  factory VariantModel.empty() {
    return VariantModel(
      id: '',
      images: [],
      color: '',
      size: '',
      quantity: 0,
      price: 0,
      priceAfterDiscount: 0,
      discount: 0,
    );
  }
}

/*
class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String address;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory AddressModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AddressModel.empty();

    return AddressModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
    );
  }

  factory AddressModel.empty() {
    return AddressModel(
      id: '',
      name: '',
      phone: '',
      address: '',
    );
  }
}
*/
class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String address;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory AddressModel.fromJson(Map<String, dynamic>? json) {
    final map = SafeParser.map(json);
    if (map == null) return AddressModel.empty();

    return AddressModel(
      id: SafeParser.str(map['_id']),
      name: SafeParser.str(map['name']),
      phone: SafeParser.str(map['phone']),
      address: SafeParser.str(map['address']),
    );
  }

  static AddressModel? fromDynamic(dynamic v) {
    final map = SafeParser.map(v);
    if (map != null) return AddressModel.fromJson(map);

    if (v is String && v.isNotEmpty) {
      return AddressModel(id: v, name: '', phone: '', address: '');
    }

    return null;
  }

  factory AddressModel.empty() {
    return AddressModel(id: '', name: '', phone: '', address: '');
  }
}

class OrderDetailsModel {
  final String id;
  final UserModel user;
  final List<OrderItemModel> items;
  final String paymentStatus;
  final double totalAmount;
  final String deliveryStatus;
  final AddressModel? deliveryAddress;
  final AddressModel? pickUpAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderDetailsModel({
    required this.id,
    required this.user,
    required this.items,
    required this.paymentStatus,
    required this.totalAmount,
    required this.deliveryStatus,
    this.deliveryAddress,
    this.pickUpAddress,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic>? json) {
    final map = SafeParser.map(json);

    if (map == null) return OrderDetailsModel.empty();

    return OrderDetailsModel(
      id: SafeParser.str(map['_id']),
      user: UserModel.fromJson(map['user']),
      items: SafeParser.list(map['items'], OrderItemModel.fromJson),
      paymentStatus: SafeParser.str(map['payment_status'], 'unknown'),
      totalAmount: SafeParser.dbl(map['total_amount']),
      deliveryStatus: SafeParser.str(map['delivery_status'], 'unknown'),
      deliveryAddress: AddressModel.fromDynamic(map['delivery_address']),
      pickUpAddress: AddressModel.fromDynamic(map['pick_up_address']),
      createdAt: SafeParser.date(map['createdAt']),
      updatedAt: SafeParser.date(map['updatedAt']),
    );
  }

  factory OrderDetailsModel.empty() {
    return OrderDetailsModel(
      id: '',
      user: UserModel.empty(),
      items: [],
      paymentStatus: 'unknown',
      totalAmount: 0.0,
      deliveryStatus: 'unknown',
      deliveryAddress: null,
      pickUpAddress: null,
      createdAt: null,
      updatedAt: null,
    );
  }
}
