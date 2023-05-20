import 'package:flutter/material.dart';

class CustomLinearGradient {
  static LinearGradient baseBackgroundDecoration(
      Color colorone, Color colortwo) {
    return LinearGradient(colors: [colorone, colortwo]);
  }
}
