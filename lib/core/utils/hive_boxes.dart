import 'package:hive_flutter/hive_flutter.dart';
import 'package:navid_e_commerce/core/utils/variable.dart';

class Boxes {
  static Box getUserData() => Hive.box(userBoxName);
}
