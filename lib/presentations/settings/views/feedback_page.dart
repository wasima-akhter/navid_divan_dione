import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navid_e_commerce/core/components/custom_textfield.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/color_constants.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';
import 'package:navid_e_commerce/presentations/settings/widgets/row_button_widget.dart';

class FeedbackPage extends StatelessWidget {
  static const String routeName = '/feedback';
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScaffoldStructureWidget(
        appBarTitle: AppStaticStrings.feedback,
        children: [
          CustomTextField(
            title: AppStaticStrings.userName,
            // textEditingController:
            // FeedBackController.to.userNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStaticStrings.nameRequired;
              }
              return null;
            },
          ),
          CustomTextField(
            title: AppStaticStrings.description,

            // textEditingController:
            // FeedBackController.to.feedbackController,
            /*   textEditingController: CreateTrackController
                      .to.uploadTrackDescriptionController.value,*/
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStaticStrings.nameRequired;
              }
              return null;
            },
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
                width: MediaQuery.sizeOf(context).width / 2,
                child: /* Obx(
                    () {
                  return */
                    RowButton(
                        // isLoading:
                        // FeedBackController.to.isLoadingFeedbackPost.value,
                        secondButtonTap: () {
                          // if(formKey.currentState!.validate()) {
                          //   FeedBackController.to.postFeedBackCall();
                          // }
                        },
                        radius: 8.r,
                        firstButtonText: AppStaticStrings.cancel,
                        // textColor: AppColors.kWhiteColor,
                        secendtButtonText: AppStaticStrings
                            .send) /*;
                }
            )*/
                ),
          )
        ]);
  }
}
