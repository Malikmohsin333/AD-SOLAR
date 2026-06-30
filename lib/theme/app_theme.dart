import 'package:flutter/material.dart';

class AppTheme {
  static const Color navyBlue = Color(0xFF002D62);
  static const Color greenBar = Color(0xFF43A047);
  static const Color amberBg = Color(0xFFFFF3CD);
  static const Color amberBorder = Color(0xFFFFEEBA);
  static const Color borderGrey = Color(0xFFCED4DA); // exact: #ced4da
  static const Color pageBg = Color(0xFFF0F2F5);
  static const Color labelGrey = Color(0xFF555555); // exact: .form-label #555
  static const Color iconGrey = Color(
    0xFF999999,
  ); // exact: .input-group-text #999

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: pageBg,
      primaryColor: navyBlue,
      colorScheme: ColorScheme.fromSeed(seedColor: navyBlue),
      fontFamily: 'Arial', // Helvetica Neue, Arial, sans-serif
    );
  }
}
