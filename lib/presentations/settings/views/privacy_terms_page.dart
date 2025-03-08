import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:navid_e_commerce/core/constants/app_static_strings.dart';
import 'package:navid_e_commerce/core/constants/fontsize_constant.dart';
import 'package:navid_e_commerce/core/constants/text_style_constant.dart';
import 'package:navid_e_commerce/presentations/home/widgets/default_scaffold_structure_widget.dart';

class PrivacyTermsPage extends StatelessWidget {
  static const String routeName = '/privacy';
  const PrivacyTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? argument = Get.arguments;
    return DefaultScaffoldStructureWidget(
        appBarTitle: argument != null && argument == 'terms'
            ? AppStaticStrings.termsOfUse
            : AppStaticStrings.privacyPolicy,
        children: [
          HtmlWidget(
            '''<html>
  <head>
    <title>Dummy HTML</title>
    <link href="style.css" rel="stylesheet" type="text/css" />
  </head>

  <body>
    <h1 class="wow">Heading 1</h1>

    <h2 id="head1">Sub Heading 1</h2>

    <p>
      Lorem, <a href="https://www.lipsum.com/">ipsum</a>
      dolor sit amet consectetur adipisicing elit.
    </p>

    <ul>
      <li>List item 1</li>
      <li class="wow">List item 2</li>
      <li>List item 3</li>
    </ul>

    <img src="images/lorem-ipsum1.jpg" />

    <h2 id="head2">Sub Heading 2</h2>
    <p>
      Lorem ipsum dolor sit amet consectetur adipisicing elit. Cum debitis
      molestias <span class="wow">omnis</span> voluptas, consequatur ex cumque
      velit libero quidem est?
    </p>
  </body>
</html>
''',
            textStyle: poppinsRegular.copyWith(fontSize: getFontSizeDefault()),
          )
        ]);
  }
}
