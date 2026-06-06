import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/custom_space.dart';
import '../../../core/constants/text_style_constant.dart';
import '../../product/widgets/product_det_export.dart';
import '../controllers/order_details_controller.dart';
import '../model/order_details_model.dart';

class OrderDetailsPage extends StatefulWidget {
  static const String routeName = '/order-details';

  const OrderDetailsPage({super.key});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final controller = OrderDetailsController.to;

  late final String orderId;

  @override
  void initState() {
    super.initState();

    orderId = Get.arguments as String;

    controller.getOrderDetailsRequest(
      orderId: orderId,
    );
  }

  @override
  void dispose() {
    controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(
      appBarTitle: "Order Details",
      onRefresh: () async {
        await controller.getOrderDetailsRequest(
          orderId: orderId,
        );
      },
      children: [
        Obx(() {
          if (controller.isLoading.value) {
            return const CustomLoadingWidget();
          }

          final order = controller.orderDetails.value;

          if (order == null) {
            return SizedBox(
              height: .5.sh,
              child: Center(
                child: CustomText(
                  text: "Order Details Not Found",
                ),
              ),
            );
          }

          return _OrderDetailsContent(
            order: order,
          );
        }),
      ],
    );
  }
}

class _OrderDetailsContent extends StatelessWidget {
  final OrderDetailsModel order;

  const _OrderDetailsContent({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: .6,
          color: AppColors.kExtraLightGreyTextColor.withOpacity(.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          _OrderInfoSection(order),

          Divider(height: 24.h),

          /// CUSTOMER
          _CustomerSection(order),

          Divider(height: 24.h),

          /// ADDRESSES
          if (order.deliveryAddress != null)
            _AddressSection(
              title: "Delivery Address",
              address: order.deliveryAddress!,
              icon: Icons.location_on_outlined,
            ),

          if (order.pickUpAddress != null)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: _AddressSection(
                title: "Pickup Address",
                address: order.pickUpAddress!,
                icon: Icons.store_outlined,
              ),
            ),

          Divider(height: 24.h),

          CustomText(
            text: "Order Items",
            style: poppinsSemiBold.copyWith(
              fontSize: 16.sp,
            ),
          ),

          space12H,

          ...order.items.map(
            (item) => _OrderItemCard(item: item),
          ),

          Divider(height: 24.h),

          _OrderSummarySection(order),
        ],
      ),
    );
  }
}

class _OrderInfoSection extends StatelessWidget {
  final OrderDetailsModel order;

