import 'package:flutter/widgets.dart';

class ScreenUtils {
  static bool isSmallScreen(BoxConstraints constraints) {
    return constraints.maxHeight < 600;
  }
}
