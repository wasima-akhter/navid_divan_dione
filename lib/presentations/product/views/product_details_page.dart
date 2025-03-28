import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/api-client/api_service.dart';
import 'package:navid_e_commerce/core/components/custom_button.dart';
import 'package:navid_e_commerce/core/components/custom_network_image.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_space.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';
import 'package:navid_e_commerce/presentations/cart/widgets/cart_item_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:navid_e_commerce/presentations/home/widgets/product_card_item_widget.dart';
import 'package:navid_e_commerce/presentations/product/controllers/product_controller.dart';
import 'package:navid_e_commerce/presentations/product/model/product_model.dart';
import 'package:navid_e_commerce/presentations/product/views/deliver_address_page.dart';
import 'package:navid_e_commerce/presentations/product/views/pickup_address_page.dart';
import 'package:navid_e_commerce/presentations/product/widgets/color_item_widget.dart';
import 'package:navid_e_commerce/presentations/product/widgets/expand_able_text.dart';
import 'package:navid_e_commerce/presentations/profile/widgets/custom_loading_widget.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/product-details';
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? _selectedColor;
  late List<String> _currentBannerImages;



  void _initializeBannerImages() {
    final product = ProductController.to.productModel.value;

    // If there's a default banner, use it
    if (product.banner != null && product.banner!.isNotEmpty) {
      _currentBannerImages = product.banner!;
      _selectedColor = null;
    }
    // Otherwise, try to use the first color's variant images
    else if (product.variantColors != null && product.variantColors!.isNotEmpty) {
      _selectedColor = product.variantColors!.first;
      _currentBannerImages = product.variantImages?[_selectedColor] ?? [];
    } else {
      _currentBannerImages = [];
      _selectedColor = null;
    }
  }

  void _onColorSelected(String color) {
    final product = ProductController.to.productModel.value;

    setState(() {
      _selectedColor = color;
      // Update banner images based on selected color
      _currentBannerImages = product.variantImages?[color] ?? [];
    });
  }




  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ProductModel product = ProductController.to.productModel.value;
      _initializeBannerImages();
      return DefaultScaffoldStructureWidget(
          appBarTitle: AppStaticStrings.productDetails,
          spacing: 12.h,
          children: ProductController.to.isLoadingProductDetails.value
              ? [CustomLoadingWidget()]
              : [
_currentBannerImages.isEmpty                      ? SizedBox.shrink()
                      : SizedBox(
                          height: 150.h,
                          child: PageView.builder(
                            controller:
                                ProductController.to.pageController.value,
                            itemCount: _currentBannerImages.length,
                            itemBuilder: (context, index) => CustomNetworkImage(
                                imageUrl:
                                    '${ApiService().baseUrl}/${_currentBannerImages[index]}',
                                height: 150.h,
                                width: double.infinity),
                          ),
                        ),
                  product.variantColors != null &&
                          product.variantColors!.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            spacing: 12.w,
                            children: [
                              CustomText(text: AppStaticStrings.selectColor),
                              ...List.generate(
                                product.variantColors!.length,
                                (index) => GestureDetector(
                                    onTap: () => _onColorSelected(
                                        product.variantColors![index]),
                                    child: ColorItemWidget( isSelected: _selectedColor == product.variantColors![index],
                                      color: product.variantColors![index],
                                    )),
                              )
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  Row(
                    children: [
                      Expanded(
                        child: PriceTextWidget(
                          previousPrice:
                              (product.previousPrice ?? 0.0).toString(),
                          price: (product.price ?? 0.0).toString(),
                          fontSize: getFontSizeExtraLarge(),
                          previousPriceFontSize: getFontSizeDefault(),
                        ),
                      ),
                      CartCounterWidget()
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: product.name ?? '',
                          fontSize: getFontSizeDefault(),
                          color: AppColors.kPrimaryTextDarkColor,
                        ),
                      ),
                      CustomText(
                        text: '${product.quantity ?? ''} pis',
                        style: poppinsRegular,
                      )
                    ],
                  ),
                  ExpandableText(
                    text: product.description ?? '',
                    maxLines: 3,
                  ),
                  CustomButton(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Column(
                            spacing: 6.h,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomButton(
                                onTap: () {
                                  Get.toNamed(PickupAddressPage.routeName);
                                },
                                title: AppStaticStrings.pickUp,
                              ),
                              CustomText(text: 'or'),
                              CustomButton(
                                onTap: () {
                                  Get.toNamed(DeliverAddressPage.routeName);
                                },
                                fillColor: AppColors.kPrimaryDarkColor,
                                borderColor: AppColors.kPrimaryDarkColor,
                                title: AppStaticStrings.deliveryAddress,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    title: AppStaticStrings.buyNow,
                  ),
                  CustomText(
                    text: 'Related Products',
                    fontSize: getFontSizeDefault(),
                    color: AppColors.kPrimaryTextDarkColor,
                  ),
                  SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 12.w,
                        children: List.generate(
                          5,
                          (index) => SizedBox(
                              width: 200.w,
                              // height: 200.w,
                              child: ProductCardItemWidget(
                                product: ProductModel(),
                              )),
                        ),
                      ),
                    ),
                  )
                ]);
    });
  }
}
