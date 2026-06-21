import 'package:flutter_svg/flutter_svg.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/image_constants.dart';
import 'package:navid_e_commerce/core/constants/padding_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/core/export/ui_export.dart';
import 'package:navid_e_commerce/presentations/home/controllers/home_controller.dart';

class SearchTextFieldWidget extends StatefulWidget {
  final TextEditingController searchController;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;

  const SearchTextFieldWidget({
    super.key,
    required this.searchController,
    this.focusNode,
    this.onChanged,
  });

  @override
  State<SearchTextFieldWidget> createState() => _SearchTextFieldWidgetState();
}

class _SearchTextFieldWidgetState extends State<SearchTextFieldWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      textEditingController: widget.searchController,
      focusNode: _focusNode,
      onChanged: widget.onChanged ??
          (value) {
            HomeController.to.applyFilters(search: value);
          },
      cursorColor: AppColors.kPrimaryColor,
      prefixIcon: Padding(
        padding: padding8,
        child: SvgPicture.asset(
          searchIcon,
        ),
      ),
      fillColor: AppColors.kPrimaryExtraLightColor,
      // ✅ hintText disappears when focused
      hintText: _focusNode.hasFocus ? null : 'Search here...',
      hintStyle: poppinsMedium.copyWith(
        color: AppColors.kPrimaryTextDarkColor,
        fontSize: getFontSizeSmall(),
      ),
    );
  }
}