  const _OrderInfoSection(this.order);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomText(
                text: "Order no: #${order.id}",
                style: poppinsSemiBold,
                color: AppColors.kPrimaryColor,
              ),
            ),
            IconButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: order.id),
                );
              },
              icon: const Icon(Icons.copy),
            ),
          ],
        ),
        CustomText(
          text: "Total Amount: \$${order.totalAmount.toStringAsFixed(2)}",
          style: poppinsSemiBold,
        ),
        space8H,
        Column(
          children: [
            Row(
              children: [
                CustomText(text: "Payment Status: ", fontSize: 13),
                _StatusChip(
                  title: order.paymentStatus.toUpperCase(),
                  color: _statusColor(order.paymentStatus),
                ),
              ],
            ),
            8.verticalSpace,
            Row(
              children: [
                CustomText(text: "Delivery Status: ", fontSize: 13),
                _StatusChip(
                  title: order.deliveryStatus.toUpperCase(),
                  color: _statusColor(order.deliveryStatus),
                ),
              ],
            ),
          ],
        ),
        space12H,
        if (order.createdAt != null)
          CustomText(
            text:
                "Created: ${DateFormat("dd MMM yyyy • hh:mm a").format(order.createdAt!)}",
            fontSize: 12.sp,
          ),
        if (order.updatedAt != null)
          CustomText(
            text:
                "Updated: ${DateFormat("dd MMM yyyy • hh:mm a").format(order.updatedAt!)}",
            fontSize: 12.sp,
          ),
      ],
    );
  }

  Color _statusColor(String value) {
    switch (value.toLowerCase()) {
      case 'paid':
      case 'delivered':
        return Colors.green;

      case 'pending':
        return Colors.orange;

      case 'processing':
        return Colors.blue;

      case 'cancelled':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String title;
  final Color color;

  const _StatusChip({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        text: title,
        color: color,
        style: poppinsSemiBold.copyWith(
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

class _CustomerSection extends StatelessWidget {
  final OrderDetailsModel order;

  const _CustomerSection(this.order);

  @override
  Widget build(BuildContext context) {
    debugPrint(' order.user.img: ${order.user.img} ');
    return Row(
      children: [
        order.user.img.isNotEmpty
            ? CustomNetworkImage(
                imageUrl: order.user.img,
                height: 56.h,
                width: 56.w,
                boxShape: BoxShape.circle,
                isPreview: true,
              )
            : CircleAvatar(
                radius: 28.r,
                child: Icon(
                  Icons.person,
                  size: 28.sp,
                ),
              ),
        space12W,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: order.user.name.capitalize ?? '',
                style: poppinsSemiBold,
              ),
              CustomText(
                text: order.user.email,
                color: AppColors.kLightTextColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddressSection extends StatelessWidget {
  final String title;
  final AddressModel? address;
  final IconData icon;

  const _AddressSection({
    required this.title,
    required this.address,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(' address: $address ');
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.kWhiteColor,
        border: Border.all(
          color: AppColors.kExtraLightGreyTextColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.kPrimaryColor,
          ),
          space12W,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  style: poppinsSemiBold,
                ),
                space4H,
                if ((address?.name ?? '').isNotEmpty)
                  CustomText(text: "Name: ${address?.name.capitalize}"),
                if ((address?.phone ?? '').isNotEmpty)
                  CustomText(text: "Phone: ${address?.phone}"),
                if ((address?.address ?? '').isNotEmpty)
                  CustomText(text: "Address: ${address?.address.capitalize}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  final OrderItemModel item;

  const _OrderItemCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = item.variant.priceAfterDiscount * item.quantity;

    debugPrint(
        ' item.variant.priceAfterDiscount: ${item.variant.priceAfterDiscount} ');
    debugPrint(' item.variant.price: ${item.variant.price} ');

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.kExtraLightGreyTextColor,
        ),
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl:
                item.variant.images.isNotEmpty ? item.variant.images.first : "",
            height: 90.h,
            width: 90.w,
            borderRadius: BorderRadius.circular(8.r),
            isPreview: true,
          ),
          space12W,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: item.product.name.capitalize ?? '',
                  style: poppinsSemiBold,
                ),
                space6H,
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    if (item.variant.size.isNotEmpty)
                      CustomText(
                        text: "Size: ${item.variant.size}",
                        fontSize: 12,
                      ),
                    CustomText(
                      text: "Qty: ${item.quantity}",
                      fontSize: 12.sp,
                    ),
                    if (item.variant.color.isNotEmpty)
                      CustomText(
                        text: "Color: ${item.variant.color}",
                        fontSize: 12.sp,
                      ),
                  ],
                ),
                space8H,
                CustomText(
                  text:
                      "\$${item.variant.priceAfterDiscount.toStringAsFixed(2)}",
                  style: poppinsSemiBold.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                if (item.variant.discount > 0)
                  CustomText(
                    text: "Discount ${item.variant.discount}%",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12.sp,
                    ),
                  ),
                CustomText(
                  text: "Subtotal: \$${subtotal.toStringAsFixed(2)}",
                  fontSize: 12.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummarySection extends StatelessWidget {
  final OrderDetailsModel order;

  const _OrderSummarySection(this.order);

  @override
  Widget build(BuildContext context) {
    final totalQuantity = order.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    final totalDiscount = order.items.fold<double>(
      0,
      (sum, item) =>
          sum +
          ((item.variant.price - item.variant.priceAfterDiscount) *
              item.quantity),
    );

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.kExtraLightGreyTextColor.withOpacity(.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Order Summary",
            style: poppinsSemiBold.copyWith(
              fontSize: 16.sp,
            ),
          ),
          space12H,
          _summaryRow(
            title: "Total Products",
            value: "${order.items.length}",
          ),
          _summaryRow(
            title: "Total Quantity",
            value: "$totalQuantity",
          ),
          _summaryRow(
            title: "Payment Status",
            value: order.paymentStatus.toUpperCase(),
          ),
          _summaryRow(
            title: "Delivery Status",
            value: order.deliveryStatus.toUpperCase(),
          ),
          if (totalDiscount > 0)
            _summaryRow(
              title: "Total Discount",
              value: "\$${totalDiscount.toStringAsFixed(2)}",
              valueColor: Colors.green,
            ),
          Divider(height: 24.h),
          _summaryRow(
            title: "Grand Total",
            value: "\$${order.totalAmount.toStringAsFixed(2)}",
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow({
    required String title,
    required String value,
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              text: title,
              color: AppColors.kLightTextColor,
            ),
          ),
          CustomText(
            text: value,
            color: valueColor ?? AppColors.kPrimaryTextDarkColor,
            style: isBold
                ? poppinsSemiBold.copyWith(
                    fontSize: 16.sp,
                  )
                : poppinsMedium,
          ),
        ],
      ),
    );
  }
}

//
