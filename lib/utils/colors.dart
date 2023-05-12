import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color lightGray = Color(0xFFDEDEDE);
  static const Color lightBlueGreen = Color(0xFF97BFBE);
  static const Color blueGreen = Color(0xFF7D9D9C);
  static const Color darkBlueGreen = Color(0xFF576F72);
  static const Color lightBeige = Color(0xFFF0EBE3);
  static const Color darkBeige = Color(0xFFBAA179);
  static Color grayShadow = darkBeige.withOpacity(0.2);
  static const LinearGradient blueGreenGradient = LinearGradient(
    colors: <Color>[
      Color(0xFFAFDEDD),
      Color(0xFF97BFBE),
      Color(0xFF7D9D9C),
      Color(0xFF576F72),
    ],
  );
}
