import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12, bottom: 8), // 12px 0 8px 0
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 6,
      ), // 6px 15px
      color: AppTheme.navyBlue,
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700, // 700
          fontSize: 13,
        ), // 13px
      ),
    );
  }
}
