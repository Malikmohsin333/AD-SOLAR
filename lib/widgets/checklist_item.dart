import 'package:flutter/material.dart';

class ChecklistItem extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const ChecklistItem({
    super.key,
    required this.text,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF002D62),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              // .form-check-label: font-size 12px, font-weight 600, color #333
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
