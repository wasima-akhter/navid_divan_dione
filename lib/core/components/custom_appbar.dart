import 'package:flutter/material.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/core/constants/custom_text.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';

class CustomAuthAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAuthAppbar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: CustomText(
        text: title,
        style: poppinsMedium,
        fontSize: getFontSizeExtraLarge(),
        color: AppColors.kPrimaryTextDarkColor,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomDefaultAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? action;
  const CustomDefaultAppbar({
    super.key,
    required this.title, this.leading, this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.kPrimaryColor,
      foregroundColor: AppColors.kWhiteColor,
      centerTitle: true,
      leading:leading ,
      actions: action,
      title: CustomText(
        text: title,
        style: poppinsMedium,
        fontSize: getFontSizeExtraLarge(),
        color: AppColors.kWhiteColor,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
